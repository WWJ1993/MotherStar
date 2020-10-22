//
//  SaveBrainholeTextViewController.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/14.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TextBlock)(NSString *, UIImage *);

@interface SaveBrainholeTextViewController : BaseViewController
@property (nonatomic, copy) TextBlock textBlock;

@end

NS_ASSUME_NONNULL_END
