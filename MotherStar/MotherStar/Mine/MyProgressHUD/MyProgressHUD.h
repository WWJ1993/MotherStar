//
//  MyProgressHUD.h
//
//  Created by zsl on 2017/10/17.
//  Copyright 2018 zsl. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

enum {
    MyProgressHUDMaskTypeNone = 1,  // 当提示显示的时间，用户仍然可以做其他操作，比如View 上面的输入等
    MyProgressHUDMaskTypeClear,     // 用户不可以做其他操作
    MyProgressHUDMaskTypeBlack,     // 用户不可以做其他操作，并且背景色是黑色
    MyProgressHUDMaskTypeGradient   // 用户不可以做其他操作，并且背景色是渐变的
};

typedef NSUInteger MyProgressHUDMaskType;




@interface MyProgressHUD : UIView

+ (void)show;
+ (void)showWithStatus:(NSString*)status;
/**
 *  展示状态
 *
 *  @param status   显示状态
 *  @param maskType 枚举类型
 */
+ (void)showWithStatus:(NSString*)status maskType:(MyProgressHUDMaskType)maskType;

+ (void)showWithMaskType:(MyProgressHUDMaskType)maskType;
/**
 *  展示成功的状态
 *
 *  @param string 传字符串
 */
+ (void)showSuccessWithStatus:(NSString*)string;
/**
 *  展示成功的状态
 *
 *  @param string   传字符串
 *  @param duration 设定显示时间
 */
+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
/**
 展示失败的状态

 @param string 字符串
 */
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration;


/**
 展示提示信息
 
 @param string 字符串
 */
+ (void)showPromptWithStatus:(NSString *)string;
+ (void)showPromptWithStatus:(NSString *)string duration:(NSTimeInterval)duration;

+ (void)setStatus:(NSString*)string; // 在显示时更改HUD的加载状态。

+ (void)dismiss; //简单地用淡出+缩放动画来解散HUD。
+ (void)dismissWithSuccess:(NSString*)successString; // 显示成功图标图像
+ (void)dismissWithSuccess:(NSString*)successString afterDelay:(NSTimeInterval)seconds;
+ (void)dismissWithError:(NSString*)errorString; // 显示错误图标图像。
+ (void)dismissWithError:(NSString*)errorString afterDelay:(NSTimeInterval)seconds;
+ (void)dismissWithPrompt:(NSString *)promptString;
+ (void)dismissWithPrompt:(NSString *)promptString afterDelay:(NSTimeInterval)seconds;

+ (BOOL)isVisible;

+ (MyProgressHUD*)sharedView ;

- (void)dismissWithNoAni;

@end
