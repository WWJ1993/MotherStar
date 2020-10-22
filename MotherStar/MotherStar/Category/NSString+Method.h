//
//  NSString+Method.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/19.
//  Copyright © 2019 yanming niu. All rights reserved.
//

//#import <AppKit/AppKit.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Method)

- (NSMutableAttributedString *)setStringToAttributedString:(NSString *)string
                                                      font:(UIFont *)font
                                                     color:(UIColor *)color;

- (NSMutableAttributedString *)setMutliString:(NSArray <NSDictionary *> *)array;

/* 获取当前时间戳 */
+ (NSString *)getCurrentTimestamp;

/* 获取视频总时长 */
+ (NSString *)getVideoDuration:(NSURL *)url;

/* Null字符串判断 - 替换空字符串 */
+ (NSString *)nullToString:(id)string;

@end

NS_ASSUME_NONNULL_END
