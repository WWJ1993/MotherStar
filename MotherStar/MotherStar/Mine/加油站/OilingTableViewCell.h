//
//  OilingTableViewCell.h
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/11.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ButtonClickCell)(NSNumber * taskId);

@interface OilingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (nonatomic, copy) ButtonClickCell buttonActionCell;
@property (nonatomic, copy) NSDictionary *dic;
@end

NS_ASSUME_NONNULL_END
