//
//  UserInfoTools.h
//  MotherStar
//
//  Created by 王家辉 on 2019/12/21.
//  Copyright © 2019年 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoTools : NSObject
+ (void)setToken:(NSString *)token;
+ (NSString *)getToken;
@end

NS_ASSUME_NONNULL_END
