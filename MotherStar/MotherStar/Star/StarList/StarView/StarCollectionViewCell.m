//
//  StarCollectionViewCell.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/25.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "StarCollectionViewCell.h"

@implementation StarCollectionViewCell
{
    UIView *starView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加自己需要个子视图控件
        starView = [[UIView alloc] initWithFrame:CGRectZero];
        starView.backgroundColor = UICOLOR(@"#FFFFFFFF");
        starView.layer.shadowColor = UICOLOR(@"#1C343338").CGColor;
        starView.layer.shadowOffset = CGSizeMake(0,0);
        starView.layer.shadowOpacity = 1;
        starView.layer.shadowRadius = 8;
        self.starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.starImageView.userInteractionEnabled = YES;
        self.starImageView.layer.cornerRadius = self.starImageView .frame.size.width /2;  //圆形
        self.starImageView.clipsToBounds = YES;
     
        self.starTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        self.starTitle.font = PingFangSC_Regular(14);
        self.starTitle.textColor = UICOLOR(@"#343338");
        
        [starView addSubview:self.starImageView];
        [starView addSubview:self.starTitle];
        [self addSubview:starView];
    }
    return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  [starView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.right.top.mas_equalTo(0);
      make.width.mas_equalTo(@50);
      make.height.equalTo(@74);
  }];

  [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(0);
      make.centerX.mas_equalTo(self.contentView);
      make.width.height.offset = 50;
  }];
  
  [self.starTitle mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self.starImageView.mas_bottom).offset = 10;
      make.centerX.mas_equalTo(self.contentView);
      make.bottom.offset = 0;
  }];
}

@end
