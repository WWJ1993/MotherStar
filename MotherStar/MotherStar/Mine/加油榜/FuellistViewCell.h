//
//  FuellistViewCell.h
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/16.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetFuelUserModel;
NS_ASSUME_NONNULL_BEGIN

@interface FuellistViewCell : UITableViewCell
@property (nonatomic, strong) GetFuelUserModel *model;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@end

NS_ASSUME_NONNULL_END
