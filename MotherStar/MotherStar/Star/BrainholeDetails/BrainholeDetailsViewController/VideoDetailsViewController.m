//
//  VideoDetailsViewController.m
//  MotherStar
//  视频详情
//  Created by yanming niu on 2019/12/24.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "VideoDetailsViewController.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "GetFuelListView.h"
#import "GetFuelModel.h"
#import "CommentSectionHeaderView.h"
#import "HotBrainholeModel.h"
#import "HotBrainholeVideoModel.h"
#import "UserModel.h"
#import "TagModel.h"
#import "GetFuelUserModel.h"

#import "BrainholeFooterBar.h"
#import "BrainholeFooterBarModel.h"
#import "PostBrainholeViewController.h"
#import "PostVideoCommentViewController.h"
#import "BrainholeDetailsViewController.h"
#import "StarDetailViewController.h"
#import "GetFuelView.h"
#import "OilingViewController.h"
#import "FuellistViewController.h"
#import "ReportViewController.h"
#import "PostNewVideoCommentViewController.h"



NSInteger _pageNum = 0;

static NSString *commentCellID = @"commentCellReuseIdentifier";
static NSString *commentSectionHeaderID = @"commentSectionHeaderID";

@interface VideoDetailsViewController () <UITableViewDelegate, UITableViewDataSource, HeaderViewDelegate> {
    UITableViewHeaderFooterView *tableHeaderView;
    
    UIView *videoArea;  //视频区
    
    UIView *avatarView;  //头像视图
    
    UIView *videoPlayerView;  //视频播放器
    
    UIView *videoTitleView;  //视频标题
    CGRect videoTitleRect;
    
    UIView *videoPlayCountsView;  //播放量
    UIImageView *videoPlayCountsImageView;

    UIView *scoreView;  //评分视图
    UIView *pentagramView;  //五角星列表
    UIButton *scoreButton;  //评分

    UIView *videoSummaryView;  //视频简介
    UIView *tagView;  //标签
    UIView *sourceView;  //来源
    
    GetFuelListView *getFuelListArea;  //加油榜
    
    UITableView *commentTableView;  //评论
    BrainholeFooterBar *footerBar;
}

@property (nonatomic, strong) UIButton *playItemButtonCenter;
@property (nonatomic, strong) UIBarButtonItem *playItemButton;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *moreBar;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickname;
@property (nonatomic, strong) UILabel *date;

@property (nonatomic, strong) EdgeInsetsLabel *videoTitle;  //视频标题
@property (nonatomic, strong) UILabel *videoPlayCounts;  //视频播放量
@property (nonatomic, strong) UILabel *videoScore;  //视频评分
@property (nonatomic, strong) UILabel *videoSummary;  //视频简介
@property (nonatomic, strong) UIButton *starButton;  //星球
@property (nonatomic, strong) IXAttributeTapLabel *tagL;  //标签
@property (nonatomic, strong) UILabel *source;  //作品来源

@property (nonatomic, assign) BOOL isHiddenStatusBar;
@property (nonatomic, strong) NSMutableArray *commentsArray;

@property (nonatomic, strong) NSMutableArray *fuelArray;  //test
@property (nonatomic, strong) NSMutableArray *scoreArray;  //视频评分值
@property (nonatomic, strong) HotBrainholeModel *hotBrainholeModel;
@property (nonatomic, strong) HotBrainholeVideoModel *hotBrainholeVideoModel;

@property (nonatomic, strong) SJPlayModel *playModel;
@property (nonatomic, strong) SJVideoPlayer *player;


@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, strong) NSConditionLock *lock;

@property (nonatomic, strong) GetFuelView *getFuelView;

@property (nonatomic, strong) NSMutableArray *videoIdArray;



@end

@implementation VideoDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [_player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_player vc_viewDidDisappear];
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
    [self requestAll];

    [self initVideoDetailsView];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 20;


    self.gk_navTitleView = self.playItemButtonCenter;
    self.gk_navLeftBarButtonItems = @[self.backButton, space, self.playItemButton, space, self.playItemButton];
    self.gk_navRightBarButtonItems = @[self.moreBar, space, self.playItemButton, space,self.playItemButton];
//    self.gk_navRightBarButtonItem = self.moreBar;
 
    
  
    
//    //脑洞评论按时间排序观察者
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soryBrainholeCommentByTime) name:@"BrainholeCommentSortByTimeNotification" object:nil];
//
//    //脑洞评论观察者
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(brainholeCommentLike:) name:@"BrainholeCommentLikeNotification" object:nil];

    //注册FooterBar观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFooterActionNotification:) name:@"BrainholeDetailFooterNotification" object:nil];
    
    //注册加油观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAddFuelActionNotification:) name:@"addFuelActionNotification" object:nil];
    
    //注册进入加油站通知
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterAddFuelView:) name:@"enterAddFuelViewNotification" object:nil];
}

- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BrainholeVideoCommentNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BrainholeDetailFooterNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addFuelActionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"enterAddFuelViewNotification" object:nil];
}

#pragma mark  -- 算法 --

- (void)initPlayerItem:(NSArray *)itemArray didSelected:(NSInteger)index {
    for (NSInteger i = 0; i < itemArray.count; i++) {
        UIBarButtonItem *playItemButton = self.playItemButton;
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = 20;
        
        if (i == 0) {
            UIBarButtonItem *playButtonLeft_first = self.playItemButton;
            playItemButton.tag = 10;
            self.gk_navLeftBarButtonItems = @[self.backButton, space, playButtonLeft_first];
        } else if (i == 1) {
            UIBarButtonItem *playButtonLeft_first = self.playItemButton;
                       playItemButton.tag = 10;
            UIBarButtonItem *playButtonLeft_second = self.playItemButton;
                                  playItemButton.tag = 20;
            self.gk_navLeftBarButtonItems = @[self.backButton, space, playButtonLeft_first, space, playButtonLeft_second];
        } else if (i == 2) {
            self.gk_navTitleView = self.playItemButtonCenter;
        } else if (i == 3) {
            UIBarButtonItem *playButtonRight_first = self.playItemButton;
            playButtonRight_first.tag = 40;
            self.gk_navRightBarButtonItems = @[self.moreBar, space, playButtonRight_first];
        } else if (i == 4) {
            UIBarButtonItem *playButtonRight_first = self.playItemButton;
            playItemButton.tag = 40;
            UIBarButtonItem *playButtonRight_second = self.playItemButton;
            playItemButton.tag = 50;
            self.gk_navRightBarButtonItems = @[self.moreBar, space, playButtonRight_first, space,playButtonRight_second];
        }
        [self updatePlayItem:index];
    }
}

#pragma mark  -- 点击事件 --

- (UIBarButtonItem *)backButton {
    if (!_backButton) {
        _backButton = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"back_black"] target:self action:@selector(backAction)];
    }
    return _backButton;
}

- (UIBarButtonItem *)moreBar {
    if (!_moreBar) {
        _moreBar = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"navgationBar_more"] target:self action:@selector(showMoreView)];
    }
    return _moreBar;
}

/* 导航栏中间播放按钮 */
- (UIButton *)playItemButtonCenter {
    if (!_playItemButtonCenter) {
        _playItemButtonCenter = [UIButton buttonWithType:UIButtonTypeCustom];
        _playItemButtonCenter.tag = 30;
        _playItemButtonCenter.frame = CGRectMake(0, 0, 30, 30);
        [_playItemButtonCenter setImage:[UIImage imageNamed:@"icon_player_invalid"] forState:UIControlStateNormal];
        [_playItemButtonCenter addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playItemButtonCenter;
}

- (void)updatePlayItem:(NSInteger)index {
    if (index < 2) {
        UIBarButtonItem *playItem = self.gk_navLeftBarButtonItems[index];
        [playItem setImage:[UIImage imageNamed:@"icon_player_valid"]];
        //replace
    } else if (index == 2){
         [self.playItemButtonCenter setImage:[UIImage imageNamed:@"icon_player_valid"] forState:UIControlStateNormal];
    } else {
        UIBarButtonItem *playItem = self.gk_navRightBarButtonItems[index];
        [playItem setImage:[UIImage imageNamed:@"icon_player_valid"]];
        //replace
    }
}

//- (UIBarButtonItem *)setPlayButton:(BOOL)selected {
//    UIButton *playButton = [UIButton new];
//    playButton.frame = CGRectMake(0, 0, 30, 30);
//    NSString *selectedItem = @"icon_player_valid";
//    NSString *unSelectedItem = @"icon_player_invalid";
//
//    if (selected) {
//        [playButton setImage:[UIImage imageNamed:selectedItem] forState:UIControlStateNormal];
//    } else {
//        [playButton setImage:[UIImage imageNamed:unSelectedItem] forState:UIControlStateNormal];
//    }
//    UIBarButtonItem *playItem = [[UIBarButtonItem alloc] initWithCustomView:playButton];
//    return playItem;
//}

/* 点击播放按钮 */
- (void)didSelectedPlayItem:(UIButton *)sender {
    
}

/* 导航栏其他播放按钮 */
- (UIBarButtonItem *)playItemButton {
    UIButton *playButton = [UIButton new];
    playButton.frame = CGRectMake(0, 0, 30, 30);
    [playButton setImage:[UIImage imageNamed:@"icon_player_invalid"] forState:UIControlStateNormal];
    SEL selectItemSEL = @selector(didSelectedPlayItem:);
    [playButton addTarget:self action:selectItemSEL forControlEvents:UIControlEventTouchUpInside];
    _playItemButton = [[UIBarButtonItem alloc] initWithCustomView:playButton];
    
    return _playItemButton;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

/* 播放 */
- (void)playAction:(id)sender {
    
}


/* 更多 - 微信好友 举报 ...  */
- (void)showMoreView {
    [self showShareView];
}

#pragma mark  -- 通知 --

/* 进入加油站 */
- (void)enterAddFuelView:(NSNotification *)notification {
    [self.getFuelView closeAction];
    OilingViewController *vc = [[OilingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/* 加油 - 脑洞 */
- (void)receiveAddFuelActionNotification:(NSNotification *)notification {
    NSInteger fuel = [notification.object integerValue];
    if (fuel < 5) {
        [SVProgressHUD showErrorWithStatus:@"燃料不足"];
        [SVProgressHUD dismissWithDelay:2.0];
        return;
    }
    
    NSDictionary *param = @{
                              @"oil":@(fuel),
                              @"postId":@(self.brainholeVideoId),
                              @"sourceType":@(1),
                            };
    NSString *token = [AppCacheManager sharedSession].token;
    [RequestHandle addFuel:param authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        [SVProgressHUD showSuccessWithStatus:@"加油成功"];
        [SVProgressHUD dismissWithDelay:2 completion:^{
            [self requestAll];  //更新数据
            [self.getFuelView closeAction];
        }];
    } fail:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加油失败"];
        [SVProgressHUD dismissWithDelay:2 completion:^{
            [self.getFuelView closeAction];
        }];
    }];
}

- (void)receiveFooterActionNotification:(NSNotification *)notification {
    if (![GlobalHandle isLoginUser]) {
        PwdLoginViewController * loginVC = [[PwdLoginViewController alloc]init];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    NSNumber *tagNumber = notification.object;
    NSInteger tag = [tagNumber integerValue];
    
//    [_videoController closeVideoPlayer];  //关闭视频播放器


    if (tag == 11) {
        //上传视频
//        [_videoController closeVideoPlayer];  //关闭视频播放器
          PostBrainholeViewController *postVC = [[PostBrainholeViewController alloc] init];
          postVC.isUploadVideo = YES;
          postVC.isPush = YES;
          postVC.brainholeId = self.brainholeVideoId;
          postVC.hidesBottomBarWhenPushed = YES;
          [self.navigationController pushViewController:postVC animated:NO];
        
     } else if (tag == 12) {
         //发布评论
//         PostVideoCommentViewController *postVideoCommentVC = [[PostVideoCommentViewController alloc] init];
//         postVideoCommentVC.brainholeVideoId = self.brainholeVideoId;
         
        PostNewVideoCommentViewController *postVideoCommentVC = [[PostNewVideoCommentViewController alloc] init];
        postVideoCommentVC.brainholeVideoId = self.brainholeVideoId;
        [self.navigationController pushViewController:postVideoCommentVC animated:YES];
         
     } else if(tag == 13) {
        //点赞
        NSString *token = [AppCacheManager sharedSession].token;
        [RequestHandle likeForBrainhole:@{ @"postid":@(self.brainholeVideoId) } authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        } success:^(id  _Nullable response) {
            
        } fail:^(NSError * _Nonnull error) {
        }];
          
      } else if(tag == 14) {
          //分享
          [self showShareView];
      } else {
          //加油
          self.getFuelView = [[GetFuelView alloc] initWithFrame:CGRectZero];
          self.getFuelView.myFuel = [AppCacheManager sharedSession].myFuel;
          [self.getFuelView showAction];
      }
}

- (void)showShareView {
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
         UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
               
               NSString *title = self.hotBrainholeModel.title;
               
               NSArray *textArray = [GlobalHandle filterTextFromHTML:self.hotBrainholeModel.content];
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
//               if (self.videoIdArray && self.videoIdArray.count > 0) {
//                   for (NSInteger i = 0; i < self.videoIdArray.count; i++) {
//                       NSString *videoIdStr = self.videoIdArray[i];
//                       videoIdStr = [videoIdStr stringByAppendingString:@","];
//                       ids = [ids stringByAppendingString:videoIdStr];
//                   }
//               }
               ids = [NSString stringWithFormat:@"%li",self.brainholeVideoId];
               
               NSString *baseUrl = BaseUrl;
               baseUrl = [baseUrl stringByReplacingOccurrencesOfString:@"api"withString:@""];
        NSString *webpageUrl = [NSString stringWithFormat:@"%@video.html?token=%@&id=%li&ids=%@",baseUrl, token, (long)self.brainholeVideoId, ids];
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
                    [self requestAll];
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
                             @"id":@(self.brainholeVideoId),
                             @"aType":@(1),
                           };
    NSString *token = [AppCacheManager sharedSession].token;
    [RequestHandle shareBrainhole:param authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        
    } fail:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark  -- 播放器 --

/* 初始化播放器 */
- (void)initPlayer:(NSString *)url {
    _playModel = [SJPlayModel UITableViewHeaderViewPlayModelWithPlayerSuperview:videoPlayerView tableView:commentTableView];
    _player = [SJVideoPlayer player];
    _player.autoplayWhenSetNewAsset = NO;
    _player.rotationManager.disabledAutorotation = YES;  //禁止自动旋转

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


    NSURL *videoUrl = [NSURL URLWithString:url];
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:videoUrl playModel:_playModel];
    [_player rotate:SJOrientation_LandscapeLeft animated:YES];
    
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark  -- 视图初始化 --

- (void)initVideoDetailsView {
    self.automaticallyAdjustsScrollViewInsets = NO;

    //头视图
    tableHeaderView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectZero];
  
    //视频区
    videoArea = [[UIView alloc] initWithFrame:CGRectZero];
    [tableHeaderView addSubview:videoArea];

    //头像
    avatarView = [[UIView alloc] initWithFrame:CGRectZero];
    [videoArea addSubview:avatarView];

    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    self.avatarImageView.image = [UIImage imageNamed:@"default_avatar"];  //test
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width /2;  //圆形
    self.avatarImageView.clipsToBounds = YES;
    [avatarView addSubview:self.avatarImageView];

    self.nickname = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nickname.font = PingFangSC_Regular(14);
    self.nickname.textColor = UICOLOR(@"#343338");
    [avatarView addSubview:self.nickname];

    self.date = [[UILabel alloc] initWithFrame:CGRectZero];
    self.date.font = PingFangSC_Regular(10);  //字体待修改
    self.date.textColor = UICOLOR(@"#343338");
    [avatarView addSubview:self.date];

    
    //播放器
    videoPlayerView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, SCREENWIDTH - 32, 193)];
    [videoArea addSubview:videoPlayerView];

    videoPlayerView.layer.cornerRadius = 8;
    videoPlayerView.layer.masksToBounds = YES;

    //视频标题 - 富文本
    videoTitleView = [[UIView alloc] initWithFrame:CGRectZero];
    [videoArea addSubview:videoTitleView];

    self.videoTitle = [[EdgeInsetsLabel alloc] initWithFrame:CGRectZero];
    self.videoTitle.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);  //top,left,bottom,right 设置左内边距

    self.videoTitle.font = PingFangSC_Medium(18);
    self.videoTitle.textColor = UICOLOR(@"#343338");
    self.videoTitle.preferredMaxLayoutWidth = SCREENWIDTH - 32;
    self.videoTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.videoTitle.numberOfLines = 0;
    [self.videoTitle sizeToFit];
    [videoTitleView addSubview:self.videoTitle];

    //播放量
    videoPlayCountsView = [[UIView alloc] initWithFrame:CGRectZero];
    [videoArea addSubview: videoPlayCountsView];
    
    videoPlayCountsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    videoPlayCountsImageView.image = [UIImage imageNamed:@"image_videoPlayCounts_black"];
    [videoPlayCountsView addSubview: videoPlayCountsImageView];

    
    self.videoPlayCounts = [[UILabel alloc] initWithFrame:CGRectZero];
    self.videoPlayCounts.font = PingFangSC_Medium(14);
    self.videoPlayCounts.textColor = UICOLOR(@"#343338");
    [videoPlayCountsView addSubview: self.videoPlayCounts];

    //评分
    scoreView = [[UIView alloc] initWithFrame:CGRectZero];
    [videoArea addSubview: scoreView];
    
    pentagramView = [[UIView alloc] initWithFrame:CGRectZero];
    [self test_masonry_horizontal_fixSpace];
    [scoreView addSubview:pentagramView];

    self.videoScore = [[UILabel alloc] initWithFrame:CGRectZero];
    self.videoScore.font = PingFangSC_Medium(20);
    self.videoScore.textColor = UICOLOR(@"#343338");
    [scoreView addSubview:self.videoScore];

    scoreButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [scoreButton setTitle:@"评分" forState:UIControlStateNormal];
    scoreButton.titleLabel.font = PingFangSC_Regular(14);
    [scoreButton setTitleColor:UICOLOR(@"#F2B300") forState:UIControlStateNormal];

    scoreButton.layer.borderWidth = 1;
    scoreButton.layer.borderColor = UICOLOR(@"#F2B300").CGColor;
    scoreButton.layer.cornerRadius = 3.5;

    [scoreButton addTarget:self action:@selector(scoreAction) forControlEvents:UIControlEventTouchUpInside];
    [scoreView addSubview:scoreButton];

    //视频描述
    videoSummaryView = [[UIView alloc] initWithFrame:CGRectZero];
    [videoArea addSubview:videoSummaryView];

    self.videoSummary = [[UILabel alloc] initWithFrame:CGRectZero];
    self.videoSummary.font = PingFangSC_Regular(12);
    self.videoSummary.textColor = UICOLOR(@"#868686");
    self.videoSummary.preferredMaxLayoutWidth = SCREENWIDTH - 32;
    self.videoSummary.lineBreakMode = NSLineBreakByWordWrapping;
    self.videoSummary.numberOfLines = 0;
    [self.videoSummary sizeToFit];
    [videoSummaryView addSubview:self.videoSummary];

    //星球
    self.starButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [videoArea addSubview:self.starButton];

    self.starButton.titleLabel.font = PingFangSC_Regular(14);
    [self.starButton setTitleColor:UICOLOR(@"#6692EE") forState:UIControlStateNormal];
    [self.starButton setImage:[UIImage imageNamed:@"footer_star_blue"] forState:UIControlStateNormal];
    [self.starButton SG_imagePositionStyle:SGImagePositionStyleLeft spacing:4.0];
    [self.starButton addTarget:self action:@selector(enterStarDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //标签
    tagView = [[UIView alloc] initWithFrame:CGRectZero];
    [videoArea addSubview:tagView];

    self.tagL = [[IXAttributeTapLabel alloc] initWithFrame:CGRectZero];
    self.tagL.textAlignment = NSTextAlignmentLeft;
    self.tagL.font = PingFangSC_Regular(14);
    self.tagL.textColor = UICOLOR(@"#6692EE");
    self.tagL.preferredMaxLayoutWidth = SCREENWIDTH - 32;
    self.tagL.lineBreakMode = NSLineBreakByWordWrapping;
    self.tagL.numberOfLines = 0;
    [self.tagL sizeToFit];
    [tagView addSubview:self.tagL];

    //来源
    sourceView = [[UIView alloc] initWithFrame:CGRectZero];
    [videoArea addSubview:sourceView];

    self.source = [[UILabel alloc] initWithFrame:CGRectZero];
    self.source.textAlignment = NSTextAlignmentLeft;
    self.source.font = PingFangSC_Regular(12);
    self.source.textColor = UICOLOR(@"#343338");
    self.source.numberOfLines = 1;
    [sourceView addSubview:self.source];

   
     //加油榜
    getFuelListArea = [[GetFuelListView alloc] initWithFrame:CGRectZero];
    [tableHeaderView addSubview:getFuelListArea];
    getFuelListArea.frame = CGRectMake(0, 0, SCREENWIDTH - 32, 145);
    UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterFuelListView)];
    [getFuelListArea addGestureRecognizer:tapGesture];

    //评论
    commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    commentTableView.estimatedRowHeight = 200;
    commentTableView.rowHeight = UITableViewAutomaticDimension;
    commentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;  //分割线
    commentTableView.separatorColor = UICOLOR(@"#F6F6F6");
    commentTableView.separatorInset = UIEdgeInsetsMake(0, 36, 0, 0); //top left bottom right

    commentTableView.tableHeaderView = tableHeaderView;
    [self.view addSubview:commentTableView];
    
    footerBar = [[BrainholeFooterBar alloc] initWithFrame:CGRectZero];
    
//    [footerBar.itemArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:36.5 tailSpacing:27];
//
//      // 设置array的垂直方向的约束
//      [footerBar.itemArray mas_makeConstraints:^(MASConstraintMaker *make) {
//          make.bottom.equalTo(footerBar).offset(0);
//          make.height.mas_equalTo(40);
//      }];
    
    [self.view addSubview:footerBar];
    
    [self.view setNeedsUpdateConstraints];
   
}

//- (void)test_masonry_horizontal_fixSpace {
//    // 实现masonry水平固定间隔方法
//    [self.itemArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:2 leadSpacing:36.5 tailSpacing:27];
//
//    // 设置array的垂直方向的约束
//    [self.itemArray mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(backgroundView).offset(0);
//        make.height.mas_equalTo(40);
//    }];
//}

- (NSMutableArray *)commentsArray {
    if (_commentsArray == nil) {
        _commentsArray = [NSMutableArray array];
    }
    return _commentsArray;
}

/* 更改评分 */
- (void)changeScore:(NSInteger)score {
    for (int i = 0; i < self.scoreArray.count; i ++) {
        UIImageView *pentagramImage = self.scoreArray[i];
        if (i < score) {
            pentagramImage.image = [UIImage imageNamed:@"pentagram"];  //变色   待修改  根据类型显示
            [_scoreArray replaceObjectAtIndex:i withObject:pentagramImage];
        }
    }
}

- (NSMutableArray *)scoreArray {
    if (!_scoreArray) {
        _scoreArray = [NSMutableArray array];
        for (int i = 0; i < 5; i ++) {
            UIImageView *pentagramImage = [[UIImageView alloc] initWithFrame:CGRectZero];
            pentagramImage.image = [UIImage imageNamed:@"pentagram_default"];  //默认
            [pentagramView addSubview:pentagramImage];  //放入五角星
            [_scoreArray addObject:pentagramImage];
        }
    }
    return _scoreArray;
}

/* 评分五角星 */
- (void)test_masonry_horizontal_fixSpace {
    // 实现masonry水平固定间隔方法
    [self.scoreArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:6.5 leadSpacing:0 tailSpacing:0];

    // 设置array的垂直方向的约束
    [self.scoreArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pentagramView).offset(0);
        make.height.mas_equalTo(14);
    }];
}

#pragma mark -- Target-Action --

#pragma mark -- 点击事件 --

/* 加油列表 */
- (void)enterFuelListView {
    FuellistViewController *vc = [FuellistViewController new];
    vc.isVideo = YES;
    vc.pid = [NSString stringWithFormat:@"%ld", self.brainholeVideoId];
    [self.navigationController pushViewController:vc animated:YES];
}

/* 星球详情 */
- (void)enterStarDetailsAction:(UIButton *)sender {
    StarDetailViewController *starVC = [[StarDetailViewController alloc] init];
    starVC.pid = self.hotBrainholeModel.starTagId ;
    starVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:starVC animated:YES];
}

/* 进入评分界面 */
- (void)scoreAction {
    //评分
    NSString *token = [AppCacheManager sharedSession].token;
    if (!token) {
        [SVProgressHUD showInfoWithStatus:@"非注册用户无法评论"];
        [SVProgressHUD dismissWithDelay:1.0];
        return;
    }
   
    PostVideoCommentViewController *postVideoCommentVC = [[PostVideoCommentViewController alloc] init];
    postVideoCommentVC.brainholeVideoId = self.brainholeVideoId;
    [self.navigationController pushViewController:postVideoCommentVC animated:YES];
}

#pragma mark -- 数据处理 --
- (NSAttributedString *)setAttactToAttributeSting:(UIImage *)image {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, -2, 28, 16);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    return attachmentString;
}

#pragma mark -- 更新视图 --

- (void)updateModel:(HotBrainholeModel *)brainholeModel videoModel:(HotBrainholeVideoModel *)videoModel {
    if (!brainholeModel) {
        return;
    }
    
    if (!videoModel) {
        return;
    }
    
    //头像
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.urlName] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
     self.nickname.text = videoModel.name;
     self.date.text = [videoModel.createTime substringToIndex:10];
     
    //视频标题
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:videoModel.videoTitle];
    NSMutableAttributedString *originalMutableAttr = nil;
    NSAttributedString *spaceAttr = [[NSAttributedString alloc] initWithString:@" "];

    if (videoModel.original == 0) {
        NSAttributedString *originalAttr = [self setAttactToAttributeSting:[UIImage imageNamed:@"original"]];
        originalMutableAttr = [[NSMutableAttributedString alloc] initWithAttributedString:originalAttr];
        [originalMutableAttr appendAttributedString:spaceAttr];
        [originalMutableAttr appendAttributedString:titleAttr];
        self.videoTitle.attributedText = originalMutableAttr;
    } else {
        self.videoTitle.text = videoModel.videoTitle;
    }
    
    //播放量
    self.videoPlayCounts.text = [@(videoModel.playNum) stringValue];
 
    //视频评分
    NSInteger score = videoModel.score;
    self.videoScore.text = [NSString stringWithFormat:@"%li.0", (long)score];
    [self changeScore:self.hotBrainholeVideoModel.score];  //更改评分

    self.videoSummary.text = videoModel.videoDescribe;
    
    //星球
    [self.starButton setTitle:brainholeModel.starTag forState:UIControlStateNormal];

    //标签
    [self setTagStringAndClickAction:brainholeModel.tagArray];
    
    //来源
    self.source.text = brainholeModel.source;

    //加油榜
    getFuelListArea.fuelUserArray = brainholeModel.getFuelUserArray;
    getFuelListArea.getFuelModel =  brainholeModel.getFuelModel;

    //评论
    self.commentsArray = brainholeModel.commentArray;
    [commentTableView reloadData];
    [commentTableView.tableHeaderView layoutIfNeeded];

    //底栏
    BrainholeFooterBarModel *footerBarModel = [[BrainholeFooterBarModel alloc] init];
    footerBarModel.comments = brainholeModel.commentArray.count;
    footerBarModel.likes = brainholeModel.likeNum;
    footerBarModel.shares = videoModel.share;
    footerBarModel.fuels = brainholeModel.getFuelModel.getOilNum;
    footerBar.footerModel = footerBarModel;
    
    [self initPlayer:videoModel.urlPainting];  //初始化播放器
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view setNeedsUpdateConstraints];  //更新布局
    });
    
}

#pragma mark -- 数据处理 --

/* 组装标签并实现点击选中标签事件 */
- (void)setTagStringAndClickAction:(NSArray *)tagModelArray {
    if (!tagModelArray) {
        return;
    }

    NSString *tagAllString = @"";  //标签普通字符串
    NSString *spaceString = @" ";
    NSMutableArray *modelArray = @[].mutableCopy;
    for (NSInteger i = 0; i < tagModelArray.count; i++) {
        TagModel *tagModel = tagModelArray[i];
        tagAllString = [tagAllString stringByAppendingString:tagModel.tagTitle];

        //TagModel转IXAttributeModel 实现点击选中字符串事件
        IXAttributeModel *IXModel = [[IXAttributeModel alloc] init];
        IXModel.id = tagModel.id;
        IXModel.range = [tagAllString rangeOfString:tagModel.tagTitle];
        IXModel.string = tagModel.tagTitle;
        IXModel.attributeDic = @{ NSForegroundColorAttributeName : UICOLOR(@"#6692EE") };

        [modelArray addObject:IXModel];
        tagAllString = [tagAllString stringByAppendingString:spaceString];
    }
       
    //标签内容-富文本
    [self.tagL setText:tagAllString attributes:@{NSForegroundColorAttributeName:UICOLOR(@"#6692EE"), NSFontAttributeName:PingFangSC_Regular(14)} tapStringArray:modelArray];
    
    self.tagL.tapBlock = ^(NSString *string) {
         for (NSInteger i = 0; i < modelArray.count; i++) {
             IXAttributeModel *IXModel = modelArray[i];
             if ([string isEqualToString:IXModel.string]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"TagDetailsNotification" object:IXModel];
                 return;
             }
         }
    };
}


#pragma mark -- 数据请求 --

- (void)requestAll {
    //创建队列组
    _group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.lock = [[NSConditionLock alloc] initWithCondition:0];
    
    [SVProgressHUD show];
    dispatch_group_async(_group, queue, ^{
        [self.lock lock];
        [self getBrainholeVideoDetails];
    });
    
    dispatch_group_async(_group, queue, ^{
        [self.lock lock];
        [self getFuelUserList];
    });
    
    dispatch_group_async(_group, queue, ^{
        [self.lock lock];
        [self getFuelNumber];
    });
    
    dispatch_group_async(_group, queue, ^{
        [self.lock lock];
        [self getCommentList];
    });
 
//    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
//        [SVProgressHUD dismiss];
//        [self updateModel:self.hotBrainholeModel videoModel:self.hotBrainholeVideoModel];
//    });
}

/* 请求脑洞视频详情 */
- (void)getBrainholeVideoDetails {
    [RequestHandle getVideoDetails:@{ @"id": @(self.brainholeVideoId) } authorization:@"" success:^(id  _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            [SVProgressHUD dismiss];
            [self.lock unlock];
            return;
        }
        NSArray *array = response[@"data"];
        NSDictionary *brainholeDic = array[0][@"hotPost"];  //脑洞 - 详情
        NSDictionary *brainholeTextDic =  brainholeDic[@"post"];  //脑洞 - 帖子
        NSDictionary *brainholeVideoDic =  brainholeDic[@"video"];  //脑洞 - 视频
        
        HotBrainholeModel *hotBrainholeModel = [HotBrainholeModel mj_objectWithKeyValues:brainholeTextDic];
        
        HotBrainholeVideoModel *hotBrainholeVideoModel = [HotBrainholeVideoModel mj_objectWithKeyValues:brainholeVideoDic];
        
        self.hotBrainholeVideoModel = hotBrainholeVideoModel;
        
        NSMutableArray *tempArray = @[].mutableCopy;
        NSArray *tagArray = array[0][@"tagDto"][@"tags"];  //标签
        for (NSInteger i = 0; i < tagArray.count; i++) {
            NSDictionary *tagDic = tagArray[i];
            TagModel *model = [TagModel mj_objectWithKeyValues:tagDic];
            [tempArray addObject:model];
            hotBrainholeModel.tagArray = tempArray;
        }
        NSDictionary *userDic = brainholeDic[@"user"];  //发布脑洞的用户
        UserModel *userModel = [UserModel mj_objectWithKeyValues:userDic];
        if (!userModel) {
            userModel = [[UserModel alloc] init];
        }
        hotBrainholeModel.userModel = userModel;
        self.hotBrainholeModel = hotBrainholeModel;  //数据汇总完成
        [self->videoArea setNeedsLayout];

        [self.lock unlock];
    } fail:^(NSError * _Nonnull error) {
        [self.lock unlock];
    }];
}

/* 请求加油榜 */
- (void)getFuelUserList {
    NSDictionary *param = @{
                             @"videoId": @(self.brainholeVideoId),
                             @"pageNum": @(1),
                             @"pageSize":@(10)
                           };
  [RequestHandle getVideoFuelUserlist:param authorization:@"" success:^(id  _Nullable response) {
      if ([response[@"code"] integerValue] != 0) {
          [SVProgressHUD dismiss];
          [self.lock unlock];
          return;
      }
      
      NSArray *getFuelArray = response[@"data"][@"list"];
      NSMutableArray *fuelArray = @[].mutableCopy;
      for (NSInteger i = 0; i < getFuelArray.count; i++) {
          NSDictionary *fulDic = getFuelArray[i];
          
          NSNumber *integralNumber = fulDic[@"integral"][@"integral"];
          NSInteger integral = [integralNumber integerValue];
          NSString *picUrl = fulDic[@"user"][@"picUrl"];

          GetFuelUserModel *userModel = [[GetFuelUserModel alloc] init];
          userModel.integral = integral;
          userModel.picUrl = picUrl;
          
          [fuelArray addObject:userModel];
      }
      self.hotBrainholeModel.getFuelUserArray = [fuelArray mutableCopy];  //加油榜
      [self.lock unlock];
    } fail:^(NSError * _Nonnull error) {
        [self.lock unlock];
    }];
}

/* 请求加油人数与收到燃料数 */
- (void)getFuelNumber {
    NSDictionary *param = @{
                             @"id": @(self.brainholeVideoId),
                             @"type": @(1)
                           };
    [RequestHandle getGetFuellistNum:param authorization:@"" success:^(id  _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            [SVProgressHUD dismiss];
            [self.lock unlock];
            return;
        }
        
        NSDictionary *getFuelNumDic = response[@"data"];
        GetFuelModel *model = [GetFuelModel mj_objectWithKeyValues:getFuelNumDic];
        model.isVideo = YES;
        self.hotBrainholeModel.getFuelModel = model;
        
        [self.lock unlock];
    } fail:^(NSError * _Nonnull error) {
        [self.lock unlock];
    }];
}

/* 请求评论列表 */
- (void)getCommentList {
    _pageNum++;
    NSDictionary *param = @{
                             @"videoId":@(self.brainholeVideoId),
                             @"pageNum":@(_pageNum),
                             @"pageSize":@(10)
                           };
    NSString *token = [AppCacheManager sharedSession].token;
    [RequestHandle requestBrainholeVideoComment:param authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            [SVProgressHUD dismiss];
            [self.lock unlock];
            return;
        }
               
        NSArray *commentArray = response[@"data"][@"list"];
        if ([commentArray isKindOfClass:[NSNull class]]) {
           commentArray = @[];  //后台为空是传null 过滤null
        }
        if (commentArray.count == 0) {
           _pageNum--;
        }

        NSMutableArray *tempArray = @[].mutableCopy;
        for (NSInteger i = 0; i < commentArray.count; i++) {
            NSDictionary *commentDic =  commentArray[i];
            CommentModel *commentModel = [CommentModel mj_objectWithKeyValues:commentDic];
            NSArray *textArray = [GlobalHandle filterTextFromHTML:commentModel.title];
            NSString *text = @"";
            if (textArray && textArray.count > 0) {
              text = textArray[0];
            }
            commentModel.title = text;
            commentModel.isVideoType = YES;
            [tempArray addObject:commentModel];
        }
        self.hotBrainholeModel.commentArray = tempArray;

        [self.lock unlock];
        // -  -  - -  -  - -  -  - -  -  - -  -  - -  -  -
        [SVProgressHUD dismiss];
        [self updateModel:self.hotBrainholeModel videoModel:self.hotBrainholeVideoModel];
        // -  -  - -  -  - -  -  - -  -  - -  -  - -  -  -
    } fail:^(NSError * _Nonnull error) {
        [self.lock unlock];
    }];
}


#pragma mark -- 布局 --

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    commentTableView.tableHeaderView = tableHeaderView;
    [commentTableView.tableHeaderView layoutIfNeeded];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(StatusAndNaviHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);  //footerBar
    }];

    [tableHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.equalTo(getFuelListArea.mas_bottom).mas_offset(80);
    }];
    
    [videoArea mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableHeaderView).offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(sourceView.mas_bottom).offset(20);
    }];

    [avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(28);
    }];

    [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.height.mas_equalTo(28);
    }];

    [self.nickname mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);  //设计图距顶部2
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(8);
        make.height.mas_equalTo(14);
    }];

    [self.date mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickname.mas_bottom).mas_offset(4);
        make.left.leading.equalTo(self.nickname);
        make.height.mas_equalTo(10);
    }];
    
    //视频
    [videoPlayerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(avatarView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 32);
        make.height.mas_equalTo(193);
    }];
    
    [videoTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(videoPlayerView.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 32);
    }];

    [self.videoTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(videoTitleView);
    }];
    
    [videoPlayCountsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(videoTitleView.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(SCREENWIDTH - 32);
        make.height.mas_equalTo(14);
    }];
    
    [videoPlayCountsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(videoPlayCountsView);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(10);
    }];
    
    [self.videoPlayCounts mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(videoPlayCountsImageView);
        make.left.equalTo(videoPlayCountsImageView.mas_right).offset(8);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(14);
    }];
    
    [scoreView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(videoPlayCountsView.mas_bottom).offset(10);
        make.left.mas_offset(0);
        make.width.mas_equalTo(SCREENWIDTH - 32);
        make.height.mas_equalTo(20);
    }];
    
    [pentagramView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(3);
        make.left.offset(0);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(14);
    }];
    
    [self.videoScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(pentagramView.mas_right).offset(8);
        make.width.mas_equalTo(34.5);
        make.height.mas_equalTo(20);
    }];
    
    [scoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.mas_offset(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [videoSummaryView  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scoreView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 32);
    }];

    [self.videoSummary mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(videoSummaryView);
    }];
    
    [self.starButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoSummary.mas_bottom).mas_offset(10);
        make.left.mas_offset(0);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(20);
    }];

    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoSummary.mas_bottom).mas_offset(10);
        make.left.equalTo(self.starButton.mas_right).mas_offset(4);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(SCREENWIDTH - 32);
    }];
       
    [self.tagL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(tagView);
    }];
    
    [sourceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagView.mas_bottom).mas_offset(12);
        make.left.right.offset(0);
        make.height.mas_equalTo(12);
    }];
            
    [self.source mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sourceView);
    }];

    [getFuelListArea mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(videoArea.mas_bottom).offset(2);
        make.left.right.offset(0);
        make.height.equalTo(@145);
    }];
    
    [footerBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(58);
        make.bottom.equalTo(self.view);
    }];
    
    [footerBar mas_updateConstraints:^(MASConstraintMaker *make) {
          make.left.right.equalTo(self.view);
          make.width.mas_equalTo(SCREENWIDTH);
          make.height.mas_equalTo(58);
          make.bottom.equalTo(self.view);
      }];
    
    [commentTableView.tableHeaderView layoutIfNeeded];  //重点
}

#pragma mark  -- 约束 --


#pragma mark -- 评论列表 - delegate dataSource --

//评论查询 - 时间
- (void)sortByTime:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString *sort = @"0";
    if (sender.selected) {
        sort = @"1";
    }
    //请求方法
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentsArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellID];
    }
 
    CommentModel *model = self.commentsArray[indexPath.row];
    cell.commentModel = model;
    [cell layoutIfNeeded];  //重要
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}


@end
