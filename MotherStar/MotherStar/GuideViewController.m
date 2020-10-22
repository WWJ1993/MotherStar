//
//  GuideViewController.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/23.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "GuideViewController.h"
#import "PwdLoginViewController.h"
#import "HcdGuideView.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initGuideViewController];
    self.view.backgroundColor= [UIColor whiteColor];
    [self setUI];
}

- (void)initGuideViewController {
    //引导页
    NSMutableArray *images = [NSMutableArray new];
    [images addObject:[UIImage imageNamed:@"1"]];
    [images addObject:[UIImage imageNamed:@"2"]];
    [images addObject:[UIImage imageNamed:@"3"]];
    
    HcdGuideView *guideView = [HcdGuideView sharedInstance];
//    guideView.window = [UIApplication sharedApplication].keyWindow;

    [guideView showGuideViewWithImages:images andButtonTitle:@"开始使用"
                   andButtonTitleColor:[UIColor whiteColor]
                      andButtonBGColor:UICOLOR(@"#EFB400")
                  andButtonBorderColor:[UIColor whiteColor]
                  targetViewController:self];
    guideView.loginBlock = ^{
        [self login];
    };
}

- (void)setUI{
    UIImageView *gifV = [[UIImageView alloc]init];
    [self.view addSubview:gifV];
    [gifV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-200);
    }];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_animation"]];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(gifV.mas_bottom).mas_offset(26);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(90);
        make.width.mas_equalTo(116);
    }];
    
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"btn_animation"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageV.mas_bottom).mas_offset(26);
        make.centerX.mas_equalTo(self.view);
    }];

    
    NSURL *gifUrl = [[NSBundle mainBundle] URLForResource:@"guide" withExtension:@"gif"];
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)gifUrl, NULL);
    size_t imageCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (size_t i = 0; i < imageCount; i++) {
        //获取源图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [mutableArray addObject:image];
        CGImageRelease(imageRef);
    }
    gifV.animationImages = mutableArray;
    gifV.contentMode = UIViewContentModeScaleAspectFit;
    gifV.animationDuration = 20;
    [gifV startAnimating];
}

- (void)login {
    PwdLoginViewController * loginVC = [[PwdLoginViewController alloc]init];
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:loginNav animated:YES completion:nil];
}

@end
