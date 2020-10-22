//
//  RequestHandle.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/5.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "RequestHandle.h"


@interface RequestHandle () {
//    RequestManager *manager;
}

@end

@implementation RequestHandle

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        manager = [RequestManager sharedInstance];
//    }
//    return self;
//}

#pragma mark -- 登录 - 注册 - 修改密码 --

+ (void)requestVerificationSendCode:(NSDictionary *)param success:(SuccessBlock)success
                                                         fail:(FailBlock)fail {
    NSString *requestCode = [BaseUrl stringByAppendingFormat:@"/sms/send"];
    [[RequestManager sharedInstance] POST:requestCode params:param authorization:@"" progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

+ (void)requestVerificationCode:(NSDictionary *)param success:(SuccessBlock)success
                                                         fail:(FailBlock)fail {
    NSString *requestCode = [BaseUrl stringByAppendingFormat:@"/sms/sendFindPassWord"];
    [[RequestManager sharedInstance] POST:requestCode params:param authorization:@"" progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

+ (void)requestVerificationThreeCode:(NSDictionary *)param success:(SuccessBlock)success
                                                         fail:(FailBlock)fail {
    NSString *requestCode = [BaseUrl stringByAppendingFormat:@"/sms/threeSend"];
    [[RequestManager sharedInstance] POST:requestCode params:param authorization:@"" progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

//
+ (void)threeRegist:(NSDictionary *)param success:(SuccessBlock)success
                                        fail:(FailBlock)fail {
    NSString *registUrl = [BaseUrl stringByAppendingFormat:@"/user/threeRegist"];
    [[RequestManager sharedInstance] POST:registUrl params:param authorization:@""
      progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}


+ (void)regist:(NSDictionary *)param success:(SuccessBlock)success
                                        fail:(FailBlock)fail {
    NSString *registUrl = [BaseUrl stringByAppendingFormat:@"/user/regist"];
    [[RequestManager sharedInstance] POST:registUrl params:param authorization:@""
      progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

+ (void)login:(NSDictionary *)param success:(SuccessBlock)success
                                             fail:(FailBlock)fail {
    NSString *loginUrl = [BaseUrl stringByAppendingFormat:@"/user/login"];
    [[RequestManager sharedInstance] POST:loginUrl params:param authorization:@"" progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);

    }];
}

+ (void)otherLogin:(NSDictionary *)param success:(SuccessBlock)success
                                             fail:(FailBlock)fail {
    NSString *loginUrl = [BaseUrl stringByAppendingFormat:@"/user/threeLogin"];
    [[RequestManager sharedInstance] POST:loginUrl params:param authorization:@"" progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);

    }];
}

/* 修改密码 */
+ (void)upPassword:(NSDictionary *)param success:(SuccessBlock)success
          fail:(FailBlock)fail {
    NSString *loginUrl = [BaseUrl stringByAppendingFormat:@"/user/upPassword"];
    [[RequestManager sharedInstance] POST:loginUrl params:param authorization:@"" progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}


#pragma mark -- 首页 - STAR --

+ (void)getCycleList:(SuccessBlock)success fail:(FailBlock)fail {
    NSString *cycleUrl = [BaseUrl stringByAppendingFormat:@"/banner/list"];
    [[RequestManager sharedInstance] GET:cycleUrl parameters:@{} authorization:@"" progress:^(NSProgress * _Nonnull progress) {
    
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

+ (void)getStarsList:(SuccessBlock)success fail:(FailBlock)fail {
    NSString *planetsUrl = [BaseUrl stringByAppendingFormat:@"/tag/tag/list"];
    [[RequestManager sharedInstance] GET:planetsUrl parameters:@{} authorization:@"" progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

+ (void)getHotBrainholeList:(NSDictionary *)param success:(SuccessBlock)success
                                                     fail:(FailBlock)fail {
    NSString *hotUrl = [BaseUrl stringByAppendingFormat:@"/post/hot-list"];
    [[RequestManager sharedInstance] GET:hotUrl parameters:param authorization:@"" progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

/* 查看脑洞详情 */

+ (void)getBrainholeDetails:(NSDictionary *)param authorization:(NSString *)token
                                                        success:(SuccessBlock)success
                                                           fail:(FailBlock)fail {
//    NSString *detailsUrl = [BaseUrl stringByAppendingFormat:@"/post/postDetails"];
    NSString *detailsUrl = [BaseUrl stringByAppendingFormat:@"/post/postDetailsIOS"];

     [[RequestManager sharedInstance] GET:detailsUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
       } success:^(id  _Nullable response) {
           success(response);
       } failure:^(NSError * _Nonnull error) {
           fail(error);
     }];
}

/* 查看视频详情 */
+ (void)getVideoDetails:(NSDictionary *)param authorization:(NSString *)token
                                                    success:(SuccessBlock)success
                                                       fail:(FailBlock)fail {
    NSString *videoUrl = [BaseUrl stringByAppendingFormat:@"/post/videoDetails"];
     [[RequestManager sharedInstance] GET:videoUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
       } success:^(id  _Nullable response) {
           success(response);
       } failure:^(NSError * _Nonnull error) {
           fail(error);
     }];
}

/* 查看星球详情 */
+ (void)getStarDetails:(NSDictionary *)param authorization:(NSString *)token
                                                   success:(SuccessBlock)success
                                                      fail:(FailBlock)fail {
    NSString *starUrl = [BaseUrl stringByAppendingFormat:@"/post/starById"];
     [[RequestManager sharedInstance] GET:starUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
       } success:^(id  _Nullable response) {
           success(response);
       } failure:^(NSError * _Nonnull error) {
           fail(error);
     }];
}

/* 查看标签详情 */
+ (void)getTagDetails:(NSDictionary *)param authorization:(NSString *)token
                                                   success:(SuccessBlock)success
                                                      fail:(FailBlock)fail {
    NSString *tagUrl = [BaseUrl stringByAppendingFormat:@"/post/tagById"];
     [[RequestManager sharedInstance] GET:tagUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
       } success:^(id  _Nullable response) {
           success(response);
       } failure:^(NSError * _Nonnull error) {
           fail(error);
     }];
}

/* 标签下的帖子列表 */
+ (void)getBrainholeListBelongsToTag:(NSDictionary *)param authorization:(NSString *)token
                                                   success:(SuccessBlock)success
                                                      fail:(FailBlock)fail {
    NSString *bListUrl = [BaseUrl stringByAppendingFormat:@"/post/tagDetails"];
    [[RequestManager sharedInstance] GET:bListUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
       } success:^(id  _Nullable response) {
           success(response);
       } failure:^(NSError * _Nonnull error) {
           fail(error);
     }];
}

/* 获取加油榜 - 脑洞 */
+ (void)getGetFuelUserlist:(NSDictionary *)param authorization:(NSString *)token
                                                   success:(SuccessBlock)success
                                                      fail:(FailBlock)fail {
    NSString *fuelListUrl = [BaseUrl stringByAppendingFormat:@"/integral/getOilPostList"];
     [[RequestManager sharedInstance] GET:fuelListUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
       } success:^(id  _Nullable response) {
           success(response);
       } failure:^(NSError * _Nonnull error) {
           fail(error);
     }];
}

/* 获取加油榜 - 视频 */
+ (void)getVideoFuelUserlist:(NSDictionary *)param authorization:(NSString *)token
                                                   success:(SuccessBlock)success
                                                      fail:(FailBlock)fail {
    NSString *videoFuelListUrl = [BaseUrl stringByAppendingFormat:@"/integral/getOilVideoList"];
     [[RequestManager sharedInstance] GET:videoFuelListUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
       } success:^(id  _Nullable response) {
           success(response);
       } failure:^(NSError * _Nonnull error) {
           fail(error);
     }];
}

/* 获取加油总人数 */
+ (void)getGetFuellistNum:(NSDictionary *)param authorization:(NSString *)token
                                                   success:(SuccessBlock)success
                                                      fail:(FailBlock)fail {
    NSString *fuelListNumUrl = [BaseUrl stringByAppendingFormat:@"/integral/getOilListNum"];
     [[RequestManager sharedInstance] GET:fuelListNumUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
       } success:^(id  _Nullable response) {
           success(response);
       } failure:^(NSError * _Nonnull error) {
           fail(error);
     }];
}

/* 查看脑洞评论 */
+ (void)getCommentList:(NSDictionary *)param authorization:(NSString *)token                                                                                            success:(SuccessBlock)success
                                                      fail:(FailBlock)fail {
    NSString *commentUrl = [BaseUrl stringByAppendingFormat:@"/post/postComment"];
    [[RequestManager sharedInstance] GET:commentUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

/* 点赞 */
+ (void)likeForBrainhole:(NSDictionary *)param authorization:(NSString *)token
                                           uploadProgress:(ProgressBlock)uploadProgress
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail {
    NSString *likeUrl = [BaseUrl stringByAppendingFormat:@"/post/like"];
    [[RequestManager sharedInstance] GET:likeUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

/* 发布评论 - 脑洞 */
+ (void)postBrainholeComment:(NSDictionary *)param authorization:(NSString *)token
                                           uploadProgress:(ProgressBlock)uploadProgress
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail {
    NSString *brainholeCommentUrl = [BaseUrl stringByAppendingFormat:@"/comment/insertPost"];
    [[RequestManager sharedInstance] POST:brainholeCommentUrl params:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        uploadProgress(progress);
      } success:^(id  _Nullable response) {
          success(response);
      } failure:^(NSError * _Nonnull error) {
          fail(error);
      }];
}

/* 发布评论 - 视频 */
+ (void)postBrainholeVideoComment:(NSDictionary *)param authorization:(NSString *)token
                                           uploadProgress:(ProgressBlock)uploadProgress
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail {
    NSString *brainholeVideoCommentUrl = [BaseUrl stringByAppendingFormat:@"/comment/insertVideo"];
    [[RequestManager sharedInstance] POST:brainholeVideoCommentUrl params:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        uploadProgress(progress);
      } success:^(id  _Nullable response) {
          success(response);
      } failure:^(NSError * _Nonnull error) {
          fail(error);
      }];
}

/* 上传视频 */
+ (void)uploadVideo:(NSDictionary *)param authorization:(NSString *)token
                                           uploadProgress:(ProgressBlock)uploadProgress
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail {
    NSString *uploadVideoUrl = [BaseUrl stringByAppendingFormat:@"/post/issueVideo"];
    [[RequestManager sharedInstance] POST:uploadVideoUrl params:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        uploadProgress(progress);
      } success:^(id  _Nullable response) {
          success(response);
      } failure:^(NSError * _Nonnull error) {
          fail(error);
      }];
}

/* 加油 */
+ (void)addFuel:(NSDictionary *)param authorization:(NSString *)token
                                     uploadProgress:(ProgressBlock)uploadProgress
                                            success:(SuccessBlock)success
                                               fail:(FailBlock)fail {
    NSString *getFuelUrl = [BaseUrl stringByAppendingFormat:@"/user/updateOil"];
    [[RequestManager sharedInstance] POST:getFuelUrl params:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        uploadProgress(progress);
      } success:^(id  _Nullable response) {
          success(response);
      } failure:^(NSError * _Nonnull error) {
          fail(error);
      }];
}

/* 评论点赞 */
+ (void)likeForComment:(NSDictionary *)param authorization:(NSString *)token
                                           uploadProgress:(ProgressBlock)uploadProgress
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail {
    NSString *likeCommentUrl = [BaseUrl stringByAppendingFormat:@"/comment/commentThumbs"];
    [[RequestManager sharedInstance] GET:likeCommentUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

/* 脑洞评论查询 */
+ (void)requestBrainholeComment:(NSDictionary *)param authorization:(NSString *)token
                                           uploadProgress:(ProgressBlock)uploadProgress
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail {
    NSString *brainholeCommentUrl = [BaseUrl stringByAppendingFormat:@"/comment/getcommentList"];
    [[RequestManager sharedInstance] GET:brainholeCommentUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

/* 脑洞视频评论查询 */
+ (void)requestBrainholeVideoComment:(NSDictionary *)param authorization:(NSString *)token
                                           uploadProgress:(ProgressBlock)uploadProgress
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail {
    NSString *brainholeVideoCommentUrl = [BaseUrl stringByAppendingFormat:@"/comment/getcommentVideoList"];
    [[RequestManager sharedInstance] GET:brainholeVideoCommentUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

/* 分享 */
+ (void)shareBrainhole:(NSDictionary *)param authorization:(NSString *)token
                                           uploadProgress:(ProgressBlock)uploadProgress
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail {
    NSString *shareUrl = [BaseUrl stringByAppendingFormat:@"/post/shairPost"];
    [[RequestManager sharedInstance] GET:shareUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}


#pragma mark -- 发布脑洞  --

+ (void)postBrainhole:(NSDictionary *)param authorization:(NSString *)token
                                           uploadProgress:(ProgressBlock)uploadProgress
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail {
    NSString *postUrl = [BaseUrl stringByAppendingFormat:@"/post/issuePost"];
    [[RequestManager sharedInstance] POST:postUrl params:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        uploadProgress(progress);
      } success:^(id  _Nullable response) {
          success(response);
      } failure:^(NSError * _Nonnull error) {
          fail(error);
      }];
}

#pragma mark -- 我的  --

/* 获取用户信息 */
+ (void)getUserInfo:(NSDictionary *)param authorization:(NSString *)token
                                           uploadProgress:(ProgressBlock)uploadProgress
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail {
    NSString *userUrl = [BaseUrl stringByAppendingFormat:@"/user/searchUser"];
    [[RequestManager sharedInstance] GET:userUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

/* 我的发布内容- 脑洞和视频 */
+ (void)requestMinePostContent:(NSDictionary *)param authorization:(NSString *)token
                                                uploadProgress:(ProgressBlock)uploadProgress
                                                       success:(SuccessBlock)success
                                                          fail:(FailBlock)fail {
    NSString *minePostContentUrl = [BaseUrl stringByAppendingFormat:@"/user/searchIssueVideo"];
    [[RequestManager sharedInstance] GET:minePostContentUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}


/* 我的发布总数 - 脑洞和视频 */
+ (void)requestMinePostSum:(NSDictionary *)param authorization:(NSString *)token
                                                uploadProgress:(ProgressBlock)uploadProgress
                                                       success:(SuccessBlock)success
                                                          fail:(FailBlock)fail {
    NSString *minePostSumUrl = [BaseUrl stringByAppendingFormat:@"/user/getCalendarNum"];
    [[RequestManager sharedInstance] GET:minePostSumUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

/* 我的喜欢 */
+ (void)requestMineLikeList:(NSDictionary *)param
                       authorization:(NSString *)token
                      uploadProgress:(ProgressBlock)uploadProgress
                             success:(SuccessBlock)success
                                fail:(FailBlock)fail {
    NSString *minelikeUrl = [BaseUrl stringByAppendingFormat:@"/post/myLike"];
    [[RequestManager sharedInstance] GET:minelikeUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

+ (void)signOut:(NSDictionary *)param authorization:(NSString *)token
       progress:(ProgressBlock)progressBlock
        success:(SuccessBlock)success
           fail:(FailBlock)fail{
    
    NSString *loginUrl = [BaseUrl stringByAppendingFormat:@"/user/outlogin"];
    [[RequestManager sharedInstance] POST:loginUrl params:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
        
    }];
    
}

+ (void)myIntegralList:(NSDictionary *)param authorization:(NSString *)token
              progress:(ProgressBlock)progressBlock
               success:(SuccessBlock)success
                  fail:(FailBlock)fail{
    
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/integral/myIntegralList"];
    [[RequestManager sharedInstance] GET:Url parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
    
}

+ (void)getCalendarMonth:(NSDictionary *)param authorization:(NSString *)token
                progress:(ProgressBlock)progressBlock
                 success:(SuccessBlock)success
                    fail:(FailBlock)fail{
    
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/user/getCalendarMonth"];
    [[RequestManager sharedInstance] GET:Url parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

+ (void)getCalendar:(NSDictionary *)param authorization:(NSString *)token
           progress:(ProgressBlock)progressBlock
            success:(SuccessBlock)success
               fail:(FailBlock)fail{
    
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/user/getCalendar"];
    [[RequestManager sharedInstance] GET:Url parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

+ (void)searchUser:(NSDictionary *)param authorization:(NSString *)token
          progress:(ProgressBlock)progressBlock
           success:(SuccessBlock)success
              fail:(FailBlock)fail{
    
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/user/searchUser"];
    [[RequestManager sharedInstance] GET:Url parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
    
    
    
}


+ (void)update:(NSDictionary *)param authorization:(NSString *)token
      progress:(ProgressBlock)progressBlock
       success:(SuccessBlock)success
          fail:(FailBlock)fail{
    
    NSString *loginUrl = [BaseUrl stringByAppendingFormat:@"/user/update"];
    [[RequestManager sharedInstance] POST:loginUrl params:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}




+ (void)updatelogo:(NSDictionary *)param authorization:(NSString *)token
          progress:(ProgressBlock)progressBlock
           success:(SuccessBlock)success
              fail:(FailBlock)fail{
    
    NSString *loginUrl = [BaseUrl stringByAppendingFormat:@"/user/update-logo"];
    [[RequestManager sharedInstance] POST:loginUrl params:param authorization:@"" progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

+ (void)getCalendarNum:(NSDictionary *)param authorization:(NSString *)token
              progress:(ProgressBlock)progressBlock
               success:(SuccessBlock)success
                  fail:(FailBlock)fail{
    
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/user/getCalendarNum"];
    [[RequestManager sharedInstance] GET:Url parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

+ (void)getMyOilNum:(NSDictionary *)param authorization:(NSString *)token
           progress:(ProgressBlock)progressBlock
            success:(SuccessBlock)success
               fail:(FailBlock)fail{
    
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/user/getMyOilNum"];
    [[RequestManager sharedInstance] GET:Url parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
    
}

+ (void)searchTask:(NSDictionary *)param authorization:(NSString *)token
          progress:(ProgressBlock)progressBlock
           success:(SuccessBlock)success
              fail:(FailBlock)fail{
    
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/task/searchTask"];
    [[RequestManager sharedInstance] GET:Url parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
    
}

+ (void)getOil:(NSDictionary *)param authorization:(NSString *)token
      progress:(ProgressBlock)progressBlock
       success:(SuccessBlock)success
          fail:(FailBlock)fail{
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/task/getOil"];
    [[RequestManager sharedInstance] GET:Url parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
    
    
}


+ (void)getOilPostList:(NSDictionary *)param authorization:(NSString *)token
              progress:(ProgressBlock)progressBlock
               success:(SuccessBlock)success
                  fail:(FailBlock)fail{
    
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/integral/getOilPostList"];
    [[RequestManager sharedInstance] GET:Url parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

+ (void)getOilVideoList:(NSDictionary *)param authorization:(NSString *)token
               progress:(ProgressBlock)progressBlock
                success:(SuccessBlock)success
                   fail:(FailBlock)fail{
    
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/integral/getOilVideoList"];
    [[RequestManager sharedInstance] GET:Url parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);
    }];
}

+ (void)threeRegist:(NSDictionary *)param authorization:(NSString *)token
progress:(ProgressBlock)progressBlock
 success:(SuccessBlock)success
               fail:(FailBlock)fail{
    
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/user/threeRegist"];
    [[RequestManager sharedInstance] POST:Url params:param authorization:token progress:progressBlock success:^(id  _Nullable response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        fail(error);

    }];
    
    
}



@end
