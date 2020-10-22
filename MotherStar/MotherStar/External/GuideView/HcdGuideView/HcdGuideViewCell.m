//
//  HcdGuideViewCell.m
//  HcdGuideViewDemo
//
//  Created by polesapp-hcd on 16/7/12.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import "HcdGuideViewCell.h"
#import "HcdGuideView.h"

@interface HcdGuideViewCell()

@end

@implementation HcdGuideViewCell

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.layer.masksToBounds = YES;
    self.imageView = [[UIImageView alloc]initWithFrame:kHcdGuideViewBounds];
    self.imageView.center = CGPointMake(kHcdGuideViewBounds.size.width / 2, kHcdGuideViewBounds.size.height / 2);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.hidden = YES;
    [button setFrame:CGRectMake(0, 0, 142, 46)];
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = PingFangSC_Regular(18);
    [button.layer setCornerRadius:6];
//    [button.layer setBorderColor:[UIColor grayColor].CGColor];
//    [button.layer setBorderWidth:1.0f];
    [button setBackgroundColor:[UIColor whiteColor]];
    
   
    button.layer.shadowColor = [UIColor colorWithRed:239/255.0 green:180/255.0 blue:0/255.0 alpha:0.54].CGColor;
    button.layer.shadowOffset = CGSizeMake(0,0);
    button.layer.shadowOpacity = 1;
    button.layer.shadowRadius = 8;
    
    self.button = button;
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.button];
    
    [self.button setCenter:CGPointMake(kHcdGuideViewBounds.size.width / 2, kHcdGuideViewBounds.size.height - 50)];
}

@end
