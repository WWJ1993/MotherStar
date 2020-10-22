//
//  PersonCacheViewCell.h
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/10.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonCacheViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *cache;

@end

NS_ASSUME_NONNULL_END
