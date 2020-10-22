//
//  GlobalSingleton.m
//  MotherStar
//
//  Created by yanming niu on 2020/1/10.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "GlobalSingleton.h"

static GlobalSingleton *instance = nil;

@implementation GlobalSingleton

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];;
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (GloablModel *)model {
    if (!_model) {
        _model = [[GloablModel alloc] init];
    }
    return _model;
}


@end
