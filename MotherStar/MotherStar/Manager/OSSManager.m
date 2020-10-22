//
//  OSSManager.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/6.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "OSSManager.h"
#import <AliyunOSSiOS/OSSService.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>

typedef void(^OSSAccessBlock)(OSSModel *model, BOOL success);

@implementation OSSModel

@end

@interface OSSManager ()
@property (nonatomic, strong) OSSClient *client;
@property (nonatomic, strong) OSSModel *ossModel;
@end

@implementation OSSManager

- (OSSClient *)client {
    if (!_client) {
        NSString *securityToken = self.ossModel.securityToken;  // 可空 与后台约定
        id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:self.ossModel.accessKeyId secretKeyId:self.ossModel.accessKeySecret securityToken:securityToken];
        _client = [[OSSClient alloc] initWithEndpoint:_ossModel.endpoint credentialProvider:credential];
//        _client.clientConfiguration.timeoutIntervalForResource = 24 * 60 * 60;  //default 7天
     }
    return _client;
}

- (void)uploadImage:(UIImage *)image success:(SuccessBlock)success failure:(FailBlock)failure {
    [self getOssAuth:^(OSSModel *model, BOOL access) {
        if (access) {
            OSSPutObjectRequest *put = [OSSPutObjectRequest new];
            put.bucketName = model.bucketName;
            model.folder = @"image";  //图片目录
            //  objectKey为云服储存的文件名
            NSString *timeStamp = [NSString getCurrentTimestamp];
            NSString *imageName = [NSString stringWithFormat:@"%@/iOS_%@.jpg", model.folder,timeStamp];

            put.objectKey = imageName;
            
            //---------------------------------------------------------------------
            CGFloat compression = 1;
            NSData *data = UIImageJPEGRepresentation(image, 1);
            
            CGFloat maxLength = 20000;

            if (data.length > maxLength) {
                while (data.length > maxLength && compression > 0.01) {
                    compression =compression * 0.5;
                    data = UIImageJPEGRepresentation(image, compression);
//                    max = compression;
                }
            }
//            if (data.length > maxLength) {
//                CGFloat max = 1;
//                CGFloat min = 0;
//                for (int i = 0; i < 6; ++i) {
//                    compression = (max + min) / 2;
//                    data = UIImageJPEGRepresentation(image, compression);
//                    if (data.length < maxLength * 0.8) {
//                        min = compression;
//                    } else if (data.length > maxLength) {
//                        max = compression;
//                    } else {
//                        break;
//                    }
//                }
//            }
            put.uploadingData = data;
            //----------------------------------------------------------------------
            // 此处可查看上传进度
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
            };
            
            OSSTask * putTask = [self.client putObject:put];  //OSSClient 已经初始化
            [putTask continueWithBlock:^id(OSSTask *task) {
                if (!task.error) {
                    NSLog(@"upload object success!");

                    //拼接url
                    NSString *url = [NSString stringWithFormat:@"%@/%@", model.domain, put.objectKey];
                    NSDictionary *response = @{ @"success" : @YES,
                                                @"url": url
                                              };
                        success(response);
                } else {
                    NSLog(@"upload object failed, error: %@" , task.error);
                    NSDictionary *response = @{ @"success" : @NO };
                    success(response);
                }
               return nil;
            }];
            [putTask waitUntilFinished];
    
            
        } else {
            
        }
    } failure:^(NSError * _Nonnull error) {
        //提示信息
    }];
}

- (void)uploadVideo:(NSData *)videoData success:(SuccessBlock)success failure:(FailBlock)failure {
    [self getOssAuth:^(OSSModel *model, BOOL access) {
        if (access) {
            model.folder = @"video";  //视频目录
            NSString *timeStamp = [NSString getCurrentTimestamp];
            NSString *videoName = [NSString stringWithFormat:@"%@/iOS_%@.mp4", model.folder,timeStamp];
            
            OSSPutObjectRequest *put = [OSSPutObjectRequest new];
            put.bucketName = model.bucketName;
            put.objectKey = videoName;  //objectKey为云服储存的文件名
            self.ossModel.objectKey = videoName;
            //---------------------------------------------------------------------
            put.uploadingData = videoData;
            //----------------------------------------------------------------------
               // 此处可查看上传进度
               put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                   NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
               };
            
               OSSTask * putTask = [self.client putObject:put];  //OSSClient 已经初始化
               [putTask continueWithBlock:^id(OSSTask *task) {
                   if (!task.error) {
                       NSLog(@"upload object success!");
                       //上传成功
                       //拼接url
                       NSString *url = [NSString stringWithFormat:@"%@/%@", model.domain, put.objectKey];
                       NSDictionary *response = @{
                                                   @"success" : @YES,
                                                   @"url": url
                                                 };
                       success(response);
                   } else {
                       NSLog(@"upload object failed, error: %@" , task.error);
                       NSDictionary *response = @{ @"success" : @NO };
                       success(response);
                   }
                   return nil;
               }];
            
               [putTask waitUntilFinished];
            
            } else {
            //获取认证信息错误  提示
        }

    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];

}

/* 判断文件是否存在 */
- (BOOL)isFileExist {
    NSError * error = nil;
    BOOL isExist = [self.client doesObjectExistInBucket:self.ossModel.bucketName objectKey:self.ossModel.objectKey error:&error];
    
    if (!error) {
        if(isExist) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}


/* 删除OSS文件 */
- (void)deleteOSSFile:(SuccessBlock)success failure:(FailBlock)failure {
    if ([self isFileExist]) {
        OSSDeleteObjectRequest * delete = [OSSDeleteObjectRequest new];
        delete.bucketName = self.ossModel.bucketName;
        delete.objectKey = self.ossModel.objectKey;

        OSSTask *deleteTask = [self.client deleteObject:delete];

        [deleteTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                success(@YES);  //删除成功
            } else {
                failure(task.error);
            }
            return nil;
        }];

        [deleteTask waitUntilFinished];
    } else {
        success(@NO);
    }
}



//获取oss授权
- (void)getOssAuth:(OSSAccessBlock)OSSAccess failure:(FailBlock)failure {
    NSString *authUrl = [BaseUrl stringByAppendingFormat:@"/oss/searchOss"];
    NSString *token = [AppCacheManager sharedSession].token;
    [[RequestManager sharedInstance] GET:authUrl parameters:@{} authorization:token progress:^(NSProgress * _Nonnull progress) {
        
        } success:^(id  _Nullable response) {
            NSDictionary *dataDic = response[@"data"];
            OSSModel *model = [[OSSModel alloc] init];
            model.accessKeyId = dataDic[@"accessid"];
            model.accessKeySecret = dataDic[@"accessKey"];
            model.domain = dataDic[@"host"];
            model.endpoint = dataDic[@"endpoint"];
            model.bucketName = dataDic[@"bucketname"];
            self.ossModel = model;
            BOOL access = NO;
            if (model.accessKeyId.length > 0) {
                access = YES;
            }
            
            OSSAccess(model, access);
        
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
  }

//利用CCRandomGenerateBytes实现随机字符串的生成
- (NSString *)randomStringWithLength:(NSInteger)length {
    length = length/2;
    unsigned char digest[length];
    CCRNGStatus status = CCRandomGenerateBytes(digest, length);
    NSString *s = nil;
    if (status == kCCSuccess) {
        s = [self stringFrom:digest length:length];
    } else {
        s = @"";
    }
    NSLog(@"randomLength---:%@",s);
    return s;
}

//将bytes转为字符串
- (NSString *)stringFrom:(unsigned char *)digest length:(NSInteger)leng {
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < leng; i++) {
        [string appendFormat:@"%02x",digest[i]];
    }
    NSLog(@"final stringFrom:%@",string);
    return string;
}



- (void)testUploadVideo:(NSData *)videoData success:(SuccessBlock)success failure:(FailBlock)failure {
      OSSModel *model = [[OSSModel alloc] init];
      model.accessKeyId = @"LTAI4FdTMWvYH3RubFF5Pfnu";
      model.accessKeySecret = @"RWpSWJlgUTphWMh5KExXUUL1w8Ee93";
      model.securityToken = @"";  //空
      model.domain = @"motherplanet--test.oss-cn-beijing.aliyuncs.com";
      model.endpoint = @"oss-cn-beijing.aliyuncs.com";
      model.bucketName = @"motherplanet--test";
      model.folder = @"video";
      
      NSString *videoName = [NSString stringWithFormat:@"%@/%@.mp4", model.folder,[self randomStringWithLength:8]];  //  objectKey为云服储存的文件名
      
      OSSPutObjectRequest *put = [OSSPutObjectRequest new];
      put.bucketName = model.bucketName;
      put.objectKey = videoName;

      //---------------------------------------------------------------------
      put.uploadingData = videoData;
      //----------------------------------------------------------------------
     
      // 此处可查看上传进度
      put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
      };
      
      id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:model.accessKeyId secretKeyId:model.accessKeySecret securityToken:@""];
      _client = [[OSSClient alloc] initWithEndpoint:model.endpoint credentialProvider:credential];

      OSSTask * putTask = [self.client putObject:put];  //OSSClient 已经初始化
      [putTask continueWithBlock:^id(OSSTask *task) {
          if (!task.error) {
          NSLog(@"upload object success!");
          
          // 1.拼接url
          // 2.调用后台接口

          } else {
              NSLog(@"upload object failed, error: %@" , task.error);
          }
          return nil;
      }];
      [putTask waitUntilFinished];
      
     //上传成功后获取url
     // sign constrain url
     OSSTask * task = [self.client presignConstrainURLWithBucketName:model.bucketName
                                                       withObjectKey:videoName
                                              withExpirationInterval: 3*365*24*60*60];
     if (!task.error) {
        
     } else {
         NSLog(@"error: %@", task.error);
     }

}

//测试上传方法
- (void)testUploadImage:(UIImage *)image success:(SuccessBlock)success failure:(FailBlock)failure {
    OSSModel *model = [[OSSModel alloc] init];
    model.accessKeyId = @"LTAI4FdTMWvYH3RubFF5Pfnu";
    model.accessKeySecret = @"RWpSWJlgUTphWMh5KExXUUL1w8Ee93";
    model.securityToken = @"";  //空
    model.domain = @"motherplanet--test.oss-cn-beijing.aliyuncs.com";
    model.endpoint = @"oss-cn-beijing.aliyuncs.com";
    model.bucketName = @"motherplanet--test";
    model.folder = @"image";
    
    NSString *imageName = [NSString stringWithFormat:@"%@/%@.jpg", model.folder,[self randomStringWithLength:8]];  //  objectKey为云服储存的文件名
    
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = model.bucketName;
    put.objectKey = imageName;

    
    //---------------------------------------------------------------------
    //    NSData *imageData = UIImagePNGRepresentation(image);
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        put.uploadingData = imageData;
    //----------------------------------------------------------------------
   
    // 此处可查看上传进度
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
      NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:model.accessKeyId secretKeyId:model.accessKeySecret securityToken:@""];
    _client = [[OSSClient alloc] initWithEndpoint:model.endpoint credentialProvider:credential];

    OSSTask * putTask = [self.client putObject:put];  //OSSClient 已经初始化
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
        NSLog(@"upload object success!");
        // 1.拼接url
        // 2.调用后台接口

        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
    [putTask waitUntilFinished];
    
   //上传成功后获取url
   // sign constrain url
   OSSTask * task = [self.client presignConstrainURLWithBucketName:model.bucketName
                                                withObjectKey:imageName
                                       withExpirationInterval: 3*365*24*60*60];
   if (!task.error) {
       
      
   } else {
       NSLog(@"error: %@", task.error);
   }
    
}


@end
