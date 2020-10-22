//
//  BaseViewController.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/23.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"\n\n当前控制器--->>>>> %@ <<<<<---\n\n", self.class);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultNavigationBar];
}



- (void)setDefaultNavigationBar {
    self.gk_navTitleFont = PingFangSC_Regular(18);
    self.gk_navTitleColor = UICOLOR(@"#343338");
    self.gk_navLeftBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"back_black"] target:self action:@selector(backAction)];
    [GKConfigure updateConfigure:^(GKNavigationBarConfigure * _Nonnull configure) {
    }];
}
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --添加键盘通知
- (void)addKeyboardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHinndeNotification:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeKeyboardNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
- (void)keyboardShowNotification:(NSNotification *)nito {
    NSDictionary * userInfo = nito.userInfo;
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    [self keyboardWillShowNotification:[value CGRectValue].size.height];
}
- (void)keyboardHinndeNotification:(NSNotification *)nito {
    NSDictionary * userInfo = nito.userInfo;
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    [self keyboardWillHinndeNotification:[value CGRectValue].size.height];
}
- (void)keyboardWillShowNotification:(float)keyboardHeight{}//子类实现
- (void)keyboardWillHinndeNotification:(float)keyboardHeight{}//子类实现

#pragma mark --获取当前跟视图
+ (UIViewController*)topViewController {
    return (RootViewController *)[self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        if ([presentedViewController isKindOfClass:[UIAlertController class]]) {
            UIWindow *window =  [UIApplication sharedApplication].delegate.window;
            UIViewController *vc = window.rootViewController;
            return [self topViewControllerWithRootViewController:vc];
        }
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
