//
//  AppCacheManager.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/23.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppCacheManager : BGSession

@property (nonatomic, assign) BOOL firstLaunch;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, strong) NSArray *starsArray;

@property (nonatomic, assign) NSInteger myFuel;  //我的燃料值
@property (nonatomic, assign) NSInteger getFuel;  //收到燃料


@end

NS_ASSUME_NONNULL_END
