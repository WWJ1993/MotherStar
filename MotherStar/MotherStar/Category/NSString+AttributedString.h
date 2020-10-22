//
//  NSString+AttributedString.h
//  GoodReputationSunshine
//
//  Created by 胡志军 on 2019/9/25.
//  Copyright © 2019年 胡志军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AttributedString)

/* 设置单字符串 */
- (NSMutableAttributedString *)setStringToAttributedString:(NSString *)string
                                                      font:(UIFont *)font
                                                     color:(UIColor *)color;

/* 设置多字符串 */
- (NSMutableAttributedString *)setMutliString:(NSArray <NSDictionary *> *)array;



//把字符串 转为NSMutableAttributedString
- (NSMutableAttributedString*)mutableAttributedString;
//添加字体和颜色
+ (void)changeAttributed:(NSMutableAttributedString*)attStr setSubStringFont:(UIFont*)font Color:(UIColor *)color range:(NSRange)range;

//单独改变字符串中指定字符的颜色和font
- (NSMutableAttributedString *)changeSubStirng:(NSString*)subStr font:(UIFont *)font color:(UIColor *)color;

//改变行间距 和字间距
-(NSMutableAttributedString *)changeLineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace;
//改变行间距
- (NSMutableAttributedString *)changeLineSpace:(CGFloat)lineSpace;
//添加删除线
- (NSMutableAttributedString*)addDelegateLineWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
