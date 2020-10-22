//
//  TagDetailsViewController.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/24.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "TagDetailsViewController.h"

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
#import "ReportViewController.h"
#import "CommentSectionHeaderView.h"

static NSString *hotTextCellID = @"hotCellTextReuseIdentifier";
static NSString *hotVideoCellID = @"hotCellVideoReuseIdentifier";
static NSString *commentSectionHeaderID = @"BrainholeCommentSectionHeaderID";


@interface TagDetailsViewController () <UITableViewDelegate, UITableViewDataSource, HeaderViewDelegate> {
    UIView *tableHeaderView;
    UIImageView *backgroundImageView;

    UILabel *tagName;  //标签名称
    
    UILabel *item;  //项目
    UILabel *itemValue;  //帖子总数
    
    UILabel *hotIndex;  //热度指数
    UILabel *hotIndexValue;
    
    UIImageView *hotImageView;  //角标
    
    int loadDataCount;  //上拉加载

}
@property (nonatomic, strong) UITableView *hotBrainholeTableView;
@property (nonatomic, strong) NSMutableArray *braninholesArray;

@property (nonatomic, strong) HotBrainholeModel *selectedBrainholeModel;
@property (nonatomic, strong) NSMutableArray *videoIdArray;

@property (nonatomic, strong) SJPlayModel *playModel;
@property (nonatomic, strong) SJVideoPlayer *player;

@end

@implementation TagDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self registObserver];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.gk_navigationItem.title = @"标签";
    
    self.braninholesArray = @[].mutableCopy;

    [self getTagDetails];
    [self getBrainholeListBelongsToTag:@"0"];
    [self initBrainholeView];
}

/* 注册观察者 */
- (void)registObserver {
    //进入详情星球观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterStarDetailsView:) name:@"StarDetailsNotification" object:nil];

    //进入标签详情观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterTagDetailsView:) name:@"TagDetailsNotification" object:nil];

    //进入脑洞详情
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterToBrainholeDetailsView:) name:@"EnterToBrainholeDetailsNotification" object:nil];

    //进入视频详情
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterVideoDetailsView:) name:@"BrainholeVideoNotification" object:nil];

    //脑洞底栏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFooterDetailsView:) name:@"BrainholeCellFooterNotification" object:nil];

    //视频播放通知
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

/* 脑洞详情 */
- (void)enterToBrainholeDetailsView:(NSNotification *)notification {
    HotBrainholeModel *brainModel = notification.object;
    BrainholeDetailsViewController *brainholeVC = [[BrainholeDetailsViewController alloc] init];
    brainholeVC.brainholeId = brainModel.id;
    brainholeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:brainholeVC animated:YES];
}

/* 星球详情 - 星球列表 */
- (void)enterStarDetailsView:(NSNotification *)notification {
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
        [RequestHandle likeForBrainhole:@{ @"postid":@(brainholeModel.id)} authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
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
        
        NSString *title = self.selectedBrainholeModel.title;
        
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



#pragma mark -- 主视图 --

- (void)initBrainholeView {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    tableHeaderView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectZero];
    tableHeaderView.frame = CGRectMake(16, 0, SCREENWIDTH - 32, 162);
    tableHeaderView.backgroundColor = [UIColor redColor];
    
    //背景图片
    CGRect bgFrame = CGRectMake(0, 0, SCREENWIDTH, 162);
    backgroundImageView = [[UIImageView alloc] initWithFrame:bgFrame];
    [tableHeaderView addSubview:backgroundImageView];
    
    tagName = [[UILabel alloc] initWithFrame:CGRectZero];
    tagName.textAlignment = NSTextAlignmentLeft;
    [tableHeaderView addSubview:tagName];

    //项目
    item = [[UILabel alloc] initWithFrame:CGRectZero];
    [tableHeaderView addSubview:item];

    item.text = @"项目";
    item.font = PingFangSC_Regular(12);
    item.textColor = UICOLOR(@"#FFFFFF");

    itemValue = [[UILabel alloc] initWithFrame:CGRectZero];
    [tableHeaderView addSubview:itemValue];

    itemValue.font = PingFangSC_Regular(18);
    itemValue.textColor = UICOLOR(@"#FFFFFF");

    hotIndex = [[UILabel alloc] initWithFrame:CGRectZero];
    [tableHeaderView addSubview:hotIndex];

    hotIndex.text = @"热度指数";
    hotIndex.font = PingFangSC_Regular(12);
    hotIndex.textColor = UICOLOR(@"#FFFFFF");

    hotIndexValue = [[UILabel alloc] initWithFrame:CGRectZero];
    [tableHeaderView addSubview:hotIndexValue];

    hotIndexValue.font = PingFangSC_Regular(18);
    hotIndexValue.textColor = UICOLOR(@"#FFFFFF");

    hotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11.5, 5.5)];  //隐藏  一定数值显示
    [tableHeaderView addSubview:hotImageView];
    
    hotImageView.image = [UIImage imageNamed:@"hot.png"];
    
    //热门脑洞
    CGRect tableViewFrame = CGRectMake(0, StatusAndNaviHeight, SCREENWIDTH, SCREENHEIGHT);
    self.hotBrainholeTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.hotBrainholeTableView.delegate = self;
    self.hotBrainholeTableView.dataSource = self;
    self.hotBrainholeTableView.estimatedRowHeight = 300;
    self.hotBrainholeTableView.rowHeight = UITableViewAutomaticDimension;
    self.hotBrainholeTableView.showsVerticalScrollIndicator = NO;
    self.hotBrainholeTableView.tableFooterView = [UIView new];  //不显示多余的分割线
//    self.hotBrainholeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     self.hotBrainholeTableView.separatorInset=UIEdgeInsetsMake(5, 0, 5, 0);
    self.hotBrainholeTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.hotBrainholeTableView.separatorColor = UICOLOR(@"#F6F6F6");
    
    self.hotBrainholeTableView.tableHeaderView = tableHeaderView;
    [self.view addSubview:self.hotBrainholeTableView];

    //下拉刷新
    StarRefreshGifHeader *header = [StarRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.hotBrainholeTableView.mj_header = header;

    //上拉加载
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(pull)];
    footer.stateLabel.hidden = YES;
    self.hotBrainholeTableView.mj_footer = footer;
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.hotBrainholeTableView layoutIfNeeded];  //重新获取header高度
    self.hotBrainholeTableView.tableHeaderView = tableHeaderView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [tagName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(34);
        make.left.mas_offset(16);
        make.height.mas_equalTo(18);
    }];
    
    [item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagName.mas_bottom).mas_offset(26);
        make.left.mas_offset(16);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(12);
    }];
     
    [itemValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagName.mas_bottom).mas_offset(20);
        make.left.equalTo(item.mas_right).mas_offset(6);
        make.height.mas_equalTo(18);
    }];
     
    [hotIndex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagName.mas_bottom).mas_offset(26);
        make.left.equalTo(itemValue.mas_right).mas_offset(30);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(12);
    }];
     
    [hotIndexValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagName.mas_bottom).mas_offset(20);
        make.left.equalTo(hotIndex.mas_right).mas_offset(6);
        make.height.mas_equalTo(18);
    }];
    
    [hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hotIndexValue).mas_offset(2);
        make.left.equalTo(hotIndexValue.mas_right).mas_offset(5);
        make.width.mas_equalTo(11.5);
        make.height.mas_equalTo(5.5);
    }];
    
    [self.hotBrainholeTableView.tableHeaderView layoutIfNeeded];  //重点
}

#pragma mark -- 数据更新 --

/* 更新标签详情数据 */
- (void)updateTagDetails:(NSDictionary *)dic {
    tagName.text = [NSString stringWithFormat:@"#%@#", dic[@"tagTitle"]];
    self.gk_navigationItem.title = dic[@"tagTitle"];
    itemValue.text = [NSString stringWithFormat:@"%li",  (long)[dic[@"postNum"] integerValue]];
    hotIndexValue.text = [NSString stringWithFormat:@"%li", (long)[dic[@"tagHot"] integerValue]];
    [backgroundImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"starFile"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];  //修改背景图片占位图
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view setNeedsUpdateConstraints];  //更新布局
    });
}

#pragma mark -- 数据请求 --

/* 下拉刷新 */
- (void)refresh {
    loadDataCount = 0;
    [self getBrainholeListBelongsToTag:@"0"];
}

/* 上拉加载 */
- (void)pull {
    [self getBrainholeListBelongsToTag:@"0"];
}

/* 停止刷新 */
- (void)endRefreshing {
    [self.hotBrainholeTableView.mj_header endRefreshing];
    [self.hotBrainholeTableView.mj_footer endRefreshing];
}

/* 请求标签详情 */
- (void)getTagDetails {
    NSString *token = [AppCacheManager sharedSession].token;
    [RequestHandle getTagDetails:@{@"id":@(self.tagId)} authorization:token success:^(id  _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            [self endRefreshing];
            return;
        }
        [self updateTagDetails:response[@"data"]];
    } fail:^(NSError * _Nonnull error) {
    }];
}

#pragma mark -- 点击事件 --

- (void)getBrainholeListBelongsToTag:(NSString *)sort {
    //考虑 返回失败不删除数据的情况
    loadDataCount++;
    if (loadDataCount == 1) {
        if (self.braninholesArray && self.braninholesArray.count > 0) {
            [self.braninholesArray removeAllObjects];  //清空
        }
    }
    
    NSString *token = [AppCacheManager sharedSession].token;
    NSDictionary *param = @{
                             @"sort":@"oilNum",
                             @"tagId":@(self.tagId),
                             @"pageNum":@(loadDataCount),
                             @"pageSize":@(10)
                           };
    [RequestHandle getBrainholeListBelongsToTag:param authorization:token success:^(id  _Nullable response) {
         if ([response[@"code"] integerValue] != 0) {
            [self endRefreshing];
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
        if (list.count > 0) {
            [self.hotBrainholeTableView reloadData];
            [self.hotBrainholeTableView setNeedsLayout];
        }
        [self endRefreshing];
        
    } fail:^(NSError * _Nonnull error) {
        [self endRefreshing];
        self->loadDataCount--;
    }];
}


#pragma mark -- 脑洞列表代理方法 --

//评论查询 - 时间
- (void)sortByTime:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString *sort = @"oilNum";
    if (sender.selected) {
        sort = @"-oilNum";
    }
    [self getBrainholeListBelongsToTag:sort];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CommentSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:commentSectionHeaderID];
    if(!headerView){
        headerView = [[CommentSectionHeaderView alloc] initWithReuseIdentifier:commentSectionHeaderID];
        headerView.delegate = self;
    }
    return headerView;
}

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
        [cell layoutIfNeeded];  //重要
        return cell;
    } else {
        HotBrainholeVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotVideoCellID];
           if (!cell) {
               cell = [[HotBrainholeVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotVideoCellID];
           }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.brainholeModel = model;
        cell.brainholeModel.tableViewCellIndex = indexPath;
        [cell layoutIfNeeded];  //重要
        return cell;
    }
    return nil;
}

@end
