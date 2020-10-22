//
//  StarViewController.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/17.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "StarViewController.h"
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
#import "ReportViewController.h"
#import "OilingViewController.h"

static NSString *hotTextCellID = @"hotCellTextReuseIdentifier";
static NSString *hotVideoCellID = @"hotCellVideoReuseIdentifier";

@interface StarViewController () <CarouselsCollectionViewDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    CarouselsView *carouselsView;  //轮播背景
    UIView *tableHeaderView;  //头视图 放置轮播、星球列表
    UIView *cycleArea;  //轮播区
    StarListView *plantArea;  //星球列表
    CGFloat starListViewHeight;

    UIView *hotBrainholeArea;  //热门脑洞
    UILabel *hotBrainhole;
    
    int loadDataCount;  //上拉加载
    
    BOOL removeObserver;
}

@property (nonatomic, strong) UITableView *hotBrainholeTableView;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIBarButtonItem *dayBar;
@property (nonatomic, strong) UIBarButtonItem *monthBar;

@property (nonatomic, strong) UIBarButtonItem *searchBar;

@property (nonatomic, strong) NSMutableArray *bannerImages;  //测试

@property (nonatomic, strong) NSMutableArray *cycleArray;

@property (nonatomic, strong) NSMutableArray *starsArray;

@property (nonatomic, strong) NSMutableArray *braninholesArray;

@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, strong) SJPlayModel *playModel;
@property (nonatomic, strong) SJVideoPlayer *player;

@property (nonatomic, strong) HotBrainholeModel *selectedBrainholeModel;
@property (nonatomic, strong) NSMutableArray *videoIdArray;

@end

@implementation StarViewController

#pragma mark -- 播放器设置 --
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
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
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
    
    self.gk_navTitleView = self.titleView;
    self.gk_navLeftBarButtonItems = @[self.dayBar, self.monthBar];
    self.gk_navRightBarButtonItem = self.searchBar;
    
    self.cycleArray = @[].mutableCopy;
    self.starsArray = @[].mutableCopy;
    self.braninholesArray = @[].mutableCopy;
        
    [self requestAll];
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

- (void)dealloc {
   
}

- (NSMutableArray *)braninholesArray {
    if (_braninholesArray == nil) {
        _braninholesArray = [NSMutableArray array];
    }
    return _braninholesArray;
}

/* 星球列表 */
- (void)updateStarList {

}


/* 打开所有UILabel UserInteractionEnabled 属性*/
- (void)getSub:(UIView *)view andLevel:(int)level {
    NSArray *subviews = [view subviews];
    // 如果没有子视图就直接返回
    if ([subviews count] == 0)
        return;

    for (UIView *subview in subviews) {
     // 根据层级决定前面空格个数，来缩进显示
     NSString *blank = @"";
     for (int i = 1; i < level; i++) {
         blank = [NSString stringWithFormat:@"  %@", blank];
     }
     
    if ([subview isMemberOfClass:[UILabel class]] || [subview isMemberOfClass:[UIImageView class]] ) {
        subview.userInteractionEnabled = YES;
    }
     // 打印子视图类名
     NSLog(@"%@%d: %@", blank, level, subview.class);
             
     // 递归获取此视图的子视图
     [self getSub:subview andLevel:(level+1)];
    }
    
}

- (UIViewController *)getViewController {
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}
- (void)handleVideoPlay {
    
}

#pragma mark -- 通知 --

/* 脑洞详情 */
- (void)enterToBrainholeDetailsView:(NSNotification *)notification {
    HotBrainholeModel *brainModel = notification.object;
    BrainholeDetailsViewController *brainholeVC = [[BrainholeDetailsViewController alloc] init];
    brainholeVC.brainholeId = brainModel.id;
    brainholeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:brainholeVC animated:YES];
}

/* 进入视频详情 */
- (void)enterVideoDetailsView:(NSNotification *)notification {
    NSDictionary *videoDic = notification.object;
    NSInteger videoId = [videoDic[@"videoId"] integerValue];
    NSArray *videoArray = videoDic[@"videoModelArray"];
    NSInteger index = [videoDic[@"index"] integerValue];
    
    VideoDetailsViewController *videoVC = [[VideoDetailsViewController alloc] init];
    videoVC.brainholeVideoId = videoId;
    videoVC.videoArray = videoArray;
    videoVC.index = index;
    videoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoVC animated:YES];

//    NSNumber *vId = notification.object;
//    NSInteger videoId = [vId integerValue];
//    VideoDetailsViewController *videoVC = [[VideoDetailsViewController alloc] init];
//    videoVC.brainholeVideoId = videoId;
//    videoVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:videoVC animated:YES];
    
}

/* 星球详情 - 星球列表 */
- (void)enterStarDetailsView:(NSNotification *)notification {
//    NSNumber *starId = notification.object;
//    NSInteger sId = [starId integerValue] ;
    removeObserver = YES;

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
        NSString *webpageUrl = [NSString stringWithFormat:@"%@index.html?token=%@&id=%li&ids=%@",baseUrl, token, (long)self.selectedBrainholeModel.id, ids];
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
            [self shareBrainhole];  //分享数+1
            [self getHotBrainholeList];
        }

        messageObject.shareObject = shareObject;
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (!error) {
            }
        }];
    }];
}

/* 分享次数 */
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


- (void)showToast {
//    MotherPlanetAlertView *alertView = [[MotherPlanetAlertView alloc] init:@"退出登录" message:@"确定退出登录" ok:@"确定" cancel:@"取消"];
//    alertView.okBlock = ^(){
//
//    };
}

#pragma mark -- 主视图 --

- (void)initBrainholeView {
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    tableHeaderView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectZero];
    tableHeaderView.frame = CGRectMake(16, 0, SCREENWIDTH - 32, 547);
//    tableHeaderView.backgroundColor = [UIColor redColor];
    
    
    //轮播
    CGRect carouselsRect = CGRectMake(0, StatusAndNaviHeight, SCREENWIDTH, 257);
    carouselsView = [[CarouselsView alloc] initWithFrame:carouselsRect bannerImgWidth:SCREENWIDTH - 32 bannerImgHeight:257 leftRightSpace:16 itemSpace:10];
    carouselsView.delegate = self;
//    carouselsView.backgroundColor = [UIColor redColor];
//    carouselsView.backgroundColor = [UIColor clearColor];

    [tableHeaderView addSubview:carouselsView];
    
    //投影
//    carouselsView.layer.shadowOffset = CGSizeMake(0, 10);
//    carouselsView.layer.shadowColor = UICOLOR(@"#6D6D6D").CGColor;
//    carouselsView.layer.shadowOpacity = 0.3;
//    carouselsView.layer.shadowRadius = 8.0;


    //星球   动态高度   修改
    plantArea = [[StarListView alloc] initWithFrame:CGRectZero];
    [tableHeaderView addSubview:plantArea];

    
    //热门脑洞
    hotBrainholeArea = [[UIView alloc] initWithFrame:CGRectZero];
    [tableHeaderView addSubview:hotBrainholeArea];

    hotBrainhole = [[UILabel alloc] initWithFrame:CGRectZero];
    hotBrainhole.textAlignment = NSTextAlignmentCenter;
    hotBrainhole.text = @"热门脑洞";
    hotBrainhole.font = PingFangSC_Medium(18);
    hotBrainhole.textColor = UICOLOR(@"#343338");
    [hotBrainholeArea addSubview:hotBrainhole];

    
    //热门脑洞
    self.hotBrainholeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//    header.lastUpdatedTimeLabel.hidden = YES;
    
    StarRefreshGifHeader *header = [StarRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.hotBrainholeTableView.mj_header = header;

    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(pull)];
    footer.stateLabel.hidden = YES;
    self.hotBrainholeTableView.mj_footer = footer;
    
    [self.view setNeedsUpdateConstraints];  //更新布局
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    tableHeaderView.frame = CGRectMake(16, StatusAndNaviHeight, SCREENWIDTH - 32, 547);
    self.hotBrainholeTableView.tableHeaderView = tableHeaderView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

#pragma mark -- 视图布局 --

- (void)updateViewConstraints {
    
    [self.hotBrainholeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusAndNaviHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);  //footerBar
    }];
       
    [tableHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
//        make.height.mas_equalTo(527);
        make.width.mas_equalTo(SCREENWIDTH);
        make.bottom.equalTo(hotBrainholeArea.mas_bottom).mas_offset(47);
    }];
    
    [carouselsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(257);  //默认
    }];
   
    [plantArea mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carouselsView.mas_bottom).offset(40);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.mas_equalTo(169);
    }];
    
    [hotBrainholeArea mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(plantArea.mas_bottom).offset = 40;
        make.width.mas_equalTo(SCREENWIDTH - 32);
        make.height.equalTo(@18);
        make.bottom.mas_offset(0);
    }];
    
    [hotBrainhole mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(hotBrainholeArea);
    }];
    
    [self.hotBrainholeTableView.tableHeaderView layoutIfNeeded];  //重点
    
    
    [super updateViewConstraints];


}
#pragma mark -- 更新子视图  --



#pragma mark -- 数据请求 --

/* 获取个人信息 */
- (void)getUserInfo {
    NSString *token = [AppCacheManager sharedSession].token;
    [RequestHandle getUserInfo:@{} authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            [self endRefreshing];
            return;
        }
        NSDictionary *dic = response[@"data"];
        NSInteger oil = [dic[@"oil"] integerValue];
        NSInteger getOil = [dic[@"getOil"] integerValue];
        [AppCacheManager sharedSession].myFuel = oil;
        [AppCacheManager sharedSession].getFuel = getOil;

    } fail:^(NSError * _Nonnull error) {
    }];
}

//下拉刷新
- (void)refresh {
    loadDataCount = 0;
    [self requestAll];
}

//上拉加载
- (void)pull {
    [self getHotBrainholeList];
}

- (void)startRefreshing {
    
}

- (void)endRefreshing {
    [self.hotBrainholeTableView.mj_header endRefreshing];
    [self.hotBrainholeTableView.mj_footer endRefreshing];
}

- (void)requestAll {
    [self getUserInfo];  //用户信息
    [self getCycleList];
    [self getStarList];
    [self getHotBrainholeList];
}

/* 获取轮播列表 */
- (void)getCycleList {
    [RequestHandle getCycleList:^(id  _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            [self endRefreshing];
            return;
        }
        if (self.cycleArray && self.cycleArray.count > 0) {
            [self.cycleArray removeAllObjects];  //清空
        }

        NSArray *cycleArray = response[@"data"];
        for (NSInteger i = 0; i < cycleArray.count; i++) {
            NSDictionary *cycleDic = cycleArray[i];
            CycleModel *model = [CycleModel mj_objectWithKeyValues:cycleDic];
            [self.cycleArray addObject:model];
        }
        [self->carouselsView setupBannerData:self.cycleArray];

        [self endRefreshing];
    } fail:^(NSError * _Nonnull error) {
        [self endRefreshing];
    }];
}

/* 获取星球列表 */
- (void)getStarList {
    WeakSelf
    [RequestHandle getStarsList:^(id  _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            [self endRefreshing];
            return;
        }
        if (self.starsArray && self.starsArray.count > 0) {
            [self.starsArray removeAllObjects];  //清空
        }
    
        NSArray *starsArray = response[@"data"][@"list"];
        for (NSInteger i = 0; i < starsArray.count; i++) {
             NSDictionary *starDic = starsArray[i];
             StarModel *model = [StarModel mj_objectWithKeyValues:starDic];
             [self.starsArray addObject:model];
        }
        
        //保存星球列表
        [GlobalSingleton sharedInstance].model.starsArray = self.starsArray;
        
        self->plantArea.starsArray = weakSelf.starsArray.mutableCopy;  //星球

        self->plantArea.frame = CGRectMake(0, 0, 100, 100);  //layout
        
        NSInteger count = weakSelf.starsArray.count;
        if (count == 0) {
            self->starListViewHeight = 0;  //不显示
        } else if (count <= 4 ) {
            self->starListViewHeight = 74; //单行
        } else {
            self->starListViewHeight = 169;  //两行
        }
        
        [self.view setNeedsUpdateConstraints];  //更新布局

        [self endRefreshing];
    } fail:^(NSError * _Nonnull error) {
      [self endRefreshing];
    }];
}

/* 获取热门脑洞 */
- (void)getHotBrainholeList {
    //考虑 返回失败不删除数据的情况
    loadDataCount++;
    if (loadDataCount == 1) {
        if (self.braninholesArray && self.braninholesArray.count > 0) {
            [self.braninholesArray removeAllObjects];  //清空
        }
    }
    NSDictionary *param = @{
                             @"pageNum":@(loadDataCount),
                             @"pageSize":@(10)
                           };
    [RequestHandle getHotBrainholeList:param success: ^(id  _Nullable response) {
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
                NSMutableArray *tagModelArray = @[].mutableCopy;
                for (NSInteger i = 0; i < tagArray.count; i++) {
                    NSDictionary *tagDic = tagArray[i];
                    TagModel *tagModel = [TagModel mj_objectWithKeyValues:tagDic];
                    [tagModelArray addObject:tagModel];
                }
                brainholeModel.tagArray = [tagModelArray copy];
                
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
             }  //autoreleasepool
        }  //所有脑洞
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark -- 轮播代理 --

-(void)carouselsView:(CarouselsView *)carousesView didSelectedItem:(NSInteger)index {
    CycleModel *cycleModel = self.cycleArray[index];
    NSInteger type = cycleModel.bannerType ;
    if (type == 0) {
       //H5
       WebViewController *webVC = [[WebViewController alloc] init];
       webVC.url = cycleModel.linkUrl;
       self.navigationController.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:webVC animated:YES];
       
    } else if (type == 1) {
       //脑洞详情
       BrainholeDetailsViewController *brainholeDetailsVC = [[BrainholeDetailsViewController alloc] init];
       brainholeDetailsVC.brainholeId = cycleModel.id;
       self.navigationController.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:brainholeDetailsVC animated:YES];
             
    } else if (type == 2) {
       //视频详情
       VideoDetailsViewController *videoDetailsVC = [[VideoDetailsViewController alloc] init];
       videoDetailsVC.brainholeVideoId = cycleModel.id;
       self.navigationController.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:videoDetailsVC animated:YES];
    } else if (type == 3) {
       //我的任务
        OilingViewController *vc = [[OilingViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (type == 4) {
       //星球
       StarDetailViewController *starDetailsVC = [[StarDetailViewController alloc] init];
       starDetailsVC.pid = [@(cycleModel.id) stringValue];
       self.navigationController.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:starDetailsVC animated:YES];
    }
}

- (UIBarButtonItem *)dayBar {
    if (!_dayBar) {
        UIButton *dayButton = [UIButton new];
        dayButton.frame = CGRectMake(0, 0, 44, 44);
        
        NSDate *date = [NSDate date];
        NSString *day = [@([date dateDay]) stringValue];
        [dayButton setTitle:day forState:UIControlStateNormal];
        dayButton.titleLabel.font = [UIFont systemFontOfSize:21];
        [dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        dayButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);  //待修改

        _dayBar = [[UIBarButtonItem alloc] initWithCustomView:dayButton];
    }
    return _dayBar;
}

- (UIBarButtonItem *)monthBar {
    if (!_monthBar) {
        UIButton *monthButton = [UIButton new];
        monthButton.frame = CGRectMake(0, 0, 44, 44);
        
        NSDate *date = [NSDate date];
        NSString *month = [self getShorthandMonth:[date dateMonth]];
        [monthButton setTitle:month forState:UIControlStateNormal];
        monthButton.titleLabel.font = [UIFont systemFontOfSize:8];
        [monthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        monthButton.contentEdgeInsets = UIEdgeInsetsMake(0, -30, -10, 0);  //待修改
        
        _monthBar = [[UIBarButtonItem alloc] initWithCustomView:monthButton];
    }
    return _monthBar;
}

- (NSString *)getShorthandMonth:(NSInteger)month{
    NSCalendar *caldendar = [NSCalendar currentCalendar];// 获取日历
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [caldendar setLocale:usLocale];
    NSArray *monthArr = [NSArray arrayWithArray:caldendar.shortMonthSymbols];  // 获取日历月数组
   return monthArr[month - 1];  // 获得数字月份下的对应英文月缩写
}

/* 设置日期富文本样式 */
- (NSMutableAttributedString *)setDateToAttributedTextStyle:(NSString *)day month:(NSString *)month {
    NSArray *dateArray = @[
                               @{ @"string": day,
                                  @"font": PingFangSC_Medium(16),
                                  @"color":UICOLOR(@"#343338")
                                },
                               @{ @"string": month,
                                  @"font": PingFangSC_Regular(16),
                                  @"color":UICOLOR(@"#343338")
                                }
                             ];
    NSMutableAttributedString *dateAttr = [@"" setMutliString:dateArray];
   
    return dateAttr;
}

- (UIBarButtonItem *)searchBar {
    if (!_searchBar) {
        _searchBar = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"search"] target:self action:@selector(goToSearch)];
    }
    return _searchBar;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"motherplanetTitle"]];
    }
    return _titleView;
}

- (void)invalid {
    
}

#pragma mark -- 搜索 --

- (void)goToSearch {
    removeObserver = YES;
    SearchViewController *searchViewController = [SearchViewController new];
    searchViewController.searchViewControllerShowMode = PYSearchResultShowModeDefault;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}


@end
