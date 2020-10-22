//
//  NString+Method.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/19.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "NSString+Method.h"
#import <AVFoundation/AVFoundation.h>

//#import <AppKit/AppKit.h>


@implementation NSString (Method)

- (NSMutableAttributedString *)setStringToAttributedString:(NSString *)string
                                                      font:(UIFont *)font
                                                     color:(UIColor *)color {
    NSRange range = [self rangeOfString:string options:NSBackwardsSearch];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
     [attString setAttributes:@{  NSFontAttributeName:font, NSForegroundColorAttributeName:color } range:range];
    return attString;
}

- (NSMutableAttributedString *)setMutliString:(NSArray <NSDictionary *> *)array {
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:@""];
    for (NSInteger i = 0; i < array.count; i++) {
        NSString *string = array[i][@"string"];
        UIFont *font = array[i][@"font"];
        UIColor *color = array[i][@"color"];
        NSMutableAttributedString *subAttString = [string setStringToAttributedString:string font:font color:color];
        
        [attString appendAttributedString:subAttString];
    }
    return attString;
}

- (NSMutableAttributedString *)setMutliStringContainAttach:(NSArray <NSDictionary *> *)array {
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:@""];
    for (NSInteger i = 0; i < array.count; i++) {
        NSString *string = array[i][@"string"];
        UIFont *font = array[i][@"font"];
        UIColor *color = array[i][@"color"];
        NSMutableAttributedString *subAttString = [string setStringToAttributedString:string font:font color:color];
        
        [attString appendAttributedString:subAttString];
    }
    return attString;
}



//获取当前时间戳
+ (NSString *)getCurrentTimestamp {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

+ (NSString *)getVideoDuration:(NSURL *)url {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]                                                                              forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    // 初始化视频媒体文件
    NSInteger minute = 0, second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale;

    // 获取视频总时长,单位秒
    if (second >= 60) {
        NSInteger index = second / 60;
        minute = index;
        second = second - index * 60;
    }
    NSString *duration = [NSString stringWithFormat:@"%li:%li",minute, second];
    return duration;
    
}

/* Null字符串判断 - 替换空字符串 */
+ (NSString *)nullToString:(id)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return @"";
    } else {
        return (NSString *)string;
    }
}

@end
