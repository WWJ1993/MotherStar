//
//  StarRefreshGifHeader.m
//  MotherStar
//
//  Created by yanming niu on 2020/2/3.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "StarRefreshGifHeader.h"

@implementation StarRefreshGifHeader

- (void)prepare {
    [super prepare];
    // 设置普通状态的动画图片
    UIImage *image = [UIImage imageNamed:@"dropDownRefresh"];
    NSArray *imageArray = @[image];
    [self setImages:imageArray forState:MJRefreshStateIdle];
    [self setImages:imageArray forState:MJRefreshStatePulling];
    [self setImages:imageArray forState:MJRefreshStateRefreshing];

    [self setTitle:@"松开刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"松开刷新" forState:MJRefreshStateRefreshing];

    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = NO;
    self.stateLabel.textColor = UICOLOR(@"#CBD2DB");
    
    UIImage *backGroundImage=[UIImage imageNamed:@"background_loading"];
    self.contentMode=UIViewContentModeScaleAspectFill;
//    self.layer.contents=(__bridge id _Nullable)(backGroundImage.CGImage);
    self.backgroundColor = [UIColor colorWithPatternImage:backGroundImage];


    self.mj_h = 80;
}

//在这修改图片和label的位置
- (void)placeSubviews {
    [super placeSubviews];
    self.gifView.contentMode = UIViewContentModeCenter;

    //调整图片的位置
    CGRect labelframe = self.stateLabel.frame;
    labelframe.size.height = 15;
    labelframe.origin.y = self.bounds.size.height - 20;
    self.stateLabel.frame = labelframe;
    CGPoint center = self.center;
    center.y = CGRectGetMinY(self.stateLabel.frame) - self.gifView.mj_h / 2.0 + 10;  //可修改
    self.gifView.center = center;
}

@end
