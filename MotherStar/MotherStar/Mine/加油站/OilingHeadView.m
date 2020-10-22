//
//  OilingHeadView.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/11.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "OilingHeadView.h"

@implementation OilingHeadView


- (void)drawRect:(CGRect)rect {

    _view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _view.layer.cornerRadius = 9;
    _view.layer.shadowColor = [UIColor colorWithRed:131/255.0 green:134/255.0 blue:163/255.0 alpha:0.16].CGColor;
    _view.layer.shadowOffset = CGSizeMake(0,0);
    _view.layer.shadowOpacity = 1;
    _view.layer.shadowRadius = 10;
    
    _btn.layer.cornerRadius = 17;
    _btn.layer.masksToBounds = YES;
    _btn.layer.borderColor = [UIColor colorWithRed:239/255.0 green:180/255.0 blue:0/255.0 alpha:1.0].CGColor;
    _btn.layer.borderWidth = 1.0;
    
}
- (IBAction)inviteAction:(UIButton *)sender {
    // 判断下这个block在控制其中有没有被实现
        if (self.buttonAction) {
    // 调用block传入参数
            self.buttonAction(sender);
        }
}
- (IBAction)integAction:(UIButton *)sender {
    if (self.integBlock) {
        self.integBlock();
    }
}


@end
