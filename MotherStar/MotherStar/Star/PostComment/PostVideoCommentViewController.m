//
//  PostVideoCommentViewController.m
//  MotherStar
//
//  Created by yanming niu on 2020/1/9.
//  Copyright © 2020 yanming niu. All rights reserved.
//


#import "PostVideoCommentViewController.h"
//#import <YYImage/YYImage.h>
#import <YYText/YYText.h>
#import <yytext/YYTextEffectWindow.h>
#import "TZImagePickerController.h"
#import "CustomYYImage.h"
#import "UIColor+LCColor.h"
#import "ImageModel.h"

#define  imageWidth 60
#define  betweenWidth 10.0
#define  width_20 20.0
#define num_280 280
#define SIZE [UIScreen mainScreen].bounds.size
typedef void(^OSSAccessBlock)(OSSModel *model, BOOL success);

typedef void(^UploadSuccess)(NSString *);


@interface PostVideoCommentViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate,YYTextViewDelegate> {
    NSMutableAttributedString *text;
    NSInteger keyBoardHeight;
    UIView *_toolView;
    
    UIView *scoreArea;  //评分视图
    UIView *pentagramView;  //五角星列表
    
    
    UIView *scoreTypeView;
    UIButton *plusButton;
    UIButton *minusButton;
    UILabel *scoreL;
    
    UIView *commentView;
    
}

@property (nonatomic, strong) UIBarButtonItem *postButton;

@property (strong, nonatomic) YYTextView *textView;
@property (nonatomic, assign) NSRange textViewRange;
@property(nonatomic,copy) NSString *tipStr;
@property (nonatomic, strong) OSSManager *ossManager;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) NSString *brainholeCommentText;  //html文本

@property (nonatomic, assign) double score;  //评分
@property (nonatomic, assign) NSInteger scoreType;  //正分  负分
@property (nonatomic, strong) NSMutableArray *scoreArray;  //视频评分值


@end

@implementation PostVideoCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.gk_navigationItem.title = @"评论";
    self.gk_navRightBarButtonItem = self.postButton;

    self.brainholeCommentText = @"";
    
    self.imageUrl = @"";

    
    [self creatUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)backAction {
    if (self.textView.text.length > 0) {
        MotherPlanetAlertView *alertView = [[MotherPlanetAlertView alloc] init:@"退出编辑" message:@"已填写内容将被删除" ok:@"退出" cancel:@"留下"];
        alertView.canRemove = YES;
        alertView.okBlock = ^(){
          [self.navigationController popViewControllerAnimated:YES];
        };
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark  -- 事件 --

- (UIBarButtonItem *)postButton {
    if (!_postButton) {
        UIButton *save = [UIButton new];
        save.frame = CGRectMake(0, 0, 36, 18);
        save.titleLabel.font = PingFangSC_Medium(18);
        [save setTitle:@"发布" forState:UIControlStateNormal];
        [save setTitleColor:UICOLOR(@"#EFB400") forState:UIControlStateNormal];
        [save addTarget:self action:@selector(postBrainholeComment) forControlEvents:UIControlEventTouchUpInside];
        _postButton = [[UIBarButtonItem alloc] initWithCustomView:save];
    }
    return _postButton;
}


/* 绘制圆角 */
- (UIButton *)drawRoundLayer:(UIButton *)button {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(button.bounds.size.width / 2, button.bounds.size.height / 2)];
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    button.layer.mask = shape;
    return button;
}

/*  保存并发布 */


#pragma mark -- 评分部分 --

- (void)updateScoreTypeStatus:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 10) {
        if (sender.selected) {
            plusButton.selected = YES;
            minusButton.selected = NO;
            self.scoreType = 0;  //正分
        }
    } else {
        if (sender.selected) {
            self.scoreType = 1;  //负分
            minusButton.selected = YES;
            plusButton.selected = NO;
        }
    }
    
    if (plusButton.selected) {
        minusButton.selected = NO;

        for (NSInteger i = 0; i < _scoreArray.count; i++) {
            UIImageView *pentagramImage = self.scoreArray[i];
            if (i < (NSInteger)self.score) {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_plus"];
            }
            [_scoreArray replaceObjectAtIndex:i withObject:pentagramImage];
        }
    } else {
        plusButton.selected = NO;

        for (NSInteger i = 0; i < _scoreArray.count; i++) {
            UIImageView *pentagramImage = self.scoreArray[i];
            if (i < (NSInteger)self.score) {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_minus"];
            }
            [_scoreArray replaceObjectAtIndex:i withObject:pentagramImage];
        }
    }
    
    [self updateScoreValue];
}

/* 更改分值 */
- (void)updateScoreValue {
      if (self.scoreType == 0) {
          scoreL.text = [NSString stringWithFormat:@"+%@",[@(self.score) stringValue]];
      } else {
          scoreL.text = [NSString stringWithFormat:@"-%@",[@(self.score) stringValue]];
      }
}

- (BOOL)isPlusScoreType {
    BOOL is = NO;
    if (plusButton.selected) {
        is = YES;
    }
    return is;
}

/* 更改星星颜色 */
- (void)changeScore:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    
    for (int i = 0; i < self.scoreArray.count; i ++) {
        UIImageView *pentagramImage = self.scoreArray[i];

        if ([self isPlusScoreType]) {
             if (i <= imageView.tag - 10) {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_plus"];
             } else {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_default"];
             }
            [_scoreArray replaceObjectAtIndex:i withObject:pentagramImage];
            self.score = (double)imageView.tag + 1 - 10;  //分数
            [self updateScoreValue];

        } else {
            if (i <= imageView.tag - 10) {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_minus"];
            } else {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_default"];
            }
            [_scoreArray replaceObjectAtIndex:i withObject:pentagramImage];
            self.score = (double)imageView.tag + 1 - 10;  //分数
            [self updateScoreValue];
        }

    }
}

/* 初始化星星 */
- (NSMutableArray *)scoreArray {
    if (!_scoreArray) {
        _scoreArray = [NSMutableArray array];
        for (int i = 0; i < 5; i ++) {
            UIImageView *pentagramImage = [[UIImageView alloc] initWithFrame:CGRectZero];
            pentagramImage.tag = i + 10;
            pentagramImage.userInteractionEnabled = YES;
            pentagramImage.image = [UIImage imageNamed:@"pentagram_default"];  //默认
            [pentagramView addSubview:pentagramImage];  //放入五角星
            [_scoreArray addObject:pentagramImage];
            UITapGestureRecognizer *select = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeScore:)];
            [pentagramImage addGestureRecognizer:select];
        }
    }
    return _scoreArray;
}

/* 评分五角星排列 */
- (void)test_masonry_horizontal_fixSpace {
    // 实现masonry水平固定间隔方法
    [self.scoreArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:11.5 leadSpacing:0 tailSpacing:0];

    // 设置array的垂直方向的约束
    [self.scoreArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pentagramView).offset(0);
        make.height.mas_equalTo(29);
    }];
}

#pragma mark -- 主视图 --

-(void)creatUI {
    //评分
    scoreArea = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:scoreArea];

    //正负分
    scoreTypeView = [[UIView alloc] initWithFrame:CGRectZero];
    [scoreArea addSubview:scoreTypeView];

    //正分
    self.scoreType = 0;

    plusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 14)];
    [scoreTypeView addSubview:plusButton];
    plusButton.tag = 10;

    plusButton.titleLabel.font = PingFangSC_Regular(14);
    [plusButton setTitleColor:UICOLOR(@"#868686") forState:UIControlStateNormal];
    [plusButton setTitleColor:UICOLOR(@"#EFB400") forState:UIControlStateSelected];
    [plusButton setTitle:@"正分" forState:UIControlStateNormal];
    [plusButton setTitle:@"正分" forState:UIControlStateSelected];

    //默认正分
    plusButton.selected = YES;
    SEL aciton = @selector(updateScoreTypeStatus:);
    [plusButton setImage:[UIImage imageNamed:@"unSelected_scoreType"] forState:UIControlStateNormal];
    [plusButton setImage:[UIImage imageNamed:@"selected_score_plus"] forState:UIControlStateSelected];
    [plusButton SG_imagePositionStyle:SGImagePositionStyleLeft spacing:4.0];
    [plusButton addTarget:self action:aciton forControlEvents:UIControlEventTouchUpInside];
    
//    [self updateScoreTypeStatus:plusButton];


     //负分
    minusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 14)];
    [scoreTypeView addSubview:minusButton];
    
    minusButton.tag = 20;
    minusButton.selected = NO;
    minusButton.titleLabel.font = PingFangSC_Regular(14);

    [minusButton setTitleColor:UICOLOR(@"#343338") forState:UIControlStateNormal];
    [minusButton setTitleColor:UICOLOR(@"#343338") forState:UIControlStateSelected];

    [minusButton setTitle:@"负分" forState:UIControlStateNormal];
    [minusButton setTitle:@"负分" forState:UIControlStateSelected];

    [minusButton setImage:[UIImage imageNamed:@"unSelected_scoreType"] forState:UIControlStateNormal];
    [minusButton setImage:[UIImage imageNamed:@"selected_score_minus"] forState:UIControlStateSelected];
    [minusButton SG_imagePositionStyle:SGImagePositionStyleLeft spacing:4.0];
    [minusButton addTarget:self action:aciton forControlEvents:UIControlEventTouchUpInside];
//    [self updateScoreTypeStatus:minusButton];

    //分值
    scoreL = [[UILabel alloc] initWithFrame:CGRectZero];
    self.score = 0;  //默认
    scoreL.text = @"0";
    scoreL.textAlignment = NSTextAlignmentCenter;
    scoreL.font = PingFangSC_Regular(12);
    scoreL.textColor = UICOLOR(@"#868686");
    [scoreArea addSubview:scoreL];
    
    //星星列表
    pentagramView = [[UIView alloc] initWithFrame:CGRectZero];
    [self test_masonry_horizontal_fixSpace];
    [scoreArea addSubview:pentagramView];
    
    
//    scoreArea.backgroundColor = [UIColor orangeColor];
    
   
    
    //移除放大镜 无效
    [[YYTextEffectWindow sharedWindow].subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //评论内容
    commentView = [[UIView alloc] init];
    [self.view addSubview:commentView];
    
    
    self.textView = [[YYTextView alloc] init];
    [commentView addSubview:self.textView];
    _textView.backgroundColor = UICOLOR(@"#F6F6F6");

    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.userInteractionEnabled = YES;
    self.textView.textVerticalAlignment = YYTextVerticalAlignmentTop;
    self.textView.attributedText = text;
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.placeholderFont = [UIFont systemFontOfSize:16];
    self.textView.placeholderText = @"写几句评价吧";
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 0);
     
    self.textView.delegate = self;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    //键盘上方加三个按钮
    _toolView  = [[UIView alloc]init];
    _toolView.backgroundColor = [UIColor whiteColor];
    _toolView.frame = CGRectMake(0, SIZE.height - 40, SIZE.width, 40);
    [self.view addSubview:_toolView];

    UIView*lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE.width, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"9B9B9B"];
    [_toolView addSubview:lineView1];

    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setImage:[UIImage imageNamed:@"brainhole_addPhoto"] forState:UIControlStateNormal];
    imageBtn.frame = CGRectMake(10, 0, 47, 40);
    [imageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(imageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:imageBtn];


    UIButton * finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setTitleColor:[UIColor colorWithHexString:@"1ABF9A"] forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    finishButton.frame = CGRectMake(SIZE.width-50, 0, 47, 40);
    [finishButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:finishButton];
}

#pragma mark  -- 布局 --

- (void)updateViewConstraints {
      [scoreArea mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.view).mas_offset(StatusAndNaviHeight);
             make.left.right.mas_offset(0);
             make.bottom.equalTo(pentagramView).mas_offset(0);
         }];
        
         [scoreTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_offset(15.5);
             make.centerX.equalTo(scoreArea);
             make.width.mas_equalTo(118);
             make.height.mas_equalTo(14);
         }];
        
        [plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.mas_offset(0);
               make.left.mas_offset(0);
               make.width.mas_equalTo(50);
               make.height.mas_equalTo(14);
           }];
        
        [minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.mas_offset(0);
               make.right.mas_offset(0);
               make.width.mas_equalTo(50);
               make.height.mas_equalTo(14);
           }];
        
        [scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(scoreTypeView.mas_bottom).mas_offset(10);
            make.centerX.equalTo(scoreArea);
            make.width.mas_equalTo(18);
            make.height.mas_equalTo(12);
        }];
        
        [pentagramView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(scoreL.mas_bottom).mas_offset(10);
            make.centerX.equalTo(scoreArea);
            make.width.mas_equalTo(191);
            make.height.mas_equalTo(29);
    //        make.bottom.mas_offset(0);
        }];
    
    
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(160);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(194);
//        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.edges.equalTo(commentView);
        make.top.mas_offset(-20);
        make.left.right.bottom.mas_offset(0);
    }];
    
    [super updateViewConstraints];
}



#pragma mark  -- 保存评论 --

/* 保存并发布 */
-(void)postBrainholeComment {
    //获取编辑内容
    NSMutableArray *postArray = [[self p_trimIsMove:NO] mutableCopy];
    for (int i = 0; i < postArray.count; i++) {
        if ([postArray[i] isKindOfClass:[ImageModel class]]) {
            ImageModel *model = postArray[i];
            NSString *imageStr = [NSString stringWithFormat:@"<img src=\"%@\">", model.abbrUrl];
            postArray[i] = imageStr;  //替换成标签内容 - 图片url
        }
//        else {
//            NSString *text = postArray[i];
//            NSString *textHtml = [NSString stringWithFormat:@"<p>%@</p>", text];
//            postArray[i] = textHtml;  //替换成标签内容 - 文本
//        }
    }
    NSMutableString *postString = [NSMutableString new];
    for (int i = 0; i < postArray.count; i++) {
        if (i == 0) {
            [postString appendString:postArray[i]];
        } else {
            [postString appendFormat:@"\n%@", postArray[i]];
        }
    }
    self.brainholeCommentText = postString.mutableCopy;  //带html标签
    
//    CustomYYImage *imageView = _textView.textLayout.attachments[0].content;  //可以取到imageView.image
    
    [self.view endEditing:YES];

    [self postVideoBrainholeText];  //提交
}

#pragma mark  -- 发布评论 --

/* 发布 */
- (void)postVideoBrainholeText {
    //禁止连续点击
    self.postButton.enabled = NO;
       
    NSString *token = [AppCacheManager sharedSession].token;
    if (!token) {
      [SVProgressHUD showInfoWithStatus:@"非注册用户无法评论"];
      [SVProgressHUD dismissWithDelay:1.0 completion:^{
          [self.navigationController popViewControllerAnimated:YES];
          return;
      }];
    }
    
    if (self.brainholeCommentText.length == 0) {
        if (self.score == 0) {
            [SVProgressHUD showInfoWithStatus:@"还什么都没有写呢"];
            [SVProgressHUD dismissWithDelay:1.2];
            return;
        }
    }
 
    NSDictionary *param = @{
                             @"aType": @(self.scoreType),
                             @"picUrl": self.imageUrl,
                             @"videoId": @(self.brainholeVideoId),
                             @"score": @(self.score),
                             @"title": self.brainholeCommentText
                           };
    
    [SVProgressHUD showWithStatus:@"正在发布..."];
    [RequestHandle postBrainholeComment:param authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [SVProgressHUD dismissWithDelay:2.0 completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } fail:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        self.postButton.enabled = YES;  //发布失败允许点击
    }];
}

#pragma mark -- 富文本编辑 --

/* 上传图片到OSS */
- (void)uploadPhotoToOSS:(UploadSuccess)success {
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        self.ossManager = [[OSSManager alloc] init];
    
        if (!self.originalImage) {
            return;
        }
        [self.ossManager uploadImage:self.originalImage success:^(id  _Nullable response) {
            BOOL status = (BOOL)response[@"success"];
            if (status) {
                self.imageUrl = response[@"url"];
                success(self.imageUrl);
            } else {
                [MyProgressHUD showErrorWithStatus:@"保存失败, 请重新选择图片" duration:1.0];
                success(nil);
            }
        } failure:^(NSError * _Nonnull error) {
            [MyProgressHUD showErrorWithStatus:@"保存失败, 请重新选择图片" duration:1.0];
            success(nil);

        }];
    });
}

/* 相册 */
-(void)imageBtnClick {
    _textViewRange = _textView.selectedRange;
    TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - TZImage Picker Controller Delegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    WeakSelf
    
    _textViewRange = _textView.selectedRange;
    __block NSMutableAttributedString *contentText = [_textView.attributedText mutableCopy];
      __block  UIImage *image = photos[0];
        self.originalImage = image;  //保存原图文件
        
        //上传OSS得到的Url

        [self uploadPhotoToOSS:^(NSString *url) {
            if (!url) {
                return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    

                CustomYYImage *imageView = [[CustomYYImage alloc] initWithDataSourece:self];
                     
                     imageView.imageW = image.size.width;
                     imageView.imageH = image.size.height;
                     
                     float scale = (SIZE.width-30)/image.size.width;
                     image = [self imageByScalingAndCroppingForSize:CGSizeMake(SIZE.width-30, image.size.height*scale) forImage:image];
                     imageView.image = image;
                     imageView.urlStr =  self.imageUrl;
                     imageView.location = weakSelf.textViewRange.location +  0 * 2 + 1;
                     contentText = [[self p_textViewAttributedText:imageView contentText:contentText index:weakSelf.textViewRange.location originPoint:[weakSelf.textView caretRectForPosition:weakSelf.textView.selectedTextRange.start].origin isData:NO] mutableCopy];
                     
                     [contentText insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:weakSelf.textViewRange.location + 1 * 2];
                 
                 //    [contentText insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:_textViewRange.location + photos.count * 2];
                 
                 [contentText setYy_font:[UIFont systemFontOfSize:16]];
                 contentText.yy_lineSpacing = 15;
                
                
                
                 weakSelf.textView.attributedText = contentText;
                 self.textView.selectedRange = NSMakeRange(contentText.length, 0);
            
            });

        }];

     
}


#pragma mark 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyBoardHeight = keyboardRect.size.height;
    [UIView animateWithDuration:0.1 animations:^{
        self->_textView.frame = CGRectMake(15, 64, SIZE.width-30, SIZE.height-64-self->keyBoardHeight-40-10-15);
        self->_toolView.frame = CGRectMake(0, SIZE.height-self->keyBoardHeight-40, SIZE.width, 40);
    }];
    
}

#pragma mark 当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.1 animations:^{
        self->_textView.frame = CGRectMake(15, 64, SIZE.width-30, SIZE.height-64-10);
        _toolView.frame = CGRectMake(0, SIZE.height+40, SIZE.width, 40);
    }];
}
- (BOOL)textView:(YYTextView *)textView shouldTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange
{
    return YES;
}
- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect
{
    //    if ([self.clickDelegate respondsToSelector:@selector(label:tapHighlight:inRange:)])
    //    {
    //        YYTextHighlight *highlight = [textView.attributedText yy_attribute:YYTextHighlightAttributeName atIndex:characterRange.location];
    //        [self.clickDelegate label:textView tapHighlight:highlight inRange:characterRange];
    //    }
}
- (BOOL)textView:(YYTextView *)textView shouldLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange
{
    
    return YES;
}
- (void)textView:(YYTextView *)textView didLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect
{
    
}

#pragma mark - YYTextView Get Attributed String
- (NSAttributedString *)p_textViewAttributedText:(id)attribute contentText:(NSAttributedString *)attributeString index:(NSInteger)index originPoint:(CGPoint)originPoint isData:(BOOL)isData {
    NSMutableAttributedString *contentText = [attributeString mutableCopy];
    NSAttributedString *textAttachmentString = [[NSAttributedString alloc] initWithString:@"\n"];
    if ([attribute isKindOfClass:[CustomYYImage class]]) {
        CustomYYImage *imageView = (CustomYYImage *)attribute;
        CGFloat imageViewHeight = ![imageView.title isEqualToString:@""] ? SIZE.width + 30.0 : SIZE.width;
        float scale = (SIZE.width-30)/imageView.imageW;
        imageView.frame = CGRectMake(originPoint.x, originPoint.y, SIZE.width-30, imageView.imageH*scale);
        //        imageView.frame = CGRectMake(originPoint.x, originPoint.y, SIZE.width-30, 200);
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:_textView.font alignment:YYTextVerticalAlignmentCenter];
        if (!isData) [contentText insertAttributedString:textAttachmentString atIndex:index++];
        [contentText insertAttributedString:attachText atIndex:index++];
        
        
    }
    return contentText;
}
//图片伸缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize forImage:(UIImage *)originImage
{
    UIImage *sourceImage = originImage;// 原图
    UIImage *newImage = nil;// 新图
    // 原图尺寸
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;// 目标宽度
    CGFloat targetHeight = targetSize.height;// 目标高度
    // 伸缩参数初始化
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {// 如果原尺寸与目标尺寸不同才执行
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // 根据宽度伸缩
        else
            scaleFactor = heightFactor; // 根据高度伸缩
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // 定位图片的中心点
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // 创建基于位图的上下文
    UIGraphicsBeginImageContext(targetSize);
    
    // 目标尺寸
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    // 新图片
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    // 退出位图上下文
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 修剪

- (NSArray *)p_trimIsMove:(BOOL)isMove {
    NSInteger currentIndex = 0;
    NSString *dataString = _textView.attributedText.string;
    NSMutableArray *data = [[dataString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
    NSMutableArray *result = [NSMutableArray new];
    for (int i = 0; i < data.count; i++) {
        BOOL isChangedIndex = NO;
        int attachmentIndex = 0;
        for (int j = attachmentIndex; j < _textView.textLayout.attachmentRanges.count; j++) {
            if ([_textView.textLayout.attachmentRanges[j] rangeValue].location == currentIndex) {
                if ([_textView.textLayout.attachments[j].content isKindOfClass:[CustomYYImage class]])
                {
                    CustomYYImage *imageView = _textView.textLayout.attachments[j].content;
                    if (!isChangedIndex) {
                        if (isMove) {
                            [result addObject:imageView];
                        } else {
                            ImageModel *model = [ImageModel new];
                            model.image = imageView.image;
                            model.abbrUrl = imageView.urlStr;
                            if (imageView.title) model.title = imageView.title;
                            [result addObject:model];
                        }
                        currentIndex += 2;
                        isChangedIndex = YES;
                        attachmentIndex ++;
                    }
                }
            }
        }
        if (!isChangedIndex) {
            NSString *string = data[i];
            currentIndex += string.length + 1;
            if (![string isEqualToString:@""]) {
                [result addObject:string];
            }
        }
    }
    return result;
}


#pragma mark 弹下
-(void)btnClick {
    [self.view endEditing:YES];
}


@end
