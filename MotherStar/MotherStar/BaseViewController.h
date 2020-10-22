//
//  BaseViewController.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/23.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

#pragma 添加和移除键盘观察者
- (void)addKeyboardNotification;
- (void)removeKeyboardNotification;
//键盘通知方法回调
- (void)keyboardWillShowNotification:(float)keyboardHeight;
- (void)keyboardWillHinndeNotification:(float)keyboardHeight;
+ (UIViewController *)topViewController;

@end

NS_ASSUME_NONNULL_END
