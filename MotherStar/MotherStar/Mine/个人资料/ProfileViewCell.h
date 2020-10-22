//
//  ProfileViewCell.h
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/16.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewCell : UITableViewCell
@property (copy, nonatomic) NSArray *array;
@property (weak, nonatomic) IBOutlet UILabel *name1;

@end

NS_ASSUME_NONNULL_END
