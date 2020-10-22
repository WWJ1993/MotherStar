//
//  AppDelegate.m
//  MotherStar
//
//  Created by yanming niu on 2019/11/25.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "AppDelegate.h"
#import "PwdLoginViewController.h"
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UMPush/UMessage.h>
#import "IQKeyboardManager.h"
#import "RootViewController.h"
#import "GuideViewController.h"
#import "SVProgressHUD.h"
#import "UpEditionStatusTool.h"
#import "MotherPlanetAlertView.h"
#import <UShareUI/UShareUI.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end
@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setupNavigationBarConfigure];
    [self setupKeyboardManager];
    [self videoPlayerGlobalConfigation];  //播放器全局配置
    
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    //第一次启动
    BOOL firstLaunch = [AppCacheManager sharedSession].firstLaunch;
    if (!firstLaunch) {
      [AppCacheManager sharedSession].firstLaunch = YES;
        //引导页
        GuideViewController * guideVC = [[GuideViewController alloc] init];
        self.window.rootViewController = guideVC;
        [self.window makeKeyAndVisible];
    } else {
        NSString *token = [AppCacheManager sharedSession].token ;
            //主页
        RootViewController *rootVC = [[RootViewController alloc] init];
        self.window.rootViewController = rootVC;
        [self.window makeKeyAndVisible];
        if (String_isEmpty(token)) {
            //登录页
            PwdLoginViewController *loginVC = [[PwdLoginViewController alloc] init];
            [rootVC presentViewController:loginVC animated:YES completion:nil];
        }
    }
    
    //友盟
    [self configUSharePlatforms];
    [self setupUPush:launchOptions];
    [UpEditionStatusTool taskUpEditation];  //强制更新
    return YES;
}

#pragma mark  -- 播放器配置 --

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAll;
}

/* 播放器全局配置 */
- (void)videoPlayerGlobalConfigation {
    SJVideoPlayer.update(^(SJVideoPlayerSettings * _Nonnull common) {
        common.placeholder = [UIImage imageNamed:@"placeholder"];
        common.progress_thumbSize = 8;
        common.progress_trackColor = [UIColor colorWithWhite:0.8 alpha:1];
        common.bottomIndicator_trackColor = [UIColor whiteColor];
        common.progress_traceHeight = 1.5;
        common.progress_traceColor = UICOLOR(@"#F2B300");
        common.progress_bufferColor = [UIColor whiteColor];
        common.progress_thumbColor = [UIColor whiteColor];
//        common.fullBtnImage = [UIImage imageNamed:@""];  //待修改
    });
}

//导航栏默认配置
- (void)setupNavigationBarConfigure {
    [GKConfigure setupCustomConfigure:^(GKNavigationBarConfigure * _Nonnull configure) {
        configure.gk_translationX = 15;
        configure.gk_translationY = 20;
        configure.gk_scaleX = 0.90;
        configure.gk_scaleY = 0.92;
        configure.gk_navItemLeftSpace = 16.0f;
        configure.gk_navItemRightSpace = 16.0f;
    }];
}


- (void)  application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [UMessage registerDeviceToken:deviceToken];
    NSString *tokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"%@",tokenStr);
//    MotherPlanetAlertView *alertView = [[MotherPlanetAlertView alloc] initDeviceToken:tokenStr];

    
    
}



- (void )application:( UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:( NSError *)error {

    NSLog ( @"%@" ,error);

}
- (void)setupUPush:(NSDictionary *)launchOptions{
    [[UIApplication sharedApplication]registerForRemoteNotifications];
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else
        {
        }
    }];
}
- (void)setupKeyboardManager {
//    [IQKeyboardManager sharedManager].enable = YES;
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.enableAutoToolbar = NO;
}

- (void)configUSharePlatforms
{
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;

    /* 设置友盟appkey */
    [UMConfigure initWithAppkey:@"5a15178a8f4a9d0c9900017b" channel:@"App Store"];
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx1d61c470a450d93a" appSecret:@"b50b372f38cf052aed1024fd4527dfc4" redirectURL:@"https://api.weibo.com/oauth2/default.html"];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106549818"/*设置QQ平台的appID*/  appSecret:@"GYOkjXlE9YU4ENeO" redirectURL:@""];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"4082907722"  appSecret:@"28b6962597573aa8ebc03d4f1d98a0d7" redirectURL:@"https://api.weibo.com/oauth2/default.html"];
    
    [self customItem];

}

/* 自定义分享面板按钮 */
- (void)customItem {
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+1
                                        withPlatformIcon:[UIImage imageNamed:@"copyLink"]
                                        withPlatformName:@"复制链接"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
                                           withPlatformIcon:[UIImage imageNamed:@"shield"]
                                           withPlatformName:@"屏蔽此内容"];
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+3
                                              withPlatformIcon:[UIImage imageNamed:@"report"]
                                              withPlatformName:@"举报"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+4
                                        withPlatformIcon:[UIImage imageNamed:@"navgationBar_more"]
                                        withPlatformName:@"更多"];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    if (![[UMSocialManager defaultManager] handleOpenURL:url]) {
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
        return result;
    }else{
//        [self processPayResultWithURL:url];//支付结果/** 处理支付结果*/
        return YES;
    }
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
     completionHandler(UIBackgroundFetchResultNewData);
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        //TODO:处理
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
}
//-(UIImage *)getImage:(NSString *)imageName {
//    UIImage * image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    return image;
//}

@end

#pragma mark  -- 设备旋转配置 --

@implementation UIViewController (RotationControl)

- (BOOL)shouldAutorotate {
    return YES;  //是否允许旋转
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end


@implementation UITabBarController (RotationControl)
- (UIViewController *)sj_topViewController {
    if ( self.selectedIndex == NSNotFound )
        return self.viewControllers.firstObject;
    return self.selectedViewController;
}

- (BOOL)shouldAutorotate {
    return [[self sj_topViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self sj_topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self sj_topViewController] preferredInterfaceOrientationForPresentation];
}
@end

@implementation UINavigationController (RotationControl)
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
@end

