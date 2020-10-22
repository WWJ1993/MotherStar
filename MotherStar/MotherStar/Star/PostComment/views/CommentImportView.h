//
//  CommentImportView.h
//  MotherStar
//
//  Created by 胡志军 on 2020/2/15.
//  Copyright © 2020年 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
#import <yytext/YYTextEffectWindow.h>
#import "TZImagePickerController.h"
#import "CustomYYImage.h"
#import "UIColor+LCColor.h"
#import "ImageModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 评论输入视图
默认高度 194 + 74,外面不需要做高度约束（textView.y - addImageBtn.maxY）
 带底部图片输入框
 */
@interface CommentImportView : UIView
@property (nonatomic, strong) UIView     *backView;

//评论输入框
@property (strong, nonatomic) YYTextView *textView;
//字符长度控制展示
@property (nonatomic, strong) UILabel     * lenghtLab;

//添加图片按钮
@property (nonatomic, strong) UIButton * addImageBtn;

#pragma mark --可以配置的参数
@property (nonatomic, copy)   NSString  * addImageBackGroundImageStr;// 添加按钮的图片

//输入框字符最大控制  默认500
@property (nonatomic, assign) NSInteger maxLenght;

//输入字符串
@property (nonatomic, strong) NSMutableAttributedString *text;
@property (nonatomic, copy) NSString * placeholderText;
#pragma mark --原来页面用到的参数
@property (nonatomic, assign) NSRange textViewRange;
@property(nonatomic,copy) NSString *tipStr;
@property (nonatomic, strong) OSSManager *ossManager;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) NSString *brainholeCommentText;  //html文本

//用来更新 上传内容
- (void)reloadUpdateConten;
@end

NS_ASSUME_NONNULL_END
