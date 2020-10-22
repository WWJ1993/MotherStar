//
//  RootViewController.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/23.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "RootViewController.h"
#import "StarViewController.h"
#import "PostBrainholeViewController.h"
#import "PersonViewController.h"
#import "PwdLoginViewController.h"
@interface RootViewController ()<UITabBarControllerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self initRootViewController];
}

- (void)initRootViewController {
    StarViewController *starVC = [[StarViewController alloc] init];
    UINavigationController *starNav = [[UINavigationController alloc] initWithRootViewController:starVC];
    
    PostBrainholeViewController * postVC =[[PostBrainholeViewController alloc] init];
    UINavigationController *postNav = [[UINavigationController alloc] initWithRootViewController:postVC];

    PersonViewController * mineVC =[[PersonViewController alloc] init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];

    starNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"STAR" image:[self getTabbarImage:@"tabbar_star-unSelected"] selectedImage:[self getTabbarImage:@"tabbar_star-selected"]];

    postNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"脑洞" image:[self getTabbarImage:@"tabbar_brainhole_unSelected"] selectedImage:[self getTabbarImage:@"tabbar_brainhole_selected"]];

    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[self getTabbarImage:@"tabbar_mine_unSelected"] selectedImage:[self getTabbarImage:@"tabbar_mine_selected"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:UICOLOR(@"#868686") forKey:NSForegroundColorAttributeName];
    [starNav.tabBarItem setTitleTextAttributes:dic forState:UIControlStateSelected];
    [postNav.tabBarItem setTitleTextAttributes:dic forState:UIControlStateSelected];
    [mineNav.tabBarItem setTitleTextAttributes:dic forState:UIControlStateSelected];

    self.viewControllers = @[starNav, postNav, mineNav];
}

-(UIImage *)getTabbarImage:(NSString *)imageName {
    UIImage * image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    UINavigationController *nav = (UINavigationController *)viewController;
    UIViewController *VC =nav.topViewController;
    if ([VC isKindOfClass:[PersonViewController class]]&&![AppCacheManager sharedSession].token.length) {
        
        [self presentViewController:[PwdLoginViewController new] animated:YES completion:nil];
        return NO;
    }
    return YES;
    
}

@end
