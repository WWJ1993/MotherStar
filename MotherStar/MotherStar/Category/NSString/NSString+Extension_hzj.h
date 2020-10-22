//
//  NSString+Extension_hzj.h
//  FitnessCoachCenter
//
//  Created by ZhijunHu on 2019/7/3.
//  Copyright © 2019 胡志军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension_hzj)
- (NSString *)safeSubstringFromIndex:(NSUInteger)from;

- (NSString *)safeSubstringToIndex:(NSUInteger)to;

- (NSString *)safeSubstringWithRange:(NSRange)range;

- (NSRange)safeRangeOfString:(NSString *)aString;

- (NSRange)safeRangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask;

- (NSString *)safeStringByAppendingString:(NSString *)aString;

- (id)safeInitWithString:(NSString *)aString;

+ (id)safeStringWithString:(NSString *)string;

#pragma mark - Extension
//脱敏
-(NSString *)desensitizationName:(NSString *)name;
-(NSString *)desensitizationOcrIDcard:(NSString *)idcard;

/**
 获取哈希值
 */
-(NSString *)sha1;

/**
 获取mad5值
 */
- (NSString *)md5;

#pragma mark - tools
/**
 这是用来创建一个科学技术法的字符串的一个类方法
 
 @return 返回一个表示科学计数法的字符串 （比如：当前字符串 1234   返回： 1,234.00）
 */
- (NSString *)formatScientificNumber;

/**
 去空格
 
 @return self
 */
- (NSString *)deleteSpace;

/**
 替换指定位置字符串
 
 @param str 替换的字符串
 @param range 位置
 @return 替换后的字符串
 */
- (NSString *)replaceStr:(NSString *)str range:(NSRange)range;

//拼接字符串  在前 和在后拼接
- (NSString *)addFirstStr:(NSString *)str;
- (NSString *)addLastStr:(NSString *)str;
/**
 保证字符串非空
 
 @return 非空字符串
 */
- (NSString *)formatNilToEmptyString;

/**
 根据字符串字体大小和最大size
 
 @param font 字体
 @param maxSize 最大size
 @return 当前字符串大小
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 获取字符串的首字符
 
 @return 字符串第一个字符，若为空则返回空字符串
 */
- (NSString *)firstString;

//字符编码
- (NSString *)sendStr; //发送🤒
- (NSString *)showStr;//展示🤒

//检查字符串是否包含pattern
- (BOOL)stringCheckingWithPattern:(NSString *)pattern;

//判断是否是安全字符串 --非空
-(BOOL)isValidString;
+ (BOOL)isValidWithString:(id)str;
/**
 判断字符串是否是手机号
 @return YES/NO
 */
- (BOOL)isMobileNumber;
//判断是否是邮箱
- (BOOL)isEmail;
//判断密码是否符合要求
- (BOOL)isPassWord;
//判断身份证是否合法
- (BOOL)isIDCard;
- (BOOL)isCode;
//获取字符串的宽度
- (CGFloat)getWidthWithFont:(UIFont *)font;
- (CGFloat)getHeightWithWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;


- (NSString *)textFeildMaxLenght:(int)lenght;

- (NSString *)deleteSpaceComma;
//字符串转 日期
- (NSDate *)stringToDataWithFormatter:(NSString *)ft;
- (NSDictionary *)stringToDictionary;
+ (NSString *)dictionaryToString:(NSDictionary *)dic;


//生成指定位数的随机字符串
+(NSString *)randomStringWithLength:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
