//
//  UserInfoTools.m
//  MotherStar
//
//  Created by 王家辉 on 2019/12/21.
//  Copyright © 2019年 yanming niu. All rights reserved.
//

#import "UserInfoTools.h"

@implementation UserInfoTools
+ (BOOL)setToken:(NSString *)token{
    if (token) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:token forKey:@"token"];
        return [userDefaults synchronize];
    }
    return NO;
}
+ (NSString *)getToken{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    return token?token:@"";
}
@end
