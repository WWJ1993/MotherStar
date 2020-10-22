//
//  CommentTableViewCell.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/27.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CommentModel;
@interface CommentTableViewCell : UITableViewCell
@property (nonatomic, strong) CommentModel *commentModel;
@end

NS_ASSUME_NONNULL_END
