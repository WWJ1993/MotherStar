//
//  RequestHandle.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/5.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface RequestHandle : NSObject

#pragma mark -- 登录 注册  --
//注册
+ (void)requestVerificationSendCode:(NSDictionary *)param success:(SuccessBlock)success fail:(FailBlock)fail;;

/* 发送验证码 */
+ (void)requestVerificationCode:(NSDictionary *)param success:(SuccessBlock)success
                                                          fail:(FailBlock)fail;

/* 注册 */
+ (void)regist:(NSDictionary *)param success:(SuccessBlock)success
                                        fail:(FailBlock)fail;
/*三方注册*/
+ (void)threeRegist:(NSDictionary *)param success:(SuccessBlock)success
               fail:(FailBlock)fail ;
/* 登录 */
+ (void)login:(NSDictionary *)param success:(SuccessBlock)success
                                             fail:(FailBlock)fail;
+ (void)otherLogin:(NSDictionary *)param success:(SuccessBlock)success
              fail:(FailBlock)fail ;
//修改密码
+ (void)upPassword:(NSDictionary *)param success:(SuccessBlock)success
              fail:(FailBlock)fail ;

#pragma mark -- 首页  --


/* 获取轮播列表 */
+ (void)getCycleList:(SuccessBlock)success fail:(FailBlock)fail;

/* 获取星球列表 */
+ (void)getStarsList:(SuccessBlock)success fail:(FailBlock)fail;

/* 获取热门脑洞列表 */
+ (void)getHotBrainholeList:(NSDictionary *)param success:(SuccessBlock)success
                                                     fail:(FailBlock)fail;

/* 查看脑洞详情 */
+ (void)getBrainholeDetails:(NSDictionary *)param authorization:(NSString *)token
                                                        success:(SuccessBlock)success
                                                           fail:(FailBlock)fail;


/* 查看视频详情 */
+ (void)getVideoDetails:(NSDictionary *)param authorization:(NSString *)token
                                                    success:(SuccessBlock)success
                                                       fail:(FailBlock)fail;

/* 查看星球详情 */
+ (void)getStarDetails:(NSDictionary *)param authorization:(NSString *)token
                                                   success:(SuccessBlock)success
                                                      fail:(FailBlock)fail;
/* 查看标签详情 */
+ (void)getTagDetails:(NSDictionary *)param authorization:(NSString *)token
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail;

/* 标签下的帖子列表 */
+ (void)getBrainholeListBelongsToTag:(NSDictionary *)param authorization:(NSString *)token
                                                   success:(SuccessBlock)success
                                                      fail:(FailBlock)fail;

/* 获取加油榜 */
+ (void)getGetFuelUserlist:(NSDictionary *)param authorization:(NSString *)token
                                                   success:(SuccessBlock)success
                                                      fail:(FailBlock)fail;

/* 获取加油榜 - 视频 */
+ (void)getVideoFuelUserlist:(NSDictionary *)param authorization:(NSString *)token
                                                   success:(SuccessBlock)success
                                                      fail:(FailBlock)fail;

/* 获取加油总人数 */
+ (void)getGetFuellistNum:(NSDictionary *)param authorization:(NSString *)token
                                                   success:(SuccessBlock)success
                                                      fail:(FailBlock)fail;
/* 获取评论列表 */
+ (void)getCommentList:(NSDictionary *)param authorization:(NSString *)token                                                                                            success:(SuccessBlock)success
                                                      fail:(FailBlock)fail;


/* 点赞 */
+ (void)likeForBrainhole:(NSDictionary *)param authorization:(NSString *)token
                                              uploadProgress:(ProgressBlock)uploadProgress
                                                     success:(SuccessBlock)success
                                                        fail:(FailBlock)fail;
/* 分享 */
+ (void)shareBrainhole:(NSDictionary *)param authorization:(NSString *)token
                                            uploadProgress:(ProgressBlock)uploadProgress
                                                   success:(SuccessBlock)success
                                                      fail:(FailBlock)fail;

/* 发布评论 - 脑洞 */
+ (void)postBrainholeComment:(NSDictionary *)param authorization:(NSString *)token
                                                  uploadProgress:(ProgressBlock)uploadProgress
                                                         success:(SuccessBlock)success
                                                            fail:(FailBlock)fail;

/* 发布评论 - 视频 */
+ (void)postBrainholeVideoComment:(NSDictionary *)param authorization:(NSString *)token
                                                       uploadProgress:(ProgressBlock)uploadProgress
                                                              success:(SuccessBlock)success
                                                                 fail:(FailBlock)fail;

/* 上传视频 */
+ (void)uploadVideo:(NSDictionary *)param authorization:(NSString *)token
                                         uploadProgress:(ProgressBlock)uploadProgress
                                                success:(SuccessBlock)success
                                                   fail:(FailBlock)fail;

/* 加油 */
+ (void)addFuel:(NSDictionary *)param authorization:(NSString *)token
                                     uploadProgress:(ProgressBlock)uploadProgress
                                            success:(SuccessBlock)success
                                               fail:(FailBlock)fail;

/* 评论点赞 */
+ (void)likeForComment:(NSDictionary *)param authorization:(NSString *)token
                                           uploadProgress:(ProgressBlock)uploadProgress
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail;
/* 脑洞评论查询 */
+ (void)requestBrainholeComment:(NSDictionary *)param authorization:(NSString *)token
                                                     uploadProgress:(ProgressBlock)uploadProgress
                                                            success:(SuccessBlock)success
                                                               fail:(FailBlock)fail;

/* 脑洞视频评论查询 */
+ (void)requestBrainholeVideoComment:(NSDictionary *)param authorization:(NSString *)token
                                           uploadProgress:(ProgressBlock)uploadProgress
                                                  success:(SuccessBlock)success
                                                     fail:(FailBlock)fail;

/* 获取用户信息 */
+ (void)getUserInfo:(NSDictionary *)param authorization:(NSString *)token
                                         uploadProgress:(ProgressBlock)uploadProgress
                                                success:(SuccessBlock)success
                                                   fail:(FailBlock)fail;


#pragma mark -- 发布脑洞  --

/* 发布脑洞 */
+ (void)postBrainhole:(NSDictionary *)param
        authorization:(NSString *)token
       uploadProgress:(ProgressBlock)uploadProgress
              success:(SuccessBlock)success
                 fail:(FailBlock)fail;

#pragma mark -- 我的  --

/* 我的发布内容- 脑洞和视频 */
+ (void)requestMinePostContent:(NSDictionary *)param authorization:(NSString *)token
                                                uploadProgress:(ProgressBlock)uploadProgress
                                                       success:(SuccessBlock)success
                                                          fail:(FailBlock)fail;

/* 我的发布总数 - 脑洞和视频 */
+ (void)requestMinePostSum:(NSDictionary *)param authorization:(NSString *)token
                                                uploadProgress:(ProgressBlock)uploadProgress
                                                       success:(SuccessBlock)success
                                                          fail:(FailBlock)fail;

/* 我的喜欢 */
+ (void)requestMineLikeList:(NSDictionary *)param
                       authorization:(NSString *)token
                      uploadProgress:(ProgressBlock)uploadProgress
                             success:(SuccessBlock)success
                                fail:(FailBlock)fail;

+ (void)signOut:(NSDictionary *)param authorization:(NSString *)token
       progress:(ProgressBlock)progressBlock
        success:(SuccessBlock)success
           fail:(FailBlock)fail;

//我的燃料获得和消费列表
+ (void)myIntegralList:(NSDictionary *)param authorization:(NSString *)token
              progress:(ProgressBlock)progressBlock
               success:(SuccessBlock)success
                  fail:(FailBlock)fail;

//数据日历按月查询

+ (void)getCalendarMonth:(NSDictionary *)param authorization:(NSString *)token
                progress:(ProgressBlock)progressBlock
                 success:(SuccessBlock)success
                    fail:(FailBlock)fail;


//数据日历

+ (void)getCalendar:(NSDictionary *)param authorization:(NSString *)token
           progress:(ProgressBlock)progressBlock
            success:(SuccessBlock)success
               fail:(FailBlock)fail;

//用户信息查询
+ (void)searchUser:(NSDictionary *)param authorization:(NSString *)token
          progress:(ProgressBlock)progressBlock
           success:(SuccessBlock)success
              fail:(FailBlock)fail;

//修改个人用户信息
+ (void)update:(NSDictionary *)param authorization:(NSString *)token
      progress:(ProgressBlock)progressBlock
       success:(SuccessBlock)success
          fail:(FailBlock)fail;

//获取我的发布总数
+ (void)getCalendarNum:(NSDictionary *)param authorization:(NSString *)token
              progress:(ProgressBlock)progressBlock
               success:(SuccessBlock)success
                  fail:(FailBlock)fail;
//获取助燃总数
+ (void)getMyOilNum:(NSDictionary *)param authorization:(NSString *)token
           progress:(ProgressBlock)progressBlock
            success:(SuccessBlock)success
               fail:(FailBlock)fail;
//加油站相关查询
+ (void)searchTask:(NSDictionary *)param authorization:(NSString *)token
          progress:(ProgressBlock)progressBlock
           success:(SuccessBlock)success
              fail:(FailBlock)fail;

//加油站领取燃料
+ (void)getOil:(NSDictionary *)param authorization:(NSString *)token
      progress:(ProgressBlock)progressBlock
       success:(SuccessBlock)success
          fail:(FailBlock)fail;
//帖子的加油榜
+ (void)getOilPostList:(NSDictionary *)param authorization:(NSString *)token
              progress:(ProgressBlock)progressBlock
               success:(SuccessBlock)success
                  fail:(FailBlock)fail;


//视频的加油榜
+ (void)getOilVideoList:(NSDictionary *)param authorization:(NSString *)token
               progress:(ProgressBlock)progressBlock
                success:(SuccessBlock)success
                   fail:(FailBlock)fail;
//第三方发送验证码
+ (void)requestVerificationThreeCode:(NSDictionary *)param success:(SuccessBlock)success                                              fail:(FailBlock)fail ;




//添加绑定
+ (void)threeRegist:(NSDictionary *)param authorization:(NSString *)token
               progress:(ProgressBlock)progressBlock
                success:(SuccessBlock)success
                   fail:(FailBlock)fail;

@end

NS_ASSUME_NONNULL_END
