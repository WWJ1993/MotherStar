//
//  UIColor+Hex.h
//  ZhanLuYueDu
//
//  Created by 杨文娟 on 2017/7/6.
//  Copyright © 2020年 杨文娟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
