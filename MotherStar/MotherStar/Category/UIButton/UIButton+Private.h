//
//  UIButton+Private.h
//  MotherStar
//
//  Created by yanming niu on 2020/2/14.
//  Copyright © 2020 yanming niu. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Private)
//设置button的额外增加的范围,四个方向增加的相同
- (void)setEnlargeEdge:(CGFloat)size;
//分别设置button的四个方向要增大的范围
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end

NS_ASSUME_NONNULL_END
