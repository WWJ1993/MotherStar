//
//  BrainholeDetailsViewController.m
//  MotherStar
//  脑洞详情
//  Created by yanming niu on 2019/12/24.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "BrainholeDetailsViewController.h"
#import "GetFuelListView.h"
#import "CommentTableViewCell.h"
#import "CommentSectionHeaderView.h"
#import "CommentModel.h"
#import "HotBrainholeModel.h"
#import "TagModel.h"
#import "UserModel.h"
#import "GetFuelModel.h"
#import "GetFuelUserModel.h"
#import "BrainholeFooterBar.h"
#import "BrainholeFooterBarModel.h"
#import "PostBrainholeViewController.h"
#import "PostCommentViewController.h"

#import "PostNewCommentViewController.h"

#import "GetFuelView.h"
#import "LWActiveIncator.h"
#import "StarDetailViewController.h"
#import "OilingViewController.h"
#import "ReportViewController.h"
#import "FuellistViewController.h"

static NSString *commentCellID = @"BrainholeCommentCellReuseIdentifier";
static NSString *commentSectionHeaderID = @"BrainholeCommentSectionHeaderID";

NSInteger pageNum = 0;

@interface BrainholeDetailsViewController () <UITableViewDelegate, UITableViewDataSource,HeaderViewDelegate, UIGestureRecognizerDelegate>{
    UIView *tableHeaderView;
    UIView *brainholeTextArea;  //脑洞文本区
    UIView *brainholeTitleView;  //脑洞标题
    UIView *avatarView;
    UIView *contentView;
    UIView *tagView;  //标签

    UIView *sourceView;  //作品来源
    GetFuelListView *getFuelListArea;  //加油榜
    UITableView *commentTableView;  //评论
    
    BrainholeFooterBar *footerBar;
}

@property (nonatomic, strong) UIBarButtonItem *moreBar;

@property (nonatomic, strong) UILabel *brainholeTitle;  //脑洞标题
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickname;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UILabel *content;  //脑洞文本
@property (nonatomic, strong) UIButton *starButton;  //星球
@property (nonatomic, strong) IXAttributeTapLabel *tagL;  //标签
@property (nonatomic, strong) UILabel *source;  //作品来源

@property (nonatomic, strong) NSMutableArray *commentsArray;
@property (nonatomic, strong) NSMutableArray *fuelArray;  //test
@property (nonatomic, strong) HotBrainholeModel *hotBrainholeModel;  //test
@property (nonatomic, strong) NSString *brainholeCommentText;  //编辑完成的脑洞文本

@property (nonatomic, strong) LWHTMLDisplayView *htmlView;
@property (nonatomic, assign) BOOL isNeedRefresh;
@property (nonatomic, assign) CGFloat htmlViewHeight;

@property (nonatomic, strong) GetFuelView *getFuelView;

@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, strong) NSConditionLock *lock;

@property (nonatomic, strong) NSMutableArray *videoIdArray;

@end

@implementation BrainholeDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navigationItem.title = @"脑洞";
    self.gk_navRightBarButtonItem = self.moreBar;

    self.commentsArray = @[].mutableCopy;
    pageNum = 0;

    [self requestAll];
    [self initBrainholeTextView];  //待优化
    
    //脑洞评论按时间排序观察者
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soryBrainholeCommentByTime) name:@"BrainholeCommentSortByTimeNotification" object:nil];
    
    //脑洞评论点赞观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(brainholeCommentLike:) name:@"BrainholeCommentLikeNotification" object:nil];
    
    //注册FooterBar观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFooterActionNotification:) name:@"BrainholeDetailFooterNotification" object:nil];
    
    //注册加油观察者
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAddFuelActionNotification:) name:@"addFuelActionNotification" object:nil];
    
    //注册进入加油站通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterAddFuelView:) name:@"enterAddFuelViewNotification" object:nil];

}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BrainholeCommentSortByTimeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BrainholeCommentLikeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BrainholeDetailFooterNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addFuelActionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"enterAddFuelViewNotification" object:nil];

}

- (UIBarButtonItem *)moreBar {
    if (!_moreBar) {
        _moreBar = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"navgationBar_more"] target:self action:@selector(showShareView)];
    }
    return _moreBar;
}

/* 星球详情 */
- (void)enterStarDetailsAction:(UIButton *)sender {
    StarDetailViewController *starVC = [[StarDetailViewController alloc] init];
    starVC.pid = self.hotBrainholeModel.starTagId ;
    starVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:starVC animated:YES];
}

#pragma mark -- 通知 --

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
    NSInteger myFuel = [AppCacheManager sharedSession].myFuel;
    if (myFuel < 5) {
        [SVProgressHUD showErrorWithStatus:@"燃料不足"];
        [SVProgressHUD dismissWithDelay:2.0];
        return;
    }
    if (fuel < 5) {
        if (myFuel >= 5) {
            [SVProgressHUD showErrorWithStatus:@"请加燃料"];
            [SVProgressHUD dismissWithDelay:2.0];
            return;
        }
    }
    
    NSDictionary *param = @{
                              @"oil":@(fuel),
                              @"postId":@(self.brainholeId),
                              @"sourceType":@(0),
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

/* 对脑洞评论点赞 */
- (void)brainholeCommentLike:(NSNotification *)notification {
//    NSDictionary *object = @{
//                               @"selectStatus":@(like),
//                               @"commentId":@(self.commentModel.id)
//                             };
    NSDictionary *object = notification.object;
    
    NSNumber *selectStatus = object[@"selectStatus"];
    NSNumber *commentId = object[@"commentId"];

    NSDictionary *param = @{ @"id":commentId,
                             @"thumbsType":selectStatus
                           };
    NSString *token = [AppCacheManager sharedSession].token;
    
    [RequestHandle likeForComment:param authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {

    } fail:^(NSError * _Nonnull error) {
        
    }];
}




- (void)soryBrainholeCommentByTime {
    NSDictionary *param = @{
                             @"postId":@(self.brainholeId),
                             @"pageNum":@(1),
                             @"pageSize":@(20)
                           };
    NSString *token = [AppCacheManager sharedSession].token;
    [RequestHandle requestBrainholeComment:param authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
    } fail:^(NSError * _Nonnull error) {
    }];
}

//底栏
- (void)receiveFooterActionNotification:(NSNotification *)notification {
    if (![GlobalHandle isLoginUser]) {
        PwdLoginViewController * loginVC = [[PwdLoginViewController alloc]init];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    NSNumber *tagNumber = notification.object;
    NSInteger tag = [tagNumber integerValue];

    if (tag == 11) {
        //上传视频
        PostBrainholeViewController *postVC = [[PostBrainholeViewController alloc] init];
        postVC.isUploadVideo = YES;
        postVC.isPush = YES;
        postVC.brainholeId = self.brainholeId;
        [self.navigationController pushViewController:postVC animated:NO];
        
    } else if(tag == 12) {
        //发布评论
        NSString *token = [AppCacheManager sharedSession].token;
        if (!token) {
           [SVProgressHUD showInfoWithStatus:@"非注册用户无法评论"];
           [SVProgressHUD dismissWithDelay:1.0];
           return;
        }
//        PostCommentViewController *postCommentVC = [[PostCommentViewController alloc] init];
//        postCommentVC.brainholeId = self.brainholeId;
//        [self.navigationController pushViewController:postCommentVC animated:NO];
        
        PostNewCommentViewController *commentVC = [[PostNewCommentViewController alloc] init];
        commentVC.brainholeId = self.brainholeId;
        [self.navigationController pushViewController:commentVC animated:YES];

    } else if(tag == 13) {
        //点赞
        NSString *token = [AppCacheManager sharedSession].token;
        [RequestHandle likeForBrainhole:@{ @"postid":@(self.brainholeId) } authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        } success:^(id  _Nullable response) {
        } fail:^(NSError * _Nonnull error) {
        }];
        
    } else if (tag == 14) {
        //分享
        [self showShareView];
    } else {
        //加油
        [GlobalHandle getUserInfo];  //更新我的燃料数   待测试
        self.getFuelView = [[GetFuelView alloc] initWithFrame:CGRectZero];
        self.getFuelView.myFuel = [AppCacheManager sharedSession].myFuel;
        [self.getFuelView showAction];
    }
}

#pragma mark -- 点击事件 --

/* 加油列表 */
- (void)enterFuelListView {
    FuellistViewController *vc = [FuellistViewController new];
    vc.isVideo = NO;
    vc.pid = [NSString stringWithFormat:@"%ld", (long)self.brainholeId];
    [self.navigationController pushViewController:vc animated:YES];
}

/* 弹出分享视图 */
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
        if (self.videoIdArray && self.videoIdArray.count > 0) {
            for (NSInteger i = 0; i < self.videoIdArray.count; i++) {
                NSString *videoIdStr = self.videoIdArray[i];
                videoIdStr = [videoIdStr stringByAppendingString:@","];
                ids = [ids stringByAppendingString:videoIdStr];
            }
        }
        
        NSString *baseUrl = BaseUrl;
        baseUrl = [baseUrl stringByReplacingOccurrencesOfString:@"api"withString:@""];
        NSString *webpageUrl = [NSString stringWithFormat:@"%@index.html?token=%@&id=%li&ids=%@",baseUrl, token, (long)self.brainholeId, ids];
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

/* 评论查询 - 时间/热度 */
- (void)sortByTimeAction {
     
}



/* 主视图 */
- (void)initBrainholeTextView {
    //评论头视图
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //脑洞文本区
    brainholeTextArea = [[UIView alloc] initWithFrame:CGRectZero];
    [tableHeaderView addSubview:brainholeTextArea];
    
    //脑洞标题
    brainholeTitleView = [[UIView alloc] initWithFrame:CGRectZero];
    [brainholeTextArea addSubview:brainholeTitleView];

    self.brainholeTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    self.brainholeTitle.font = PingFangSC_Medium(18);
    self.brainholeTitle.textColor = UICOLOR(@"#343338");
    self.brainholeTitle.preferredMaxLayoutWidth = SCREENWIDTH - 32;
    self.content.lineBreakMode = NSLineBreakByWordWrapping;

    self.brainholeTitle.numberOfLines = 0;
    [self.brainholeTitle sizeToFit];
    [brainholeTitleView addSubview:self.brainholeTitle];

    //头像
    avatarView = [[UIView alloc] initWithFrame:CGRectZero];
    [brainholeTextArea addSubview:avatarView];

    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
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

    //脑洞内容
    contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [brainholeTextArea addSubview:contentView];

//    self.content = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.content.font = PingFangSC_Regular(18);
//    self.content.textColor = UICOLOR(@"#343338");
//    self.content.numberOfLines = 0;
//    [self.content sizeToFit];
//    [contentView addSubview:self.content];
    

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    self.htmlView = [[LWHTMLDisplayView alloc] initWithFrame:CGRectZero];
    self.htmlView.showsVerticalScrollIndicator = NO;
    [contentView addSubview:self.htmlView];
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    //星球
    self.starButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [brainholeTextArea addSubview:self.starButton];
    
    self.starButton.titleLabel.font = PingFangSC_Regular(14);
    [self.starButton setTitleColor:UICOLOR(@"#6692EE") forState:UIControlStateNormal];
    [self.starButton setImage:[UIImage imageNamed:@"footer_star"] forState:UIControlStateNormal];
    [self.starButton SG_imagePositionStyle:SGImagePositionStyleLeft spacing:4.0];
    [self.starButton addTarget:self action:@selector(enterStarDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //标签
    tagView = [[UIView alloc] initWithFrame:CGRectZero];
    [brainholeTextArea addSubview:tagView];
    

    self.tagL = [[IXAttributeTapLabel alloc] initWithFrame:CGRectZero];
    [tagView addSubview:self.tagL];
    
    self.tagL.textAlignment = NSTextAlignmentLeft;
    self.tagL.font = PingFangSC_Regular(14);
    self.tagL.textColor = UICOLOR(@"#6692EE");
    self.tagL.numberOfLines = 0;
    
    //来源
    sourceView = [[UIView alloc] initWithFrame:CGRectZero];
    [brainholeTextArea addSubview:sourceView];
    
    self.source = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.source.text = @"作品来源";
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
    commentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    commentTableView.estimatedRowHeight = 200;
    commentTableView.rowHeight = UITableViewAutomaticDimension;
    commentTableView.tableHeaderView = tableHeaderView;
    commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:commentTableView];
    
    //底栏 - 上传视频、评论 ...
    footerBar = [[BrainholeFooterBar alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - self.view.frame.size.height - StatusAndNaviHeight, SCREENWIDTH, 58)];
//    footerBar.backgroundColor = [UIColor redColor];
    [self.view addSubview:footerBar];
    
}


#pragma mark -- 图片自适应文本 --

- (NSAttributedString *)showAttributedToHtml:(NSString *)html withWidth:(float)width {
    //替换图片的高度为屏幕的高度
    //width为UITextView的宽度
    
    NSString *str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",width,html];
        
    NSAttributedString *attributeString=[[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    return attributeString;
}

#pragma mark -- HTML解析生成布局模型 --

- (void)parsing:(NSString *)htmlString {
//    [LWActiveIncator showInView:self.view];

    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    self.htmlView.data = htmlData;

    LWHTMLLayout *htmlLayout = [[LWHTMLLayout alloc] init];
    LWStorageBuilder *builder = self.htmlView.storageBuilder;

    LWHTMLTextConfig *textConfig = [[LWHTMLTextConfig alloc] init];
    textConfig.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    textConfig.textColor = RGB(50, 50, 50, 1);

    LWHTMLImageConfig* imageConfig = [[LWHTMLImageConfig alloc] init];
    imageConfig.size = CGSizeMake(SCREEN_WIDTH - 20.0f, 240.0f);
    imageConfig.autolayoutHeight = YES;//自动按照图片的大小匹配一个适合的高度

    //待修改
    [builder createLWStorageWithXPath:@"//p"
    paragraphEdgeInsets:UIEdgeInsetsMake(10.0f, 0.0f, 10.0, 20.0f)
    configDictionary:@{ @"p":textConfig }];
    [htmlLayout addStorages:builder.storages];

    [builder createLWStorageWithXPath:@"//img"
          paragraphEdgeInsets:UIEdgeInsetsMake(10.0f, 0.0f, 10.0, 20.0f)
             configDictionary:@{ @"img":imageConfig }];
    
    [htmlLayout addStorages:builder.storages];

//    dispatch_async(dispatch_get_main_queue(), ^{
        self.htmlView.layout = htmlLayout;
        self.htmlView.frame = CGRectMake(0, 0, SCREENWIDTH - 32, self.htmlView.height);
//        [LWActiveIncator hideInViwe:self.view];
//    });
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(avatarView.mas_bottom).mas_offset(8);
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(SCREENWIDTH - 32);
        make.height.mas_equalTo(self.htmlView.height);
    }];
    
}

#pragma mark -- 布局 --

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //重新获取header高度
    [commentTableView.tableHeaderView layoutIfNeeded];
    commentTableView.tableHeaderView = tableHeaderView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    [commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusAndNaviHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);  //footerBar
    }];
    
    [tableHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.equalTo(getFuelListArea).offset(80);
    }];
    
    [brainholeTextArea mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableHeaderView).offset(12);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(sourceView.mas_bottom).offset(20);
    }];

    [brainholeTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.width.mas_equalTo(SCREENWIDTH - 32);
    }];
    
    [self.brainholeTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(brainholeTitleView);
    }];
    
    [avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(brainholeTitleView.mas_bottom).mas_offset(14);
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
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(avatarView.mas_bottom).mas_offset(8);
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(SCREENWIDTH - 32);
    }];
    
    [self.htmlView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    
    [self.starButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).mas_offset(10);
        make.left.mas_offset(0);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(20);
    }];
    
    [tagView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).mas_offset(10);
        make.left.equalTo(self.starButton.mas_right).mas_offset(4);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(SCREENWIDTH - 32);
    }];
    
    [self.tagL mas_updateConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(brainholeTextArea.mas_bottom).offset(10);  //待修改
        make.left.right.offset(0);
        make.height.equalTo(@145);
        make.bottom.equalTo(tableHeaderView).offset(0);
    }];
    
    [footerBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(58);
        make.bottom.equalTo(self.view);
    }];
    
    [commentTableView.tableHeaderView layoutIfNeeded];  //重点
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

- (void)updateModel:(HotBrainholeModel *)model {
    if (!model) {
        return;
    }
    //标题
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:model.title];
    NSMutableAttributedString *originalMutableAttr = nil;
    NSAttributedString *spaceAttr = [[NSAttributedString alloc] initWithString:@" "];

    if (model.original == 0) {
        NSAttributedString *originalAttr = [self setAttactToAttributeSting:[UIImage imageNamed:@"original"]];
        originalMutableAttr = [[NSMutableAttributedString alloc] initWithAttributedString:originalAttr];
        [originalMutableAttr appendAttributedString:spaceAttr];
        [originalMutableAttr appendAttributedString:titleAttr];
        self.brainholeTitle.attributedText = originalMutableAttr;
    } else {
        self.brainholeTitle.text = model.title;
    }

    //头像
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.userModel.picUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.nickname.text = model.userModel.nickName;
    self.date.text = [model.createTime substringToIndex:10];  //创建日期

    //内容
    [self parsing:model.content];  //脑洞详情

    //星球
    [self.starButton setTitle:model.starTag forState:UIControlStateNormal];

    //标签
    [self setTagStringAndClickAction:model.tagArray];

    //作品来源
    self.source.text = model.source;

    //加油榜
    getFuelListArea.fuelUserArray = model.getFuelUserArray;  //传值
    getFuelListArea.getFuelModel = model.getFuelModel;
        
    //评论
    self.commentsArray = model.commentArray;
    [commentTableView reloadData];
    [commentTableView setNeedsLayout];  //更新
    [commentTableView.tableHeaderView layoutIfNeeded];

    //底栏
    BrainholeFooterBarModel *footerBarModel = [[BrainholeFooterBarModel alloc] init];
    footerBarModel.comments = model.commentArray.count;
    footerBarModel.like = model.isStatus;  //是否点过赞
    footerBarModel.likes = model.likeNum;
    footerBarModel.shares = model.shareNum;
    footerBarModel.fuels = model.getFuelModel.getOilNum;
    footerBar.footerModel = footerBarModel;

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
    
    self.lock = [[NSConditionLock alloc] init];
    [SVProgressHUD show];
    dispatch_group_async(_group, queue, ^{
        [self.lock lock];
        [self getBrainholeDetails];
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
    
//    [self shareBrainhole];
 
//    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
//        [SVProgressHUD dismiss];
//        [self updateModel:self.hotBrainholeModel];
//    });
    
    
}

/* 请求脑洞详情 */
- (void)getBrainholeDetails {
    [RequestHandle getBrainholeDetails:@{ @"id": @(self.brainholeId) } authorization:@"" success:^(id  _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            [self.lock unlock];
            return;
        }
        
        NSArray *array = response[@"data"];
        NSDictionary *brainholeDic = array[0][@"hotPost"];  //脑洞 - 详情
        NSDictionary *brainholeTextDic =  brainholeDic[@"post"];  //脑洞文本
        HotBrainholeModel *hotBrainholeModel = [HotBrainholeModel mj_objectWithKeyValues:brainholeTextDic];

        
        self.videoIdArray = @[].mutableCopy;
        NSArray *vIdArray =  brainholeDic[@"videoList"];  //脑洞 - 视频
        
        for (NSInteger i = 0; i < vIdArray.count; i++) {
            NSDictionary *dic = vIdArray[i];
            NSString *videoId = [dic[@"id"] stringValue] ;
            [self.videoIdArray addObject:videoId];
        }
        
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
        hotBrainholeModel.userModel = userModel;
        self.hotBrainholeModel = hotBrainholeModel;  //数据汇总完成
        
        [self->brainholeTextArea setNeedsLayout];
                
        [self.lock unlock];
    } fail:^(NSError * _Nonnull error) {
        [self.lock unlock];
    }];
}

- (void)getFuelUserList {
    NSDictionary *param = @{
                             @"postId": @(self.brainholeId),
                             @"pageNum": @(1),
                             @"pageSize":@(10)
                           };
  [RequestHandle getGetFuelUserlist:param authorization:@"" success:^(id  _Nullable response) {
      if ([response[@"code"] integerValue] != 0) {
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
//      self->getFuelListArea.fuelUserArray =  [fuelArray mutableCopy];
//      self->getFuelListArea.frame = CGRectMake(0, 0, 100, 100);  //layout
//      [self->getFuelListArea setNeedsLayout];  //更新
      
      [self.lock unlock];

      } fail:^(NSError * _Nonnull error) {
          [self.lock unlock];
  }];
}

- (void)getFuelNumber {
    NSDictionary *param = @{
                             @"id": @(self.brainholeId),
                             @"type": @(0)
                           };
    [RequestHandle getGetFuellistNum:param authorization:@"" success:^(id  _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            [self.lock unlock];
            return;
        }
        NSDictionary *getFuelNumDic = response[@"data"];
        GetFuelModel *model = [GetFuelModel mj_objectWithKeyValues:getFuelNumDic];
        self.hotBrainholeModel.getFuelModel = model;

        [self.lock unlock];

    } fail:^(NSError * _Nonnull error) {
        [self.lock unlock];
    }];
}

- (void)getCommentList {
    pageNum++;
    NSDictionary *param = @{
                             @"postId":@(self.brainholeId),
                             @"pageNum":@(pageNum),
                             @"pageSize":@(10)
                           };
    NSString *token = [AppCacheManager sharedSession].token;
    
    [RequestHandle requestBrainholeComment:param authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            [self.lock unlock];
            return;
        }
        
        NSArray *commentArray = response[@"data"][@"list"];
        if ([commentArray isKindOfClass:[NSNull class]]) {
            commentArray = @[];  //后台为空是传null 过滤null
        }
        if (commentArray.count == 0) {
            pageNum--;
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
            [tempArray addObject:commentModel];
        }
        self.hotBrainholeModel.commentArray = tempArray;
    
        [self.lock unlock];
        
        // -  -  - -  -  - -  -  - -  -  - -  -  - -  -  -
        [SVProgressHUD dismiss];
        [self updateModel:self.hotBrainholeModel];
        // -  -  - -  -  - -  -  - -  -  - -  -  - -  -  -
        
        
    } fail:^(NSError * _Nonnull error) {
        // -  -  - -  -  - -  -  - -  -  - -  -  - -  -  -
        [SVProgressHUD dismiss];  //待修改
        // -  -  - -  -  - -  -  - -  -  - -  -  - -  -
        [self.lock unlock];
    }];
   
}

/* 分享次数 */
- (void)shareBrainhole {
    NSDictionary *param = @{
        
                             @"id":@(self.brainholeId),
                             @"aType":@(0),
                           };
    NSString *token = [AppCacheManager sharedSession].token;
    [RequestHandle shareBrainhole:param authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        
    } fail:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark -- 评论列表代理 --

//评论查询 - 时间
- (void)sortByTime:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString *sort = @"0";
    if (sender.selected) {
        sort = @"1";
    }
//    [self requestAll];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommentModel *model = self.commentsArray[indexPath.row];
    cell.commentModel = model;
    [cell layoutIfNeeded];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

@end
