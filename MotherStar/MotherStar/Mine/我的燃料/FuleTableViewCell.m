//
//  FuleTableViewCell.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/16.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "FuleTableViewCell.h"

@interface FuleTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenLabel;

@end

@implementation FuleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setDic:(NSDictionary *)dic{
    _titleName.text = [NSString stringWithFormat:@"%@", dic[@"showName"]];
    _dateLabel.text = [NSString stringWithFormat:@"%@", dic[@"createTime"]];
    if ([dic[@"integralType"] isEqual:@(0)]) {
        _fenLabel.text = [NSString stringWithFormat:@"+%@",dic[@"integral"]];
    }else{
        _fenLabel.text = [NSString stringWithFormat:@"-%@",dic[@"integral"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
