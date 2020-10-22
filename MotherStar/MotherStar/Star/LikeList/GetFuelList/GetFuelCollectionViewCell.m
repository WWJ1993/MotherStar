//
//  LikeCollectionViewCell.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/30.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "GetFuelCollectionViewCell.h"
#import "GetFuelUserModel.h"

@implementation GetFuelCollectionViewCell
{
    UIView *getFuelView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        getFuelView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:getFuelView];

        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width /2;  //圆形
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.userInteractionEnabled = YES;
        [getFuelView addSubview:self.avatarImageView];

        self.fuel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.fuel.font = PingFangSC_Regular(12);
        self.fuel.textColor = UICOLOR(@"#343338");
        [getFuelView addSubview:self.fuel];
    }
    return self;
}



- (void)layoutSubviews {
  [super layoutSubviews];

  [getFuelView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.right.top.mas_equalTo(0);
      make.width.mas_equalTo(28);
      make.height.mas_equalTo(44);
  }];

  [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(0);
      make.centerX.mas_equalTo(self.contentView);
      make.width.height.offset = 28;
  }];
  
  [self.fuel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset = 4;
      make.centerX.mas_equalTo(self.contentView);
      make.bottom.offset = 0;
  }];
  
}

@end
