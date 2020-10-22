//
//  PostNewVideoCommentViewController.h
//  MotherStar
//
//  Created by  on 2020/2/15.
//  Copyright © 2020年 yanming niu. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 脑洞--评论页面
 */
@interface PostNewVideoCommentViewController : BaseViewController
typedef void(^BrainholeBlock)(NSString *);
@property (nonatomic, copy) BrainholeBlock brainholeBlock;
@property (nonatomic, assign) NSInteger brainholeVideoId;
@property (nonatomic, assign) NSInteger postCommentTyple;

@end

NS_ASSUME_NONNULL_END
