//
//  GlobalSingleton.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/10.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GloablModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GlobalSingleton : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, strong) GloablModel *model;

@end

NS_ASSUME_NONNULL_END
