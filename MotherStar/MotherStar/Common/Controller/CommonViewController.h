//
//  CommonViewController.h
//  MotherStar
//
//  Created by 王文杰 on 2020/2/4.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonViewController : BaseViewController
@property (nonatomic, strong) UITableView *hotBrainholeTableView;
@property (nonatomic, strong) NSMutableArray *braninholesArray;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, copy) void(^loadBlock)(void);

@end

NS_ASSUME_NONNULL_END
