//
//  SearchResultViewController.h
//  MotherStar
//
//  Created by 王文杰 on 2020/2/3.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : CommonViewController
@property(nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *searchHistoriesCachePath;
@property (nonatomic, copy) void(^searchClickBlock)(NSString *keyword);
@end

NS_ASSUME_NONNULL_END
