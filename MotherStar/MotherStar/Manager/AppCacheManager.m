//
//  AppCacheManager.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/23.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "AppCacheManager.h"

@implementation AppCacheManager

- (BOOL)isLogin{
    return self.token.length;
}

@end
