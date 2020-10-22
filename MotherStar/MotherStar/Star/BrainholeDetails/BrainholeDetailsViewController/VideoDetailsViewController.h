//
//  VideoDetailsViewController.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/24.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoDetailsViewController : BaseViewController

@property (nonatomic, assign) NSInteger brainholeVideoId;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *videoArray;


@end

NS_ASSUME_NONNULL_END
