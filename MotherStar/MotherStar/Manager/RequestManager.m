//
//  RequestManager.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/5.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "RequestManager.h"


@interface RequestManager () {
    
}

@end

@implementation RequestManager

+ (RequestManager *)sharedInstance {
    static RequestManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RequestManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                                                         @"text/html",
                                                                                         @"text/json",
                                                                                   @"text/javascript",
                                                                                        @"text/plain", nil];
        manager.requestSerializer.timeoutInterval = 10;

    });
    
    
    return manager;
}

- (void)GET:(NSString *)url parameters:(NSDictionary *)params
                         authorization:(NSString *)token
                              progress:(ProgressBlock)progress
                               success:(SuccessBlock)success
                               failure:(FailBlock)fail {
    RequestManager *manager = [RequestManager sharedInstance];
    token = [AppCacheManager sharedSession].token;
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
       
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

- (void)POST:(NSString *)url params:(NSDictionary *)params
                     authorization:(NSString *)token
                          progress:(ProgressBlock)progress
                           success:(SuccessBlock)success
                          failure:(FailBlock)fail {
    
    RequestManager *manager = [RequestManager sharedInstance];
  
    token = [AppCacheManager sharedSession].token;
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}

@end
