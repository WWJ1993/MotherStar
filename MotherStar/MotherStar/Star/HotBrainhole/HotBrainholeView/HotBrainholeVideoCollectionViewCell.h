//
//  HotBrainholeVideoCollectionViewCell.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/31.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HotBrainholeVideoModel;

@interface HotBrainholeVideoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *firstFrameImageView;
@property (nonatomic, strong) HotBrainholeVideoModel *hotBrainholeVideoModel;
@property (nonatomic, strong) UIView *playerSuperView;  //test

@end

NS_ASSUME_NONNULL_END
