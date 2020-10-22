//
//  EditBrainholeTextViewController.m
//  MotherStar
//
//  Created by yanming niu on 2020/1/9.
//  Copyright © 2020 yanming niu. All rights reserved.
//


#import "EditBrainholeTextViewController.h"
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


@interface EditBrainholeTextViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate,YYTextViewDelegate>
{
    NSMutableAttributedString *text;
    NSInteger keyBoardHeight;
    UIView *_toolView;
}
@property (nonatomic, strong) UIBarButtonItem *saveButton;

@property (strong, nonatomic) YYTextView *textView;
@property (nonatomic, assign) NSRange textViewRange;
@property(nonatomic,copy) NSString *tipStr;
@property (nonatomic, strong) OSSManager *ossManager;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;

//@property (nonatomic, strong) NSString *brainholeText;  //html文本




@end

@implementation EditBrainholeTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.gk_navRightBarButtonItem = self.saveButton;
    self.imageUrlArray = @[].mutableCopy;

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

- (UIBarButtonItem *)saveButton {
    if (!_saveButton) {
        UIButton *save = [UIButton new];
        save.frame = CGRectMake(0, 0, 36, 18);
        save.titleLabel.font = PingFangSC_Medium(18);
        [save setTitle:@"保存" forState:UIControlStateNormal];
        [save setTitleColor:UICOLOR(@"#343338") forState:UIControlStateNormal];
        [save addTarget:self action:@selector(saveBrainholeText) forControlEvents:UIControlEventTouchUpInside];
        _saveButton = [[UIBarButtonItem alloc] initWithCustomView:save];
    }
    return _saveButton;
}

-(void)creatUI {
    //移除放大镜 无效
    [[YYTextEffectWindow sharedWindow].subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.textView = [[YYTextView alloc] init];
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.userInteractionEnabled = YES;
    self.textView.textVerticalAlignment = YYTextVerticalAlignmentTop;
    self.textView.attributedText = text;
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.placeholderFont = [UIFont systemFontOfSize:16];
    self.textView.placeholderText = @"写出你的脑洞~";
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 0);
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(StatusAndNaviHeight);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    self.textView.delegate = self;
    
    self.textView.text = self.brainholeText;
    
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

#pragma mark  -- 保存脑洞 --

-(void)saveBrainholeText {
    //禁止连续点击
    self.saveButton.enabled = NO;
    
    //获取编辑内容
    NSInteger imgCount = 0;
    NSMutableArray *postArray = [[self p_trimIsMove:NO] mutableCopy];
    for (int i = 0; i < postArray.count; i++) {
        if ([postArray[i] isKindOfClass:[ImageModel class]]) {
            imgCount++;
            ImageModel *model = postArray[i];
            NSString *imageStr = [NSString stringWithFormat:@"<img src=\"%@\">", model.abbrUrl];
            postArray[i] = imageStr;  //替换成标签内容 - 图片url
        } else {
            NSString *text = postArray[i];
            NSString *textHtml = [NSString stringWithFormat:@"<p>%@</p>", text];
            postArray[i] = textHtml;  //替换成标签内容 - 文本
        }
    }
    //图片限制
    if (imgCount > 9) {
        [MyProgressHUD showErrorWithStatus:@"最多插入9张图片" duration:1.2];
        return;
    }
    
    NSMutableString *postString = [NSMutableString new];
    for (int i = 0; i < postArray.count; i++) {
        if (i == 0) {
            [postString appendString:postArray[i]];
        } else {
            [postString appendFormat:@"\n%@", postArray[i]];
        }
    }
    self.brainholeText = postString.mutableCopy;
//    CustomYYImage *imageView = _textView.textLayout.attachments[0].content;  //可以取到imageView.image
    
    [MyProgressHUD showSuccessWithStatus:@"保存成功" duration:1.0];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.brainholeBlock(self.brainholeText);  //回传
        [self.navigationController popViewControllerAnimated:YES];
    });

    [self.view endEditing:YES];
}

/* 上传图片到OSS */
- (void)uploadPhotoToOSS:(UploadSuccess)success {
    [SVProgressHUD showWithStatus:@"正在插入图片..."];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        self.ossManager = [[OSSManager alloc] init];
    
        if (!self.originalImage) {
            return;
        }
        [self.ossManager uploadImage:self.originalImage success:^(id  _Nullable response) {
            [SVProgressHUD dismissWithDelay:1.0];
            BOOL status = (BOOL)response[@"success"];
            if (status) {
                self.imageUrl = response[@"url"];
                [self.imageUrlArray addObject:self.imageUrl];  //加入数组
                success(self.imageUrl);
            } else {
                [MyProgressHUD showErrorWithStatus:@"插入失败, 请重新选择图片" duration:1.0];
                success(nil);
            }
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD dismissWithDelay:0.2];
            [MyProgressHUD showErrorWithStatus:@"保存失败, 请重新选择图片" duration:1.0];
            success(nil);

        }];
    });
}

- (void)limitImageCount {
    
}

#pragma mark 相册
-(void)imageBtnClick {
    _textViewRange = _textView.selectedRange;
    TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    controller.allowPickingVideo = NO;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - TZImage Picker Controller Delegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    //图片限制
    if (self.imageUrlArray.count >= 9) {
        [MyProgressHUD showErrorWithStatus:@"最多插入9张图片" duration:1.2];
        return;
    }
    
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


/* 保存脑洞 */
//- (void)saveBrainholeText {
//    //    self.textBlock(self.textView.text, self.image);
//
//}

@end
