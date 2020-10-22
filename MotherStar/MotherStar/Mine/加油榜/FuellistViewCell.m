//
//  FuellistViewCell.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/16.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "FuellistViewCell.h"
#import "GetFuelUserModel.h"

@interface FuellistViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *supportLab;
@property (weak, nonatomic) IBOutlet UILabel *integralLab;

@end

@implementation FuellistViewCell

- (void)setModel:(GetFuelUserModel *)model{
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.name.text = model.nickName;
    self.supportLab.text = [NSString stringWithFormat:@"支持%@个项目", model.supportNum];
    self.integralLab.text = [NSString stringWithFormat:@"%ld", model.integral];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.layer.cornerRadius = 14;
    self.icon.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
