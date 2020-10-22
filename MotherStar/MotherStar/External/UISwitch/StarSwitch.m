//
//  StarSwitch.m
//  MotherStar
//
//  Created by yanming niu on 2020/2/17.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "StarSwitch.h"

@implementation StarSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        self.adjustsImageWhenHighlighted = NO; // 长按不变灰
        self.on = NO; // 默认为NO，与UISwitch保持一致
        [self addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

// 按钮点击，触发valueChanged事件
- (void)buttonClicked {
    self.on = !self.on;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/** 赋值开启or关闭状态 */
- (void)setOn:(BOOL)on {
    _on = on;
    _on ? (self.selected = YES) : (self.selected = NO);
}

/** 设置按钮的点选状态 */
- (void)setOn:(BOOL)on animated:(BOOL)animated {
    self.on = on;
}

@end
