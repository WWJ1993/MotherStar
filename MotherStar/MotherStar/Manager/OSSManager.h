//
//  OSSManager.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/6.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"
#import <UIKit/UIImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSSModel : NSObject
@property (nonatomic, copy) NSString *accessKeyId;
@property (nonatomic, copy) NSString *accessKeySecret;
@property (nonatomic, copy) NSString *securityToken;
@property (nonatomic, copy) NSString *folder;
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *bucketName;
@property (nonatomic, copy) NSString *endpoint;
@property (nonatomic, copy) NSString *objectKey; 


@end

@interface OSSManager : NSObject

- (void)uploadImage:(UIImage *)image success:(SuccessBlock)success failure:(FailBlock)failure;
- (void)uploadVideo:(NSData *)videoData success:(SuccessBlock)success failure:(FailBlock)failure;
- (void)deleteOSSFile:(SuccessBlock)success failure:(FailBlock)failure;

- (void)testUploadImage:(UIImage *)image success:(SuccessBlock)success failure:(FailBlock)failure;
- (void)testUploadVideo:(NSData *)videoData success:(SuccessBlock)success failure:(FailBlock)failure;

@end

NS_ASSUME_NONNULL_END
