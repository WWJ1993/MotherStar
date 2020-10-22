//
//  StarDetailCell.m
//  MotherStar
//
//  Created by 王文杰 on 2020/1/13.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "StarDetailVideoCell.h"

@implementation StarDetailVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (StarDetailVideoCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"StarDetailCell";
    StarDetailVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return cell;
}
@end
