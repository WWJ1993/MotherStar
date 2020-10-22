//
//  CommonViewController.m
//  MotherStar
//
//  Created by 王文杰 on 2020/2/4.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "CommonViewController.h"

#import "CycleModel.h"
#import "CarouselsCollectionViewCell.h"
#import "StarListView.h"
#import "StarModel.h"
#import "HotBrainholeTextTableViewCell.h"
#import "HotBrainholeModel.h"
#import "TagModel.h"

#import "VideoDetailsViewController.h"
#import "BrainholeDetailsViewController.h"
#import "TagDetailsViewController.h"
//#import "StarDetailsViewController.h"
#import "StarDetailViewController.h"

#import "HotBrainholeVideoTableViewCell.h"
#import "HotBrainholeVideoModel.h"
#import "WebViewController.h"
#import "CarouselsView.h"
#import "HotBrainholeVideoCollectionViewCell.h"
#import "SearchViewController.h"
#import "StarRefreshGifHeader.h"
#import "SJPlayModel.h"
#import "LYEmptyViewHeader.h"
#import "ReportViewController.h"

static NSString *hotTextCellID = @"hotCellTextReuseIdentifier";
static NSString *hotVideoCellID = @"hotCellVideoReuseIdentifier";

@interface CommonViewController () <UITableViewDelegate, UITableViewDataSource> {
    int loadDataCount;  //上拉加载
    NSString *firstPictureUrl;  //脑洞第一张图片地址


}
@property (nonatomic, strong) SJPlayModel *playModel;
@property (nonatomic, strong) SJVideoPlayer *player;

@property (nonatomic, strong) HotBrainholeModel *selectedBrainholeModel;
@property (nonatomic, strong) NSMutableArray *videoIdArray;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation CommonViewController


- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewSafeAreaInsetsDidChange {
    NSLog(@"A: %@", NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
    [super viewSafeAreaInsetsDidChange];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = YES;
    [self registObserver];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];   //test
    [self.player vc_viewWillDisappear];
    
    [self removeObserver];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player vc_viewDidDisappear];
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    loadDataCount = 0;
    self.braninholesArray = @[].mutableCopy;

    
//    [self requestMineLikeList];

    //热门脑洞
    self.hotBrainholeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.hotBrainholeTableView.frame = CGRectMake(0, CGRectGetMaxY(self.gk_navigationBar.frame), SCREENWIDTH, SCREENHEIGHT-CGRectGetMaxY(self.gk_navigationBar.frame));
    self.hotBrainholeTableView.delegate = self;
    self.hotBrainholeTableView.dataSource = self;
    self.hotBrainholeTableView.estimatedRowHeight = 300;
    self.hotBrainholeTableView.rowHeight = UITableViewAutomaticDimension;
    self.hotBrainholeTableView.showsVerticalScrollIndicator = NO;
    self.hotBrainholeTableView.tableFooterView = self.footerView;  //不显示多余的分割线
    self.hotBrainholeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.hotBrainholeTableView];

    StarRefreshGifHeader *header = [StarRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.hotBrainholeTableView.mj_header = header;

//    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(pull)];
//    footer.stateLabel.hidden = YES;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector((pull))];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"———————— The End ————————" forState:MJRefreshStateNoMoreData];
    self.hotBrainholeTableView.mj_footer = footer;
}

/* 注册观察者 */
- (void)registObserver {
    //注册星球观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterStarDetailsView:) name:@"StarDetailsNotification" object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterTagDetailsView:) name:@"TagDetailsNotification" object:nil];

    //进入脑洞详情
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterToBrainholeDetailsView:) name:@"EnterToBrainholeDetailsNotification" object:nil];

    //脑洞底栏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFooterDetailsView:) name:@"BrainholeCellFooterNotification" object:nil];

    //注册视频观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterVideoDetailsView:) name:@"BrainholeVideoNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePlayVideoNotification:) name:@"ReceivePlayVideoNotification" object:nil];
}

/* 移除观察者 */
- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StarDetailsNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EnterToBrainholeDetailsNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BrainholeCellFooterNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BrainholeVideoNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReceivePlayVideoNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TagDetailsNotification" object:nil];
}
- (void) dealloc{
   
}

#pragma mark -- 通知 --

- (void)enterToBrainholeDetailsView:(NSNotification *)notification {
    HotBrainholeModel *brainModel = notification.object;
    BrainholeDetailsViewController *brainholeVC = [[BrainholeDetailsViewController alloc] init];
    brainholeVC.brainholeId = brainModel.id;
    brainholeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:brainholeVC animated:YES];
}


/* 全屏播放通知 */
- (void)receivePlayVideoNotification:(NSNotification *)notification {
//视图层次
//    --  UITableView
//    --  UITableViewCell
//    --  UITableViewCell.UICollectionView
//    --  UICollectionViewCell
//    --  Player.superview
//    --  Player.view
    
    HotBrainholeVideoCollectionViewCell *videoCollectionViewCell = notification.object;
    HotBrainholeVideoModel *videoModel = videoCollectionViewCell.hotBrainholeVideoModel;
    
    //TableViewCell部分
    NSIndexPath *tableViewCellIndex = videoModel.tableViewCellIndex;
    NSInteger collectionViewTag = videoModel.collectionViewTag;
    
    //Collection部分
    NSInteger playerSuperViewTag = videoModel.playerSuperViewTag;
    NSIndexPath *collectionViewCellIndex = videoModel.collectionViewCellIndexPath;
    
    _playModel = [SJPlayModel UICollectionViewNestedInUITableViewCellPlayModelWithPlayerSuperviewTag:playerSuperViewTag atIndexPath:collectionViewCellIndex collectionViewTag:collectionViewTag collectionViewAtIndexPath:tableViewCellIndex tableView:self.hotBrainholeTableView];
  
    _player = [SJVideoPlayer player];
    _player.autoplayWhenSetNewAsset = NO;
    
    _player.fastForwardViewController.enabled = YES;
    
    
    // - - - - - - - - - - - 重点 - - - - - - - - - - - - - - - - - - - - - - - - - -
    _player.rotationManager.disabledAutorotation = YES;  //禁止自动旋转
    _player.rotationManager.autorotationSupportedOrientations = SJOrientationMaskAll;
    
    _player.autoManageViewToFitOnScreenOrRotation = NO;
     _player.useFitOnScreenAndDisableRotation = NO;
    [_player rotate:SJOrientation_LandscapeLeft animated:YES];  //强制旋转
         
    WeakSelf

    _player.rotationObserver.rotationDidEndExeBlock = ^(id<SJRotationManagerProtocol>  _Nonnull mgr) {
        weakSelf.player.autoManageViewToFitOnScreenOrRotation = YES;
        weakSelf.player.useFitOnScreenAndDisableRotation = NO;
        
    };
    
    //触发旋转
    _player.rotationManager.shouldTriggerRotation = ^BOOL(id<SJRotationManager>  _Nonnull mgr) {
        return YES;
    };
    // - - - - - - - - - - - 重点 - - - - - - - - - - - - - - - - - - - - - - - - - -
    [videoCollectionViewCell.playerSuperView addSubview:_player.view];  //播放器添加到父视图
    
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    NSURL *videoUrl = [NSURL URLWithString:videoModel.urlPainting];
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:videoUrl playModel:_playModel];
}

/* 星球详情 */
- (void)enterStarDetailsView:(NSNotification *)notification {
//    NSNumber *starId = notification.object;
//    NSInteger sId = [starId integerValue] ;
    StarDetailViewController *starVC = [[StarDetailViewController alloc] init];
    starVC.pid = [notification.object stringValue];  //修改星球详情的id为整形
    starVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:starVC animated:YES];
}

/* 标签详情 */
- (void)enterTagDetailsView:(NSNotification *)notification {
    IXAttributeModel *IXModel = notification.object;
    TagDetailsViewController *tagVC = [[TagDetailsViewController alloc] init];
    tagVC.tagId = IXModel.id;
    tagVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tagVC animated:YES];
}

/* 底栏 - 星球 点赞 分享 */
- (void)enterFooterDetailsView:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    NSInteger tag =  [dic[@"tag"] integerValue];
    HotBrainholeModel *brainholeModel = dic[@"brainholeModel"];
    self.selectedBrainholeModel = brainholeModel;
    
    if (tag == 11) {
        //星球
        StarDetailViewController *starVC = [[StarDetailViewController alloc] init];
        starVC.pid = brainholeModel.starTagId;
        starVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:starVC animated:YES];
    } else if (tag == 12) {
        //点赞
        NSString *token = [AppCacheManager sharedSession].token;
        if (!token) {
            [MyProgressHUD showErrorWithStatus:@"非注册用户无法点赞" duration:1.0];
            return;
        }
        [RequestHandle likeForBrainhole:@{ @"postid":@(brainholeModel.id) } authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        } success:^(id  _Nullable response) {
        
        } fail:^(NSError * _Nonnull error) {
            
        }];
    } else {
        //分享
        [self showShareView];
    }
    
}

/* 弹出分享视图 */
- (void)showShareView{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
    
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        NSString *title = self.self.selectedBrainholeModel.title;
        
        NSArray *textArray = [GlobalHandle filterTextFromHTML:self.self.selectedBrainholeModel.content];
        NSString *text = @"";
        if (textArray && textArray.count > 0) {
            text = textArray[0];
            if (text.length > 15) {
                [text substringToIndex:15];
            }
        }
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:[UIImage imageNamed:@"appicon"]];

        NSString *token = [AppCacheManager sharedSession].token;
        NSString *ids = @"";
        
        NSArray *videoModelArray = self.selectedBrainholeModel.videoArray;
        self.videoIdArray = @[].mutableCopy;
        for (NSInteger i = 0; i < videoModelArray.count; i++) {
            HotBrainholeVideoModel *videoModel = videoModelArray[i];
            NSString *videoId = [NSString stringWithFormat:@"%li",(long)videoModel.id];
            [self.videoIdArray addObject:videoId];
        }
        
        if (self.videoIdArray && self.videoIdArray.count > 0) {
            for (NSInteger i = 0; i < self.videoIdArray.count; i++) {
                NSString *videoIdStr = self.videoIdArray[i];
                videoIdStr = [videoIdStr stringByAppendingString:@","];
                ids = [ids stringByAppendingString:videoIdStr];
            }
        }
        
        NSString *baseUrl = BaseUrl;
        baseUrl = [baseUrl stringByReplacingOccurrencesOfString:@"api"withString:@""];
        NSString *webpageUrl = [NSString stringWithFormat:@"%@index.html?token=%@&id=%li&ids=%@",baseUrl, token, self.selectedBrainholeModel.id, ids];
        shareObject.webpageUrl = webpageUrl;
        
        if (platformType == 1001) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = webpageUrl;
        } else if (platformType == 1002) {
             //屏蔽
        } else if (platformType == 1003) {
            //举报
            ReportViewController *reportVC = [[ReportViewController alloc] init];
            [self.navigationController pushViewController:reportVC animated:YES];
        } else if (platformType == 1004) {
             //更多
        } else {
            [self shareBrainhole];  //分享次数+1
        }

        messageObject.shareObject = shareObject;
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (!error) {
                [self shareBrainhole];  //分享数+1
            }
        }];
    }];
}

- (void)shareBrainhole {
    NSDictionary *param = @{
                             @"id":@(self.selectedBrainholeModel.id),
                             @"aType":@(0),
                           };
    NSString *token = [AppCacheManager sharedSession].token;
    [RequestHandle shareBrainhole:param authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        
    } fail:^(NSError * _Nonnull error) {
        
    }];
}


/* 进入视频详情 */
- (void)enterVideoDetailsView:(NSNotification *)notification {
    NSNumber *vId = notification.object;
    NSInteger videoId = [vId integerValue] ;
    VideoDetailsViewController *videoVC = [[VideoDetailsViewController alloc] init];
    videoVC.brainholeVideoId = videoId;
    videoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoVC animated:YES];
}



- (void)showToast {
//    MotherPlanetAlertView *alertView = [[MotherPlanetAlertView alloc] init:@"退出登录" message:@"确定退出登录" ok:@"确定" cancel:@"取消"];
//    alertView.okBlock = ^(){
//
//    };
}



#pragma mark -- 数据请求 --

//下拉刷新
- (void)refresh {
    loadDataCount = 0;
    [self loadData];
}

//上拉加载
- (void)pull {
    [self loadData];
}

- (void)loadData {
    //考虑 返回失败不删除数据的情况
    loadDataCount++;
    if (loadDataCount == 1) {
        if (self.braninholesArray && self.braninholesArray.count > 0) {
            [self.braninholesArray removeAllObjects];  //清空
        }
    }
    NSString *Url = [BaseUrl stringByAppendingFormat:@"%@", self.url];
    NSDictionary *param = @{
                             @"pageNum":@(loadDataCount),
//                             @"pageSize":@(10)
                           };
    [self.params addEntriesFromDictionary:param];
    NSString *token = [AppCacheManager sharedSession].token;
    [[RequestManager sharedInstance] GET:Url parameters:self.params authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {        
        if ([response[@"code"] integerValue] != 0) {
//                    [self endRefreshing];
            if ([self.hotBrainholeTableView.mj_header isRefreshing]) {
                [self.hotBrainholeTableView.mj_header endRefreshing];
            }
            if ([self.hotBrainholeTableView.mj_footer isRefreshing]) {
                [self.hotBrainholeTableView.mj_footer endRefreshing];
            }
            return;
            
        }
                NSArray *list = response[@"data"][@"list"];
                if (list.count == 0) {
                    self->loadDataCount--;
                }
                
                for (NSInteger i = 0; i < list.count; i++) {
                    @autoreleasepool {
                        NSDictionary *brainholeDic = list[i][@"hotPost"][@"post"];  //脑洞
                        HotBrainholeModel *brainholeModel = [HotBrainholeModel mj_objectWithKeyValues:brainholeDic];
                        
                        NSArray *tagArray = list[i][@"tagDto"][@"tags"];  //脑洞标签
                        NSMutableArray *tagModelAraay = @[].mutableCopy;
                        for (NSInteger i = 0; i < tagArray.count; i++) {
                            NSDictionary *tagDic = tagArray[i];
                            TagModel *tagModel = [TagModel mj_objectWithKeyValues:tagDic];
                            [tagModelAraay addObject:tagModel];
                        }
                        
                        brainholeModel.tagArray = [tagModelAraay copy];
                        
                        if (brainholeModel == nil) {
                            continue;
                        }
                        
                        NSInteger orgial = brainholeModel.original;  //原创标记
                        BOOL orgialBool = NO;
                        if (orgial == 0) {
                            orgialBool = YES;
                        }
                        //转换为富文本
                        NSDictionary *contentDic = [GlobalHandle handleBrainholeContent:orgialBool title:brainholeModel.title content:brainholeModel.content];
                        
                        NSAttributedString *contentAttribute = contentDic[@"contentAttString"];
                        NSString *firstPictureUrl = contentDic[@"firstPictureUrl"];
                        
                        brainholeModel.firstPictureUrl = firstPictureUrl;  //脑洞第一张图片
                        brainholeModel.contentAttribute = contentAttribute;
                        
                        //获取视频
                        brainholeModel.videoArray = @[].mutableCopy;

                        NSDictionary *userDic = list[i][@"hotPost"][@"user"];
                        if (![userDic isKindOfClass:[NSNull class]]) {
                            brainholeModel.nickName = userDic[@"nickName"];  //增加用户头像和昵称
                            brainholeModel.picUrl = userDic[@"picUrl"];
                        }

                        NSArray *videoArray = list[i][@"hotPost"][@"videoList"];  //视频
                        if (videoArray.count > 0) {
                            brainholeModel.brainholeType = 1;  //含视频
                            for (NSInteger j = 0; j < videoArray.count; j++) {
                                 NSDictionary *videoDic = videoArray[j];
                                 HotBrainholeVideoModel *vModel = [HotBrainholeVideoModel mj_objectWithKeyValues:videoDic];
                                [brainholeModel.videoArray addObject:vModel];
                            }
                        } else if (videoArray.count == 0){
                            brainholeModel.brainholeType = 0;
                        }
                      
                        [self.braninholesArray addObject:brainholeModel];
                     }
                }
                
        if ([self.hotBrainholeTableView.mj_header isRefreshing]) {
            MJRefreshDispatchAsyncOnMainQueue(self.hotBrainholeTableView.mj_footer.state = MJRefreshStateIdle;)
            [self.hotBrainholeTableView.mj_header endRefreshing];
        }
        
        if ([self.hotBrainholeTableView.mj_footer isRefreshing]) {
            if (list.count) {
                if (self.footerView.frame.size.height>0) {
                    self.footerView.frame = CGRectMake(0, 0, SCREENWIDTH, 0);
                }
                [self.hotBrainholeTableView.mj_footer endRefreshing];
            }else{
                CGFloat height = 0;
                for (int i = 0; i<self.braninholesArray.count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    height += [self.hotBrainholeTableView rectForRowAtIndexPath:indexPath].size.height;
                }
                self.footerView.frame = CGRectMake(0, 0, SCREENWIDTH, self.hotBrainholeTableView.frame.size.height - height>0?self.hotBrainholeTableView.frame.size.height - height:0);
                [self.hotBrainholeTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.hotBrainholeTableView reloadData];
        [self.hotBrainholeTableView setNeedsLayout];
            

        [self noDataArray];
        if (self.loadBlock) {
            self.loadBlock();
        }
    } failure:^(NSError * _Nonnull error) {
        [self endRefreshing];
        self->loadDataCount--;
        [self noNetWork];
    }];
    
}


- (void)endRefreshing {
    [self.hotBrainholeTableView.mj_header endRefreshing];
//    [self.hotBrainholeTableView.mj_footer endRefreshing];
}

#pragma mark -- 脑洞列表代理方法 --



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.braninholesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotBrainholeModel *model = [[HotBrainholeModel alloc] init];
    if (self.braninholesArray && self.braninholesArray.count > 0 ) {
        model = self.braninholesArray[indexPath.row];
    }
    
    if (model.brainholeType == 0) {
        HotBrainholeTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotTextCellID];
        if (!cell) {
            cell = [[HotBrainholeTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotTextCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.brainholeModel = model;
        [cell layoutIfNeeded];
        return cell;
        
    } else {
        HotBrainholeVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotVideoCellID];
           if (!cell) {
               cell = [[HotBrainholeVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotVideoCellID];
           }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.brainholeModel = model;
        cell.brainholeModel.tableViewCellIndex = indexPath;
        [cell layoutIfNeeded];
        return cell;
    }
    return nil;
}

- (NSMutableDictionary *)params{
    if (!_params) {
        _params = [NSMutableDictionary new];
    }
    return _params;
}



#pragma mark ============================================
- (void)noDataArray{
    if (!self.braninholesArray.count) {
        [self.hotBrainholeTableView reloadData];
        LYEmptyView *ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                              titleStr:@"暂无数据"
                                                             detailStr:@""];
        ly_emptyView.titleLabFont = [UIFont systemFontOfSize:15];
        ly_emptyView.titleLabTextColor = [UIColor colorWithHex:@"D9D9D9"];
        self.hotBrainholeTableView.ly_emptyView = ly_emptyView;
    }
}
- (void)noNetWork{
    if (!self.braninholesArray.count) {
        LYEmptyView *ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                              titleStr:@"网络断开"
                                                             detailStr:@"重试"];
        ly_emptyView.titleLabFont = [UIFont systemFontOfSize:15];
        ly_emptyView.titleLabTextColor = [UIColor colorWithHex:@"D9D9D9"];
        ly_emptyView.detailLabFont = [UIFont systemFontOfSize:15];
        ly_emptyView.detailLabTextColor = [UIColor colorWithHex:@"EFB400"];
        ly_emptyView.tapEmptyViewBlock = ^{
            [self.hotBrainholeTableView.mj_header beginRefreshing];
        };
        self.hotBrainholeTableView.ly_emptyView = ly_emptyView;
    }
}
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView new];
    }
    return _footerView;
}


@end
