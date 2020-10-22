//
//  GlobalHandle.h
//  MotherStar
//
//  Created by yanming niu on 2020/2/5.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlobalHandle : NSObject

/* 对热门脑洞的数据解析和处理 */
+ (NSDictionary *)handleBrainholeContent:(BOOL)isOriginal
                                   title:(NSString *)title
                                 content:(NSString *)content;

/* 获取个人信息 */
+ (void)getUserInfo;
+ (NSArray *)filterTextFromHTML:(NSString *)html;

/* 验证是否登录 */
+ (BOOL)isLoginUser;

@end

NS_ASSUME_NONNULL_END
