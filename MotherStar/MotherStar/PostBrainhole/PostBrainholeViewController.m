//
//  PostBrainholeViewController.m
//  MotherStar
//  发布脑洞
//  Created by yanming niu on 2019/12/12.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "PostBrainholeViewController.h"
#import "SaveBrainholeTextViewController.h"
#import "EditBrainholeTextViewController.h"
#import "EBDropdownListView.h"
#import "StarModel.h"
#import "PostBrainholeModel.h"
#import "ReleaseViewController.h"
#import "StarSwitch.h"


typedef NS_ENUM(NSInteger, UploadOSSStatus) {
    uploadOSSNone,
    uploadingOSS,
    uploadOSSFinish
};

#define UpLoading  @"上传中..."
#define UpLoadFinish  @"上传完成"


@interface PostBrainholeViewController () <UIScrollViewDelegate>{
    UploadOSSStatus uploadOSSStatus;
    
    UIImageView *imageView;
    UITextView *textView;
    
    UIScrollView *scrollView;
    UIView *container;
    
    UIView *brainholeArea;  //脑洞文本区

    UIView *headView;
    UILabel *titleL;
    TXLimitedTextField *titleContent;  //标题

    UIView *brainholeView;
    UILabel *brainTitleL;
    UITextView *brainContent;

    UIView *planetView;
    UILabel *planetL;
    UIView *planets;
    
    UIView *tagView;
    UILabel *tagL;
    TXLimitedTextField *tagContent;  //标签
    
    UIView *originalView;
    UILabel *originalL;
    UILabel *originalSubL;
    StarSwitch *originalSwitch;

    UIView *sourceView;
    UILabel *sourceL;
    TXLimitedTextField *sourceContent;  //脑洞文本来源


    UIView *uploadSwitchArea;
    CustomLabel *uploadSwitchL;
    StarSwitch *uploadSwitch;

    UIView *videoArea;  //视频区

    UIView *addVideoView;
    UILabel *uploadStatus;
    UIButton *deleteButton;
//    UIImageView *uploadImageView;
    
    UIView *vTitleView;
    UILabel *vTitleL;
    TXLimitedTextField *vTitleContent;  //视频标题

    UIView *descriptionView;
    UILabel *descriptionL;
    UITextView *descriptionContent;

    UIView *vTagView;
    UILabel *vTagL;
    TXLimitedTextField *vTagContent;  //视频标签

    UIView *vOriginalView;
    UILabel *vOriginalL;
    UILabel *vOriginalSubL;
    StarSwitch *vOriginalSwitch;

    UIView *vSourceView;
    UILabel *vSourceL;
    TXLimitedTextField *vSourceContent;  //视频来源
    
    UIButton *submit;
    
    
}

@property (nonatomic, strong) UIBarButtonItem *cancelButton;

@property (nonatomic, strong) UIImage *firstFrame;
@property (nonatomic, strong) NSData *videoData;
@property (nonatomic, strong) NSString *videoUrl;

@property (nonatomic, strong) OSSManager *ossManager;
@property (nonatomic, strong) UIImageView *uploadImageView;  //视频第一帧

@property (nonatomic, strong) NSString *videoDuration;  //视频时长

@property (nonatomic, assign) NSInteger textOriginal;
@property (nonatomic, assign) NSInteger videoOriginal;

@property (nonatomic, strong) NSString *brainholeText;  //编辑完成的脑洞文本
@property (nonatomic, assign) NSInteger starId;  //星球Id

@end

@implementation PostBrainholeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
    //检查是否登录
     if (![GlobalHandle isLoginUser]) {
        PwdLoginViewController * loginVC = [[PwdLoginViewController alloc] init];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    NSString *title = @"脑洞";
    if (self.isUploadVideo) {
        title = @"上传视频";
    }
    self.gk_navigationItem.title = title;

    self.gk_navRightBarButtonItem =  self.cancelButton;
    
    [self initBrainUI];
    scrollView.delegate = self;
}

- (UIBarButtonItem *)cancelButton {
    if (!_cancelButton) {
        UIButton *cancel = [UIButton new];
        cancel.frame = CGRectMake(0, 0, 28, 14);
        cancel.titleLabel.font = PingFangSC_Regular(14);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:UICOLOR(@"#343338") forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelPost) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    }
    return _cancelButton;
}

- (void)backAction {
    if (self.isPush) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.videoUrl.length > 0 || brainContent.text.length > 0 || self.starId > 0) {
               MotherPlanetAlertView *alertView = [[MotherPlanetAlertView alloc] init:@"退出编辑" message:@"已填写内容将被删除" ok:@"退出" cancel:@"留下"];
            alertView.canRemove = YES;

                  alertView.okBlock = ^(){
                      RootViewController *rootVC = [[RootViewController alloc] init];
                      [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
                  };
           } else {
               RootViewController *rootVC = [[RootViewController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
           }
    }
}

- (void)cancelPost {
    if (self.videoUrl.length > 0 || brainContent.text.length > 0 || self.starId > 0) {
        MotherPlanetAlertView *alertView = [[MotherPlanetAlertView alloc] init:@"退出编辑" message:@"已填写内容将被删除" ok:@"退出" cancel:@"留下"];
        alertView.canRemove = YES;

        alertView.okBlock = ^(){
               RootViewController *rootVC = [[RootViewController alloc] init];
               [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
           };
    } else {
        RootViewController *rootVC = [[RootViewController alloc] init];
         [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    }
}


#pragma --  页面布局  --

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

- (void)initBrainUI {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;  //视频滚动时隐藏键盘

    container = [[UIView alloc] initWithFrame:CGRectZero];  //整个区域
    [scrollView addSubview:container];

    /* 脑洞区 - 可以隐藏 */
    brainholeArea = [[UIView alloc] initWithFrame:CGRectZero];
    [container addSubview:brainholeArea];
    
    [self hiddenholeBrainArea];  //自动隐藏脑洞文本区
    
    /* 标题 */
    headView = [[UIView alloc] initWithFrame:CGRectZero];  //脑洞区
    [brainholeArea addSubview:headView];

    titleL = [[UILabel alloc] initWithFrame:CGRectZero];  //富文本
    titleL.attributedText = [self setTitleToAttributedTextStyle1:@"标题" subString2:@"(选填)"];
    [headView addSubview:titleL];

    titleContent = [[TXLimitedTextField alloc] initWithFrame:CGRectZero];
    titleContent.limitedNumber = 30;  //限制30
    titleContent.layer.cornerRadius = 5;
    titleContent.backgroundColor = UICOLOR(@"#F6F6F6");
    titleContent.attributedPlaceholder = [@"30个字以内" setStringToAttributedString:@"30个字以内" font:PingFangSC_Light(18) color:UICOLOR(@"#868686")];
    [headView addSubview:titleContent];

    brainholeView = [[UIView alloc] initWithFrame:CGRectZero];
    [brainholeArea addSubview:brainholeView];

    brainTitleL  = [[UILabel alloc] initWithFrame:CGRectZero];  //富文本
    brainTitleL.attributedText = [self setTitleToAttributedTextStyle1:@"脑洞" subString2:@"(必填)"];
    [brainholeView addSubview:brainTitleL];


    brainContent = [[UITextView alloc] initWithFrame:CGRectZero];
    brainContent.layer.cornerRadius = 5;
    brainContent.layer.masksToBounds = YES;
    brainContent.backgroundColor = UICOLOR(@"#F6F6F6");

    //UITextView 显示富文本  添加手势  禁止编辑
    brainContent.userInteractionEnabled = YES;
    brainContent.editable = NO;
    UITapGestureRecognizer *tapGestureEdit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editBrainholeText)];
    [brainContent addGestureRecognizer:tapGestureEdit];
    
    
    //显示脑洞内容 - 图文混排模式
    [brainholeView addSubview:brainContent];

    //星球
    planetView = [[UIView alloc] initWithFrame:CGRectZero];
    [brainholeArea addSubview:planetView];

    planetL  = [[UILabel alloc] initWithFrame:CGRectZero];  //富文本
    planetL.attributedText = [self setTitleToAttributedTextStyle1:@"星球" subString2:@"(必填)"];
    [planetView addSubview:planetL];

    planets = [[UIView alloc] initWithFrame:CGRectZero];
    planets.layer.cornerRadius = 5;
    planets.backgroundColor = UICOLOR(@"#F6F6F6");
    
    [self initStarListView];  //初始化下拉列表
    
    [planetView addSubview:planets];

    //添加button
    //星球列表view

    //标签
    tagView = [[UIView alloc] initWithFrame:CGRectZero];
    [brainholeArea addSubview:tagView];

    tagL  = [[UILabel alloc] initWithFrame:CGRectZero];  //富文本
    tagL.attributedText = [self setTitleToAttributedTextStyle1:@"标签" subString2:@"(选填)"];
    [tagView addSubview:tagL];

    tagContent = [[TXLimitedTextField alloc] initWithFrame:CGRectZero];
    tagContent.limitedNumber = 30;  //临时限制

    tagContent.layer.cornerRadius = 5;
    tagContent.backgroundColor = UICOLOR(@"#F6F6F6");
    tagContent.attributedPlaceholder = [self setTitleToAttributedTextStyle3:@"例如：#二次元# #同人#"];
    [tagView addSubview:tagContent];

    //是否原创
    originalView = [[UIView alloc] initWithFrame:CGRectZero];
    [brainholeArea addSubview:originalView];

    originalL = [[UILabel alloc] initWithFrame:CGRectZero];
    [originalView addSubview:originalL];

    originalSubL = [[UILabel alloc] initWithFrame:CGRectZero];
    [originalView addSubview:originalSubL];

    NSMutableAttributedString *attString = [self setTitleToAttributedTextStyle2:@"是否原创"];
    NSMutableAttributedString *subAttString = [self setTitleToAttributedTextStyle3:@"非原创内容无法得到其他用户的加油燃料"];
    originalL.attributedText = attString;
    originalSubL.attributedText = subAttString;

    originalSwitch = [[StarSwitch alloc] initWithFrame:CGRectZero];
    originalSwitch.tag = 99;
    [originalSwitch setEnlargeEdge:30];
    [originalSwitch setOn:YES animated:NO];  //默认开启
    [self hiddenSourceView:originalSwitch needsUpdateConstraints:NO];

    [originalSwitch addTarget:self action:@selector(switchChange:)forControlEvents:UIControlEventValueChanged];
    [originalView addSubview:originalSwitch];

    //出处
    sourceView = [[UIView alloc] initWithFrame:CGRectZero];
    [brainholeArea addSubview:sourceView];

    sourceL  = [[UILabel alloc] initWithFrame:CGRectZero];  //富文本
    sourceL.attributedText = [self setTitleToAttributedTextStyle1:@"出处" subString2:@"(选填)"];
    [sourceView addSubview:sourceL];
    
    sourceContent = [[TXLimitedTextField alloc] initWithFrame:CGRectZero];
    sourceContent.limitedNumber = 9;
    sourceContent.layer.cornerRadius = 5;
    sourceContent.backgroundColor = UICOLOR(@"#F6F6F6");
    sourceContent.attributedPlaceholder = [self setTitleToAttributedTextStyle3:@"原内容出处或者作者"];
    [sourceView addSubview:sourceContent];

    /* 上传视频开关区 - 可以隐藏 */
    uploadSwitchArea = [[UIView alloc] initWithFrame:CGRectZero];
    [container addSubview:uploadSwitchArea];

    uploadSwitchL = [[CustomLabel alloc] initWithFrame:CGRectZero];  //富文本
    uploadSwitchL.attributedText = [self setTitleToAttributedTextStyle2:@"现在上传视频"];
    [uploadSwitchArea addSubview:uploadSwitchL];

//    uploadSwitchL.textInsets = UIEdgeInsetsMake(-5, 0, 0, 0);  //top,left,bottom,right 设置左内边距
 
    uploadSwitch = [[StarSwitch alloc] initWithFrame:CGRectZero];
    uploadSwitch.tag = 100;
    [uploadSwitch setEnlargeEdge:30];

    [uploadSwitch setOn:YES animated:NO];  //默认开启
    [uploadSwitch addTarget:self action:@selector(switchChange:)forControlEvents:UIControlEventValueChanged];

    [uploadSwitchArea addSubview:uploadSwitch];

    /* 视频区 - 可以隐藏 */
    videoArea = [[UIView alloc] initWithFrame:CGRectZero];
    [container addSubview:videoArea];

    //添加视频
    addVideoView = [[UIView alloc] initWithFrame:CGRectZero];
    [videoArea addSubview:addVideoView];
    
    uploadStatus  = [[UILabel alloc] initWithFrame:CGRectZero];  //默认不显示
    uploadStatus.font = UIFONT(12);
    uploadStatus.textColor = UICOLOR(@"#EFB400");
    [addVideoView addSubview:uploadStatus];

    deleteButton = [[UIButton alloc] initWithFrame:CGRectZero];  //上传、取消
    [addVideoView addSubview:deleteButton];
    [deleteButton setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
    [deleteButton setImage:[UIImage imageNamed:@"deleteVideo"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteVideoAction) forControlEvents:UIControlEventTouchUpInside];
    [self setUploadStatus:uploadOSSNone];  //默认 不显示上传状态和删除按钮

    _uploadImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [addVideoView addSubview:_uploadImageView];

    _uploadImageView.layer.cornerRadius = 5;
    _uploadImageView.layer.masksToBounds = YES;
    _uploadImageView.backgroundColor = UICOLOR(@"#F6F6F6");
    _uploadImageView.contentMode = UIViewContentModeScaleToFill;
    _uploadImageView.image = [UIImage imageNamed:@"icon_video_default"];  //默认图片
    
    //添加视频

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFromPhotoAlbum)];
    [_uploadImageView addGestureRecognizer:tapGesture];

    
    //视频标题
    vTitleView = [[UIView alloc] initWithFrame:CGRectZero];
    [videoArea addSubview:vTitleView];
    
    vTitleL  = [[UILabel alloc] initWithFrame:CGRectZero];  //富文本
    [vTitleView addSubview:vTitleL];
    vTitleL.attributedText = [self setTitleToAttributedTextStyle1:@"视频标题" subString2:@"(必填)"];

    vTitleContent = [[TXLimitedTextField alloc] initWithFrame:CGRectZero];
    [vTitleView addSubview:vTitleContent];

    vTitleContent.limitedNumber = 30;
    vTitleContent.layer.cornerRadius = 5;
    vTitleContent.backgroundColor = UICOLOR(@"#F6F6F6");
    vTitleContent.attributedPlaceholder = [self setTitleToAttributedTextStyle3:@"30个字以内"];

    //视频描述
    descriptionView = [[UIView alloc] initWithFrame:CGRectZero];
    [videoArea addSubview:descriptionView];

    descriptionL = [[UILabel alloc] initWithFrame:CGRectZero];  //富文本
    [descriptionView addSubview:descriptionL];
    descriptionL.attributedText = [self setTitleToAttributedTextStyle1:@"视频描述" subString2:@"(选填)"];

    descriptionContent = [[UITextView alloc] initWithFrame:CGRectZero];
    [descriptionView addSubview:descriptionContent];
    descriptionContent.backgroundColor = UICOLOR(@"#F6F6F6");
    descriptionContent.zw_placeHolder = @"可以介绍下你的视频";
    descriptionContent.zw_limitCount = 300;
    descriptionContent.layer.cornerRadius = 5;

    //视频标签
    vTagView = [[UIView alloc] initWithFrame:CGRectZero];
    vTagL  = [[UILabel alloc] initWithFrame:CGRectZero];  //富文本
    vTagL.attributedText = [self setTitleToAttributedTextStyle1:@"视频标签" subString2:@"(选填)"];

    vTagContent = [[TXLimitedTextField alloc] initWithFrame:CGRectZero];
    vTagContent.limitedNumber = 30;
    vTagContent.layer.cornerRadius = 5;
    vTagContent.backgroundColor = UICOLOR(@"#F6F6F6");
    vTagContent.attributedPlaceholder = [self setTitleToAttributedTextStyle3:@"例如：#二次元# #同人#"];
    [vTagView addSubview:vTagL];
    [vTagView addSubview:vTagContent];
    [videoArea addSubview:vTagView];

      //是否原创
    vOriginalView = [[UIView alloc] initWithFrame:CGRectZero];
    vOriginalL = [[UILabel alloc] initWithFrame:CGRectZero];
    vOriginalSubL = [[UILabel alloc] initWithFrame:CGRectZero];

    vOriginalL.attributedText = attString;
    vOriginalSubL.attributedText = subAttString;
   
    vOriginalSwitch = [[StarSwitch alloc] initWithFrame:CGRectZero];
    vOriginalSwitch.tag = 101;
    [vOriginalSwitch setEnlargeEdge:30];
    [vOriginalSwitch setOn:YES animated:NO];  //默认开启
    [self hiddenSourceView:vOriginalSwitch needsUpdateConstraints:NO];

    [vOriginalSwitch addTarget:self action:@selector(switchChange:)forControlEvents:UIControlEventValueChanged];

    [vOriginalView addSubview:vOriginalL];
    [vOriginalView addSubview:vOriginalSubL];
    [vOriginalView addSubview:vOriginalSwitch];
    [videoArea addSubview:vOriginalView];

    //出处
    vSourceView = [[UIView alloc] initWithFrame:CGRectZero];
    [videoArea addSubview:vSourceView];

    vSourceL = [[UILabel alloc] initWithFrame:CGRectZero];  //富文本
    vSourceL.attributedText = [self setTitleToAttributedTextStyle1:@"出处" subString2:@"(选填)"];
    [vSourceView addSubview:vSourceL];

    
    vSourceContent = [[TXLimitedTextField alloc] initWithFrame:CGRectZero];
    vSourceContent.limitedNumber = 9;
    vSourceContent.layer.cornerRadius = 5;
    vSourceContent.backgroundColor = UICOLOR(@"#F6F6F6");
    vSourceContent.attributedPlaceholder = [self setTitleToAttributedTextStyle3:@"原内容出处或者作者"];
    [vSourceView addSubview:vSourceContent];

    //发布脑洞
    submit = [[UIButton alloc] initWithFrame:CGRectZero];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
//    submit.backgroundColor = [UIColor grayColor];
    submit.backgroundColor = UICOLOR(@"#EFB400");

    submit.userInteractionEnabled = YES;
    submit.enabled = YES;  //默认灰色，不可点击

    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submit];
    
    [self getSub:self.view andLevel:1];  //打开 UILabel UITextView的交互属性

    [self.view setNeedsUpdateConstraints];  //更新布局
}
/* 初始化星球列表 */
- (void)initStarListView {
//    StarModel *model1 = [[StarModel alloc] init];
//    model1.id = @"10";
//    model1.tagTitle = @"地球";
//
//    StarModel *model2 = [[StarModel alloc] init];
//    model2.id = @"11";
//    model2.tagTitle = @"火星";
    
//    NSArray *starsArray = @[model1, model2];
   
    
    NSArray *starsArray =  [GlobalSingleton sharedInstance].model.starsArray;
    NSMutableArray *itemsArray = @[].mutableCopy;  //EBDropdownListItem 类型

    for (NSInteger i = 0; i < starsArray.count; i++) {
        StarModel *model = starsArray[i];
        EBDropdownListItem *item = [[EBDropdownListItem alloc] initWithItem:[NSString stringWithFormat:@"%li", (long)model.id] itemName:model.tagTitle];
        [itemsArray addObject:item];
        
        if (i == 0) {
            self.starId = [item.itemId integerValue];  //默认
        }
    }
    
    EBDropdownListView *dropdownListView = [[EBDropdownListView alloc] initWithDataSource:itemsArray];
    dropdownListView.frame = CGRectMake(0, 0, SCREENWIDTH - 32, 40);
    dropdownListView.selectedIndex = 0;
    [dropdownListView setViewBorder:0 borderColor:[UIColor grayColor] cornerRadius:5];
    [planets addSubview:dropdownListView];

    
    [dropdownListView setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {
        self.starId = [dropdownListView.selectedItem.itemId integerValue];
    }];
}

#pragma mark  -- 约束 --

- (void)updateViewConstraints {
    [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(StatusAndNaviHeight);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
    }];
      
    [container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
//        container.backgroundColor = [UIColor blueColor];  //内容区  文本+视频
    }];
      
    [self updateBrainholeAreaConstraints];  //更新脑洞文本

    [self updateuploadSwitchAreaConstraints];  //添加视频开关
    
    [self updateVideoAreaConstraints];  //添加视频、上传视频脑洞
      
    [submit mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view);
    }];

    [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.isUploadVideo) {
            make.bottom.mas_equalTo(container.mas_bottom).offset(100);
        } else {
            make.bottom.mas_equalTo(container.mas_bottom).offset(50);
        }
        make.bottom.mas_greaterThanOrEqualTo(self.view);
    }];
    //        make.bottom.mas_equalTo(container.mas_bottom).priorityLow();
    [super updateViewConstraints];
}

- (void)updateBrainholeAreaConstraints {
    [brainholeArea mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container).offset(16);
        make.left.right.equalTo(container);
        if (originalSwitch.on) {
            [self hiddenSourceView:originalSwitch needsUpdateConstraints:NO];
            make.bottom.equalTo(originalView);
        }
    }];
      
    //标题
    [headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.equalTo(brainholeArea);
    }];
    
    [titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView);
        make.left.equalTo(headView);
        make.height.equalTo(@14);
    }];
    
    [titleContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset(10);
        make.left.right.equalTo(headView);
        make.height.equalTo(@40);
        make.bottom.mas_equalTo(0);
    }];
    
    //脑洞
    [brainholeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(20);
        make.left.right.equalTo(brainholeArea);
    }];

    [brainTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(@14);

    }];

    //脑洞文本内容
    [brainContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(brainTitleL.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(@168);
        make.bottom.mas_equalTo(0);

    }];
    
    //星球
    [planetView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(brainholeView.mas_bottom).offset(20);
        make.left.right.equalTo(brainholeArea);
    }];

    [planetL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.equalTo(planetView);
        make.height.equalTo(@14);
    }];

    [planets mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(planetL.mas_bottom).offset(10);
        make.left.right.equalTo(brainholeArea);
        make.height.equalTo(@40);
        make.bottom.mas_equalTo(0);
    }];

    //标签
    [tagView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(planetView.mas_bottom).offset(20);
        make.left.right.equalTo(brainholeArea);
    }];

    [tagL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagView);
        make.left.right.equalTo(brainholeArea);
        make.height.equalTo(@14);
    }];

    [tagContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagL.mas_bottom).offset(10);
        make.left.right.equalTo(brainholeArea);
        make.height.equalTo(@40);
        make.bottom.mas_equalTo(0);

    }];

    //原创
    [originalView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagView.mas_bottom).offset(20);
        make.left.right.equalTo(brainholeArea);
    }];

    [originalL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(originalView);
        make.left.equalTo(brainholeArea);
        make.height.equalTo(@14);
    }];
    
    [originalSubL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(originalL.mas_bottom).offset(6);
        make.left.equalTo(brainholeArea);
        make.height.equalTo(@10);
        make.bottom.mas_offset(0);
    }];
    
    [originalSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_offset(0);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(16);
    }];
    
    //出处
    [sourceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(originalView.mas_bottom).offset(20);
        make.left.right.equalTo(originalView);
    }];

    [sourceL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sourceView);
        make.left.right.equalTo(sourceView);
        make.height.equalTo(@14);
    }];

    [sourceContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sourceL.mas_bottom).offset(10);
        make.left.right.equalTo(originalView);
        make.height.equalTo(@40);
        make.bottom.mas_equalTo(0);
    }];
    
}

- (void)updateuploadSwitchAreaConstraints {
    [uploadSwitchArea mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(brainholeArea.mas_bottom).offset(20);
        make.left.right.mas_equalTo(container);
        make.height.equalTo(@16);  //与按钮高度相等
//        uploadSwitchArea.backgroundColor = [UIColor redColor];
    }];
    
    [uploadSwitchL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_offset(0);
        make.height.equalTo(@16);
    }];
       
    [uploadSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_offset(0);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(16);
    }];
}

- (void)updateVideoAreaConstraints {
    //添加视频
    [videoArea mas_updateConstraints:^(MASConstraintMaker *make) {
        if (vOriginalSwitch.on) {
            [self hiddenSourceView:vOriginalSwitch needsUpdateConstraints:NO];
        }
        if (self.isUploadVideo) {
            [self hiddenholeBrainArea];
            make.top.equalTo(container).offset(0);
        } else {
            make.top.equalTo(uploadSwitchArea.mas_bottom).offset(10);
        }
        make.left.right.equalTo(container);
        make.bottom.equalTo(vSourceView);
    }];
          
    [addVideoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(videoArea).offset(0);
        make.left.right.equalTo(videoArea);
    }];
    
    [uploadStatus mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addVideoView).offset(0);
        make.left.equalTo(addVideoView).offset(2);
        make.width.mas_equalTo(50);
        make.height.equalTo(@12);
    }];
    
    [deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addVideoView).offset(-2);
        make.right.equalTo(addVideoView).offset(0);
        make.width.height.equalTo(@17);
    }];
    
    [_uploadImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(uploadStatus.mas_bottom).offset(8.5);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(@193);
        make.bottom.mas_equalTo(0);
    }];
    
    //视频标题
    [vTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(addVideoView.mas_bottom).offset(20);
         make.left.right.mas_offset(0);
     }];

     [vTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(vTitleView);
         make.left.equalTo(vTitleView);
     }];

     [vTitleContent mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(vTitleL.mas_bottom).offset(10);
         make.left.right.equalTo(vTitleView);
         make.height.equalTo(@40);
         make.bottom.mas_equalTo(0);
     }];
    
    //视频描述
    [descriptionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vTitleView.mas_bottom).offset(20);
        make.left.right.equalTo(videoArea);
    }];

    [descriptionL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descriptionView);
        make.left.equalTo(videoArea);
    }];

    [descriptionContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descriptionL.mas_bottom).offset(10);
        make.left.right.equalTo(descriptionView);
        make.height.equalTo(@216);
        make.bottom.mas_equalTo(0);
    }];

    //视频标签
    [vTagView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descriptionView.mas_bottom).offset(20);
        make.left.right.equalTo(videoArea);
    }];

    [vTagL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vTagView);
        make.left.equalTo(vTagView);
    }];

    [vTagContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vTagL.mas_bottom).offset(10);
        make.left.right.equalTo(vTagView);
        make.height.equalTo(@40);
        make.bottom.mas_equalTo(0);
    }];

    //原创
    [vOriginalView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vTagView.mas_bottom).offset(20);
        make.left.right.equalTo(videoArea);
        make.bottom.equalTo(vOriginalSubL.mas_bottom);
//        vOriginalView.backgroundColor = [UIColor darkGrayColor];
    }];

    [vOriginalL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(vOriginalView);
        make.height.equalTo(@14);
    }];
    
    [vOriginalSubL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vOriginalL.mas_bottom).offset(6);
        make.left.equalTo(vOriginalView);
        make.height.equalTo(@10);
        make.bottom.mas_equalTo(0);
    }];

    [vOriginalSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_offset(0);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(16);
    }];

    //出处
    [vSourceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vOriginalView.mas_bottom).offset(20);
        make.left.right.equalTo(videoArea);
        make.bottom.equalTo(container.mas_bottom).mas_offset(0);  //test

    }];

    [vSourceL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vSourceView);
        make.left.equalTo(vSourceView);
        make.height.equalTo(@14);
    }];

    [vSourceContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vSourceL.mas_bottom).offset(10);
        make.left.right.equalTo(vSourceView);
        make.height.equalTo(@40);
        make.bottom.mas_offset(0);
//        make.bottom.equalTo(container);
    }];
  
}



#pragma mark --  更新子视图  --

/* 隐藏视频区 */
- (void)hiddenVideoArea:(BOOL)hidden {
    videoArea.hidden = hidden;
    if (hidden) {
        [container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scrollView);
            make.width.equalTo(scrollView);
            make.bottom.equalTo(uploadSwitchArea);
        }];
    } else {
        [container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scrollView);
            make.width.equalTo(scrollView);
        }];
    }
    [self.view setNeedsUpdateConstraints];  //更新布局
}

/* 隐藏出处 */
- (void)hiddenSourceView:(StarSwitch *)sender needsUpdateConstraints:(BOOL)need {
    if([sender isOn]) {
       if (sender.tag == 99) {
           originalSubL.hidden = NO;  //提示显示
           sourceView.hidden = YES;  //输入框不显示
//           [brainholeArea mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(container).offset(16);
//                make.left.right.equalTo(container);
//                make.bottom.equalTo(originalView);
//            }];
        } else if (sender.tag == 100) {
           
        } else {
           vOriginalSubL.hidden = NO;
           vSourceView.hidden = YES;
        }
    } else {
       if (sender.tag == 99) {
           originalSubL.hidden = YES;  //提示不显示
           sourceView.hidden = NO;
           [brainholeArea mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(container).offset(16);
               make.left.right.equalTo(container);
               make.bottom.equalTo(sourceView);
           }];
           
       } else if (sender.tag == 100) {
           
       } else {
           vOriginalSubL.hidden = YES;
           vSourceView.hidden = NO;
       }

       [container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scrollView);
            make.width.equalTo(scrollView);
       }];
    }

    if (need) {
        [self.view setNeedsUpdateConstraints];  //更新布局
    }
}

/* 隐藏脑洞文本区 */
- (void)hiddenholeBrainArea {
    if (self.isUploadVideo) {
        brainholeArea.hidden = YES;
        uploadSwitchArea.hidden = YES;
//
//        [videoArea mas_updateConstraints:^(MASConstraintMaker *make) {
//               make.top.equalTo(uploadSwitchArea.mas_bottom).offset(10);
//               make.left.right.equalTo(container);
//               make.bottom.equalTo(vSourceView);
//               [self hiddenSourceView:vOriginalSwitch needsUpdateConstraints:NO];
//           }];
//
//        [container mas_remakeConstraints:^(MASConstraintMaker *make) {
//                 make.edges.equalTo(scrollView);
//                 make.width.equalTo(scrollView);
//             }];
//    } else {
//        brainholeArea.hidden = NO;
//        uploadSwitchArea.hidden = NO;
//        [container mas_remakeConstraints:^(MASConstraintMaker *make) {
//                     make.edges.equalTo(scrollView);
//                     make.width.equalTo(scrollView);
//                 }];
    }
//
//
//
//    [self.view setNeedsUpdateConstraints];
}

/* 更新上传OSS状态一栏 */
- (void)setUploadStatus:(UploadOSSStatus)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == uploadingOSS) {
            self->uploadStatus.hidden = NO;
            self->uploadStatus.text = UpLoading;
            self->deleteButton.hidden = NO;
            self->deleteButton.enabled = NO;  //选择完成自动上传，删除按钮显示，禁止点击
        } else if (status == uploadOSSFinish){
            self->uploadStatus.hidden = NO;
            self->uploadStatus.text = UpLoadFinish;
            self->deleteButton.hidden = NO;
            self->deleteButton.enabled = YES;  //上传完成，删除按钮显示，允许点击
        } else {
            self->uploadStatus.hidden = YES;
            self->deleteButton.hidden = YES;
        }
    });
}




/* 选择视频后更新视频状态 */
- (void)updateUploadView:(id)data selectVideo:(BOOL)select {
    WeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        if (select) {
             //相册里选择视频
             [self setUploadStatus:uploadingOSS];  //显示上传状态和删除按钮
             NSDictionary *dic = (NSDictionary *)data;
             NSURL *url = dic[@"url"];  //视频路径
             self.firstFrame = dic[@"image"];
             self.videoDuration = dic[@"duration"];
             weakSelf.uploadImageView.image = dic[@"image"];
             self.videoData = [NSData dataWithContentsOfURL:url];
         } else {
             //删除视频
             self.videoUrl = nil;  //阿里云视频地址
             self.firstFrame = nil;  //视频第一帧
             self.videoDuration = nil;

             weakSelf.uploadImageView.image = [UIImage imageNamed:@"icon_video_default"];  //默认图片
         }
    });

    [self updateVideoAreaConstraints];
}

#pragma mark -- 监听状态  --

/* 监听开关状态 */
- (void)switchChange:(StarSwitch*)sender {
    if([sender isOn]) {
        if (sender.tag == 99) {
            self.textOriginal = 0;  //脑洞文本原创
            [self hiddenSourceView:sender needsUpdateConstraints:YES];
        } else if (sender.tag == 100) {
            [self hiddenVideoArea:NO];  //显示视频区
        } else {
            self.videoOriginal = 0;  //视频原创
            [self hiddenSourceView:sender needsUpdateConstraints:YES];
        }
    } else {
        if (sender.tag == 99) {
            self.textOriginal = 1;
            [self hiddenSourceView:sender needsUpdateConstraints:YES];
        } else if (sender.tag == 100) {
            [self hiddenVideoArea:YES];  //隐藏视频区
        } else {
            self.videoOriginal = 1;
            [self hiddenSourceView:sender needsUpdateConstraints:YES];
        }
    }
    [self checkTextFieldValue];  //再次校验
}

/* 监听滑动状态 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkTextFieldValue];
}

#pragma mark --  点击事件  --

/* 编辑脑洞 */
- (void)editBrainholeText {
    EditBrainholeTextViewController *vc = [[EditBrainholeTextViewController alloc] init];
//    vc.brainholeText = self.brainholeText;  //暂不修改
    vc.brainholeBlock = ^(NSString *brainholeText) {
        UIImage *image = [UIImage imageNamed:@""];  //暂定
        [self initTextView:brainholeText photo:image];  //富文本直接加载显示
        self.brainholeText = brainholeText;
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/* 添加视频 */
- (void)selectFromPhotoAlbum {
    if (self.firstFrame) {
        //提示只能选一个视频
        return;
    }
    WeakSelf
    NSString *type = @"video";
    [[[PhotoAlbumTools alloc] init] openPhotoAlbum:YES mediaType:type callback:^(id  _Nonnull data) {
        [weakSelf updateUploadView:data selectVideo:YES];  //更新上传状态
        [weakSelf uploadVideoToOSS:data];  //自动上传OSS
    }];
}

/* 视频上传至阿里云 */
- (void)uploadVideoToOSS:(NSData *)data {
    NSDictionary *dic = (NSDictionary *)data;
    NSURL *url = dic[@"url"];  //视频路径
    NSData *videoData = [NSData dataWithContentsOfURL:url];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        self.ossManager = [[OSSManager alloc] init];
        [self setUploadStatus:uploadingOSS];  //上传中
        [self.ossManager uploadVideo:videoData success:^(id  _Nullable response) {
            BOOL status = (BOOL)response[@"success"];
            if (status) {
                self.videoUrl = response[@"url"];
                [self setUploadStatus:uploadOSSFinish];  //上传完成
            } else {
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
                [SVProgressHUD dismiss];
            }
        
        } failure:^(NSError * _Nonnull error) {
             [SVProgressHUD showErrorWithStatus:@"上传失败"];
             [SVProgressHUD dismiss];
        }];
    });
}

/* 删除阿里云视频 */
- (void)deleteVideoAction {
    WeakSelf
    MotherPlanetAlertView *alertView = [[MotherPlanetAlertView alloc] init:@"删除视频" message:@"确定删除视频？" ok:@"确定" cancel:@"取消"];
        alertView.canRemove = YES;
        alertView.okBlock = ^(){
            [weakSelf deleteVideoFromOSS];
    };
}

/* 删除阿里云视频 */
- (void)deleteVideoFromOSS {
    WeakSelf
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       [self.ossManager deleteOSSFile:^(id  _Nullable response) {
             BOOL result = (BOOL)response;
             if (result) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self setUploadStatus:uploadOSSNone];
                     [weakSelf updateUploadView:nil selectVideo:NO];  //默认状态
                 });

             } else {
                 [SVProgressHUD showErrorWithStatus:@"删除失败"];
                 [SVProgressHUD dismiss];
             }
           } failure:^(NSError * _Nonnull error) {
       }];
    });
}

#pragma mark -- 解析HTML  --

- (NSArray *)filterImageUrlFromHTML:(NSString *)html {
    NSMutableArray *srcArray = @[].mutableCopy;
    NSString *srcUrl = @"";
    
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];

    TFHpple *htmls = [[TFHpple alloc] initWithHTMLData:htmlData];

    NSArray *dataArray = [htmls searchWithXPathQuery:@"//img"] ;

     
    for (TFHppleElement * element in dataArray) {
         NSString *srcUrl = [element objectForKey:@"src"];
         [srcArray addObject:srcUrl];
    }

    return srcArray;
}


#pragma mark --  脑洞文本 --

- (void)initTextView:(NSString *)text photo:(UIImage *)image {
//    if (image) {
//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(brainContent.frame.origin.x
//                                                                       + brainContent.frame.size.width - 100, 60, 100, 100)];
//        imageView.layer.cornerRadius = 5;
//        imageView.layer.masksToBounds = YES;
//
//        imageView.image = image;
//        [brainContent addSubview:imageView];
//        UIBezierPath *path = [self translatedBezierPath];
//        textView.textContainer.exclusionPaths = @[path];
//    }
    
//      NSString *htmlString = @"<h1>Header</h1><h2>Subheader</h2><p>Some <em>text</em></p><img src='https://motherplanet--test.oss-cn-beijing.aliyuncs.com/image/iOS_1578587430088.jpg' width=300 height=200 />";
        //text含有标签
//
//    NSArray *urlArray = [self filterImageUrlFromHTML:text];
//    NSString *url = @"";
//    if (urlArray && urlArray.count > 0) {
//        url = urlArray[0];
//    }
    
    
    brainContent.showsVerticalScrollIndicator = NO;
    
//    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(brainContent.frame.origin.x
//                                                                   + brainContent.frame.size.width - 100, 60, 100, 100)];
//    imageView.layer.cornerRadius = 5;
//    imageView.layer.masksToBounds = YES;
//
////    imageView.image = image;
//    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
//
//    [brainContent addSubview:imageView];
//
//    UIBezierPath *path = [self translatedBezierPath];
//    textView.textContainer.exclusionPaths = @[path];
    
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
//    brainContent.attributedText = attributedString;

    brainContent.attributedText = [self showAttributedToHtml:text withWidth:SCREENWIDTH - 32];
    
    [self.view setNeedsUpdateConstraints];  //更新布局
}

#pragma mark -- 图片自适应文本 --

- (NSAttributedString *)showAttributedToHtml:(NSString *)html withWidth:(float)width {
    //替换图片的高度为屏幕的高度
    //width为UITextView的宽度
    
    NSString *str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",width,html];
        
    NSAttributedString *attributeString=[[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    return attributeString;
}

- (UIBezierPath *)translatedBezierPath {
    CGRect imageRect = [textView convertRect:imageView.frame fromView:textView];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(imageRect.origin.x+5, imageRect.origin.y, imageRect.size.width-5, imageRect.size.height-5)];
    return bezierPath;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {//触摸事件中的触摸结束时会调用
    if (![titleContent isExclusiveTouch]) {//判断点击是否在textfield和键盘以外
        [titleContent resignFirstResponder];//收起键盘
    }
}

#pragma mark --  脑洞视频 --



#pragma mark  -- 发布--

- (void)submit {
    [self checkTextFieldValue];  //校验
    if (self.isUploadVideo) {
          if (!self.videoUrl) {
              [SVProgressHUD showErrorWithStatus:@"请添加视频"];
              [SVProgressHUD dismissWithDelay:1.2];
              return;
          } else if (vTitleContent.text.length == 0 ) {
              [SVProgressHUD showErrorWithStatus:@"请输入脑洞标题"];
              [SVProgressHUD dismissWithDelay:1.2];
              return;
          }
        
    } else {
        if (uploadSwitch.isOn) {
               if (!self.videoUrl) {
                   [SVProgressHUD showErrorWithStatus:@"请添加视频"];
                   [SVProgressHUD dismissWithDelay:1.2];
                   return;
               } else if (brainContent.text.length == 0) {
                   [SVProgressHUD showErrorWithStatus:@"请编辑脑洞内容"];
                   [SVProgressHUD dismissWithDelay:1.2];
                   return;
               } else if (vTitleContent.text.length == 0) {
                   [SVProgressHUD showErrorWithStatus:@"请输入脑洞标题"];
                   [SVProgressHUD dismissWithDelay:1.2];
                   return;
               }
           } else {
                 if (brainContent.text.length == 0) {
                   [SVProgressHUD showErrorWithStatus:@"请编辑脑洞内容"];
                   [SVProgressHUD dismissWithDelay:1.2];
                   return;
                 }
             }
    }
    
    if (self.isUploadVideo) {
        [self uploadVideo];
    } else {
        [self postBrainhole];
    }
}

/* 发布脑洞 */
- (void)postBrainhole {
    [self enableSubmit:NO];  //禁止连续点击
    NSDictionary *param = @{};
    if (!uploadSwitch.isOn) {
        param = [self setDefaultValue:0];
    } else {
        param = [self setDefaultValue:1];
    }
    
    NSString *token = [AppCacheManager sharedSession].token;
    [SVProgressHUD showWithStatus:@"正在提交..."];
    [RequestHandle postBrainhole:param authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
    
        if (self.isPush) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD dismissWithDelay:2.0 completion:^{
                ReleaseViewController *releaseVC = [[ReleaseViewController alloc] init];
                releaseVC.isPostBrainhole = YES;
                releaseVC.num = [NSString stringWithFormat:@"%li",[AppCacheManager sharedSession].getFuel];
                [self.navigationController pushViewController:releaseVC animated:YES];
            }];
        }
    } fail:^(NSError * _Nonnull error) {
        [self enableSubmit:YES];
    }];
}

/* 上传视频 - 脑洞 */
- (void)uploadVideo {
    NSDictionary *param = [self setDefaultValue:3];
    NSString *token = [AppCacheManager sharedSession].token;
    
    [SVProgressHUD showWithStatus:@"正在提交..."];
    [RequestHandle uploadVideo:param authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        [SVProgressHUD dismiss];

        NSInteger code = [response[@"code"] integerValue];
        if (code == 0) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [SVProgressHUD dismissWithDelay:2.0 completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    } fail:^(NSError * _Nonnull error) {
        
    }];
}

- (NSDictionary *)setDefaultValue:(NSInteger)type {
    NSDictionary *dic = @{};
    
    if (originalSwitch.isOn) {
        self.textOriginal = 0;
    } else {
        self.textOriginal = 1;
    }
    if (vOriginalSwitch.isOn) {
        self.videoOriginal = 0;
    } else {
        self.textOriginal = 1;
    }
    
    PostBrainholeModel *textModel = [[PostBrainholeModel alloc] init];

    if (type == 0) {
        //设置默认值为空值
       textModel.issueTitle = titleContent.text;
       textModel.issueContent = self.brainholeText;
       textModel.issueOriginal = self.textOriginal;
       textModel.issueSource = sourceContent.text;
       textModel.issueStar = self.starId;
       textModel.issueTag = tagContent.text;
       textModel.issueVideoDescribe = @"";
       textModel.issueVideoOriginal = self.videoOriginal;
       textModel.issueVideoSource = @"";
       textModel.issueVideoTag = @"";
       textModel.issueVideoTitle = @"";
       textModel.painTing = @"";
       textModel.videoDuration = @"";
    } else if (type == 1) {
        textModel.issueTitle = titleContent.text;
        textModel.issueContent = self.brainholeText;
        textModel.issueOriginal = self.textOriginal;
        textModel.issueSource = sourceContent.text;
        textModel.issueStar = self.starId;
        textModel.issueTag = tagContent.text;
        textModel.issueVideoDescribe = descriptionContent.text;
        textModel.issueVideoOriginal = self.videoOriginal;
        textModel.issueVideoSource = vSourceContent.text;
        textModel.issueVideoTag = vTagContent.text;
        textModel.issueVideoTitle = vTitleContent.text;
        textModel.painTing = self.videoUrl;
        
    } else {
        textModel.issueTitle = titleContent.text;
        textModel.issueContent = self.brainholeText;
        textModel.issueOriginal = self.textOriginal;
        textModel.issueSource = sourceContent.text;
        textModel.issueStar = self.starId;
        textModel.issueTag = tagContent.text;
        textModel.issueVideoDescribe = descriptionContent.text;  //
        textModel.issueVideoOriginal = self.videoOriginal;  //
        textModel.issueVideoSource = vSourceContent.text;  //
        textModel.issueVideoTag = vTagContent.text;  //
        textModel.issueVideoTitle = vTitleContent.text;  //
        textModel.painTing = self.videoUrl;  //
        textModel.postId = self.brainholeId;
        textModel.videoDuration = self.videoDuration;
    }
    dic = textModel.mj_keyValues;

    return dic;
}

/* 允许提交 */
- (void)enableSubmit:(BOOL)enable {
    if (enable) {
        submit.userInteractionEnabled = YES;
        submit.enabled = YES;
        submit.backgroundColor = UICOLOR(@"#EFB400");
    } else {
        submit.userInteractionEnabled = NO;
        submit.enabled = NO;
        submit.backgroundColor = [UIColor grayColor];
    }
}

/* 提交数据校验 */
- (void)checkTextFieldValue {
    BOOL enable = NO;
    if (self.isUploadVideo) {
        if (self.videoUrl.length != 0 && vTitleContent.text.length != 0 ) {
            enable = YES;
        }
    } else {
        if (uploadSwitch.isOn) {
              if (self.videoUrl.length != 0 && brainContent.text.length != 0 && self.starId != 0 && vTitleContent.text.length != 0) {
                   enable = YES;
              }
        } else {
            if (brainContent.text.length != 0 && self.starId != 0) {
                enable = YES;
            }
        }
    }
    
    [self enableSubmit:enable];  //允许提交
 }


#pragma mark  -- 富文本 --

//标签 黑体14 细体14(选填)
- (NSMutableAttributedString *)setTitleToAttributedTextStyle1:(NSString *)subString1 subString2:(NSString *)subSting2 {
    NSArray *titleArray = @[
                             @{ @"string": subString1,
                                @"font": PingFangSC_Medium(14),
                                @"color": UICOLOR(@"#343338")
                              },
                             @{ @"string": subSting2,
                                @"font": PingFangSC_Light(14),
                                @"color": UICOLOR(@"#868686")
                              }
                           ];
    return [@"" setMutliString:titleArray];
}

//标签 黑体14号
- (NSMutableAttributedString *)setTitleToAttributedTextStyle2:(NSString *)subString {
  NSMutableAttributedString *attString = [subString setStringToAttributedString:subString         font:PingFangSC_Medium(14) color:UICOLOR(@"#343338")];
    return attString;
}

//标签 简体12号
- (NSMutableAttributedString *)setTitleToAttributedTextStyle3:(NSString *)subString {
    NSMutableAttributedString *attString = [subString setStringToAttributedString:subString         font:PingFangSC_Regular(12) color:UICOLOR(@"#868686")];
      return attString;
}

//- (NSString *)setPlacehold:(NSString *)placehold {
//    NSString *string = placehold;
//
//}

//标签 简体10号
- (NSMutableAttributedString *)setTitleToAttributedTextStyle4:(NSString *)subString {
    NSMutableAttributedString *attString = [subString setStringToAttributedString:subString         font:PingFangSC_Regular(10) color:UICOLOR(@"#868686")];
      return attString;
}


@end
