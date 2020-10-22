//
//  CommentImportView.m
//  MotherStar
//
//  Created by 胡志军 on 2020/2/15.
//  Copyright © 2020年 yanming niu. All rights reserved.
//

#import "CommentImportView.h"
#define rgba(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

#define  imageWidth 60
#define  betweenWidth 10.0
#define  width_20 20.0
#define num_280 280
#define SIZE [UIScreen mainScreen].bounds.size
typedef void(^OSSAccessBlock)(OSSModel *model, BOOL success);

typedef void(^UploadSuccess)(NSString *);

@interface CommentImportView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate,YYTextViewDelegate> {
    UIView *addBGView;  //添加图片背景视图
    UILabel *buttonTitle;
}

@end
@implementation CommentImportView

- (instancetype)init{
    if (self = [super init]) {
        self.maxLenght = 500;
        self.brainholeCommentText = @"";
        self.imageUrl = @"";

        [self setupUI];
        [self setupLayout];
//        [self.textView becomeFirstResponder];

    }
    return self;
}
- (void)setupUI{
    //移除放大镜 无效
//    [[YYTextEffectWindow sharedWindow].subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.backView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.backView];
    self.backView.backgroundColor = UICOLOR(@"#F6F6F6");
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;

    
    self.textView = [[YYTextView alloc] init];
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.userInteractionEnabled = YES;
    self.textView.textVerticalAlignment = YYTextVerticalAlignmentTop;
    self.textView.attributedText = self.text;
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.placeholderFont = [UIFont systemFontOfSize:16];
    self.textView.placeholderText = @"写出你的脑洞~";
    self.textView.textContainerInset = UIEdgeInsetsMake(0, 10, 10, 10);
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor clearColor];
    [self.backView addSubview:self.textView];

    self.lenghtLab = [[UILabel alloc] init];
    self.lenghtLab.text = @"0/500";
    self.lenghtLab.textColor = rgba(134, 134, 134, 1);
    self.lenghtLab.font = [UIFont systemFontOfSize:14];
    [self.backView addSubview:self.lenghtLab];
    
    //添加图片
    addBGView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:addBGView];
    addBGView.layer.borderWidth = 1;
    addBGView.layer.borderColor = UICOLOR(@"#868686").CGColor;

    buttonTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [addBGView addSubview:buttonTitle];
    
    buttonTitle.text = @"添加图片";
    buttonTitle.textColor = UICOLOR(@"#868686");
    buttonTitle.font = PingFangSC_Regular(10);
    
    self.addImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 17)];
    [addBGView addSubview:self.addImageBtn];
    
    [self.addImageBtn setEnlargeEdgeWithTop:15 right:20 bottom:35 left:20];
    [self.addImageBtn SG_imagePositionStyle:SGImagePositionStyleTop spacing:40];
    [self.addImageBtn setBackgroundImage:[UIImage imageNamed:@"brainhole_addPhoto"] forState:UIControlStateNormal];
    [self.addImageBtn addTarget:self action:@selector(addImageBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setupLayout{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 0;
        make.left.offset = 16;
        make.right.offset = -16;
        make.height.offset = 194;
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 10;//防止图片白色和背景冲突
        make.left.right.offset =0;
        make.bottom.offset = -20;
    }];
    [self.lenghtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -6;
        make.right.offset = -4;
        make.height.offset = 14;
    }];
    
    [addBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_bottom).offset = 10;
        make.left.mas_offset(16);
        make.width.height.offset = 64;
    }];

    [self.addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(21);
        make.right.mas_offset(-21);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(17);
    }];
    
    [buttonTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addImageBtn.mas_bottom).mas_offset(15);
        make.left.mas_offset(12);
        make.right.mas_offset(-12);
        make.height.mas_equalTo(10);
    }];
    
}
#pragma mark --代理方法
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView{
    return YES;
}

- (BOOL)textView:(YYTextView *)textView shouldTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange
{
    NSLog(@"%ld---%ld-----%ld",characterRange.length, characterRange.location,textView.text.length);
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
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //输入之后所有的字符是否超出了界限,能够检测出粘贴
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    if (str.length > self.maxLenght && ![text isEqualToString:@""]) {
//        textView.text = [str substringToIndex:self.AllInputNo];
                return NO;
    }
    return YES;
}
- (void)textViewDidChange:(YYTextView *)textView{
    NSString * str = [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.lenghtLab.text = [NSString stringWithFormat:@"%ld/%ld",str.length,self.maxLenght];

}
- (BOOL)textView:(YYTextView *)textView shouldLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange
{
    
    return YES;
}
- (void)textView:(YYTextView *)textView didLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endEditing:YES];
}
#pragma mark --SET
- (void)setMaxLenght:(NSInteger)maxLenght{
    _maxLenght = maxLenght;
    
    self.lenghtLab.text = [NSString stringWithFormat:@"0/%ld",maxLenght];
}
- (void)setAddImageBackGroundImageStr:(NSString *)addImageBackGroundImageStr{
    _addImageBackGroundImageStr = addImageBackGroundImageStr;
    
    [self.addImageBtn setBackgroundImage:[UIImage imageNamed:addImageBackGroundImageStr] forState:UIControlStateNormal];
}
- (void)setPlaceholderText:(NSString *)placeholderText{
    _placeholderText = placeholderText;
    self.textView.placeholderText = placeholderText;
}
#pragma mark --Event
- (void)addImageBtnDidClick:(UIButton *)btn{
    _textViewRange = _textView.selectedRange;
    TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    controller.allowPickingVideo = NO;
    [[BaseViewController topViewController] presentViewController:controller animated:YES completion:nil];

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

//上传阿里云
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
                success(self.imageUrl);
            } else {
                [MyProgressHUD showErrorWithStatus:@"插入失败, 请重新选择图片" duration:1.0];
                success(nil);
            }
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD dismissWithDelay:0.2];
            [MyProgressHUD showErrorWithStatus:@"插入失败, 请重新选择图片" duration:1.0];
            success(nil);
            
        }];
    });
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
- (void)reloadUpdateConten{
    NSMutableArray *postArray = [[self p_trimIsMove:NO] mutableCopy];
    for (int i = 0; i < postArray.count; i++) {
        if ([postArray[i] isKindOfClass:[ImageModel class]]) {
            ImageModel *model = postArray[i];
            NSString *imageStr = [NSString stringWithFormat:@"<img src=\"%@\">", model.abbrUrl];
            postArray[i] = imageStr;  //替换成标签内容 - 图片url
        }
        //插入标签<p>%@</p>
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

}


@end
