//
//  ReleaseCell.h
//  MotherStar
//
//  Created by 王文杰 on 2020/1/12.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReleaseModel;
NS_ASSUME_NONNULL_BEGIN

@interface ReleaseCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong)  ReleaseModel *model;
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font ;
+ (ReleaseCell *)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
