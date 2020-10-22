//
//  StarDetailCell.h
//  MotherStar
//
//  Created by 王文杰 on 2020/1/13.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StarDetailVideoCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dic;
+ (StarDetailVideoCell *)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
