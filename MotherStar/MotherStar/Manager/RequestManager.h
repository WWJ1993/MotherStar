//
//  RequestManager.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/5.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void( ^SuccessBlock)(id _Nullable response);
typedef void( ^FailBlock)(NSError * _Nonnull error);
typedef void( ^ProgressBlock)(NSProgress * _Nonnull progress);


NS_ASSUME_NONNULL_BEGIN


@interface RequestManager : AFHTTPSessionManager

+ (RequestManager *)sharedInstance;

- (void)GET:(NSString *)url parameters:(NSDictionary *)params
                         authorization:(NSString *)token
                              progress:(ProgressBlock)progress
                               success:(SuccessBlock)success
                               failure:(FailBlock)fail;

- (void)POST:(NSString *)url params:(NSDictionary *)params
                      authorization:(NSString *)token
                           progress:(ProgressBlock)progress
                            success:(SuccessBlock)success
                            failure:(FailBlock)fail;

@end

NS_ASSUME_NONNULL_END
