//
//  StarSwitch.h
//  MotherStar
//
//  Created by yanming niu on 2020/2/17.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StarSwitch : UIButton
/* 是否是开启状态 */
@property(nonatomic, assign, getter = isOn) BOOL on;

/* 设置按钮的点选状态 */
- (void)setOn:(BOOL)on animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
