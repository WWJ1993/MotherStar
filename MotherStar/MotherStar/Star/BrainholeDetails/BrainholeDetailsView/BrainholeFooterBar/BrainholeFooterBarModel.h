//
//  BrainholeFooterBarModel.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/12.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrainholeFooterBarModel : UIView
@property (nonatomic, assign) NSInteger comments;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) NSInteger shares;
@property (nonatomic, assign) NSInteger fuels;
@property (nonatomic, assign) NSInteger like;  //0-未点赞 1-点赞

@end

NS_ASSUME_NONNULL_END
