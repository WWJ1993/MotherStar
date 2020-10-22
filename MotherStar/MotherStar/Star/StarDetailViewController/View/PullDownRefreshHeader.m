////
////  PullDownRefreshHeader.m
////  EasyBilling
////
////  Created by QF on 16/11/3.
////  Copyright © 2016年 Qianfan. All rights reserved.
////
//
//#import "PullDownRefreshHeader.h"
////#define DragAnimationImage         @"箱子打开000"         //拖动打开箱子动画图片名称
////#define DragAnimationImageCount    55                   //拖动打开箱子动画图片数量
////#define RefreshingAnimatImage      @"喷钱2016-10-13_000"//喷钱动画图片名称
////#define RefreshingAnimatImageCount 23                  //喷钱动画图片数量
////#define DragMax                    @"箱子打开00054"     //拖动距离最大时的图片
//@interface PullDownRefreshHeader()
///** 所有状态对应的动画图片 */
////@property (strong, nonatomic) NSMutableDictionary *stateImages;
/////** 所有状态对应的动画时间 */
////@property (strong, nonatomic) NSMutableDictionary *stateDurations;
/////** 正在刷新时的图片 */
////@property (strong, nonatomic) NSMutableArray *refreshingImages;
////
////@property (strong, nonatomic) NSMutableArray *endImages;
//@end
//@implementation PullDownRefreshHeader
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self defaults];
//    }
//    return self;
//}
//
///
////设置默认属性
//- (void)defaults{
//    if (!self.stateLabel.hidden) {
//        self.stateLabel.hidden = YES;
//    }
//    if (!self.lastUpdatedTimeLabel.hidden) {
//        self.lastUpdatedTimeLabel.hidden = YES;
//    }
//    if (self.mj_h != 60) {
//        self.mj_h = 60;
//    }
//    
//
//}
//
//
////复写状态的set方法
//- (void)setState:(MJRefreshState)state
//{
//    MJRefreshCheckState
//    
//    // 根据状态做事情
//    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
//        NSArray *images ;//self.refreshingImages;
//        if (images.count == 0) return;
//        
//        if (images.count == 1) { // 单张图片
//            self.gifView.image = [images lastObject];
//        }
//    } else if (state == MJRefreshStateIdle) {
////        if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStatePossible)  {
////            NSArray *images = self.stateImages[@(state)];
////            self.gifView.animationImages = images;
////            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
//            [self.gifView startAnimating];
//        }else{
//            [self.gifView stopAnimating];
//        }
//    }
//}
////手指拖动监测偏移量
////- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
////{
////    [super scrollViewContentOffsetDidChange:change];
////
////    CGFloat offsetY = self.scrollView.mj_offsetY;
////
////    if (ABS(offsetY) > 60){
////        if (!(self.gifView.image == kImageName(DragMax))) {
////            self.gifView.image = kImageName(DragMax);
////        }
////    }else if(ABS(offsetY) > 36){
////        NSString *imageName = [NSString stringWithFormat:@"%@%02d",DragAnimationImage,ABS((int)(offsetY + 6))];
////        if (!(self.gifView.image == kImageName(imageName))) {
////            self.gifView.image = kImageName(imageName);
////        }
////    }else{
////        NSString *imageName = [NSString stringWithFormat:@"%@%02d",DragAnimationImage,30];
////        if (!(self.gifView.image == kImageName(imageName))) {
////            self.gifView.image = kImageName(imageName);
////        }
////    }
////}
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//@end
