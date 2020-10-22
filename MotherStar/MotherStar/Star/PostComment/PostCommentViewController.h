//
//  PostCommentViewController.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/13.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BrainholeBlock)(NSString *);

@interface PostCommentViewController : BaseViewController
@property (nonatomic, copy) BrainholeBlock brainholeBlock;
@property (nonatomic, assign) NSInteger brainholeId;
@property (nonatomic, assign) NSInteger postCommentTyple;


@end

NS_ASSUME_NONNULL_END
