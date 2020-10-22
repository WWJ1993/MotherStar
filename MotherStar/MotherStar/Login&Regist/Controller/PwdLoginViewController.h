//
//  LoginViewController.h
//  ParentStar
//
//  Created by WWJ on 2019/12/16.
//  Copyright © 2019年 Socrates. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PwdLoginViewController : UIViewController
@property (nonatomic, assign) BOOL isLoginOut;
+ (void)loginWithViewController:(UIViewController *)vc;
+ (void)loginOutViewController:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
