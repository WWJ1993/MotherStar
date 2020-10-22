//
//  NSString+Extension_hzj.m
//  FitnessCoachCenter
//
//  Created by ZhijunHu on 2019/7/3.
//  Copyright © 2019 胡志军. All rights reserved.
//

#import "NSString+Extension_hzj.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Extension_hzj)

- (NSString *)safeSubstringFromIndex:(NSUInteger)from
{
    if (from > self.length) {
        return nil;
    } else {
        return [self substringFromIndex:from];
    }
}

- (NSString *)safeSubstringToIndex:(NSUInteger)to
{
    if (to > self.length) {
        return nil;
    } else {
        return [self substringToIndex:to];
    }
}

- (NSString *)safeSubstringWithRange:(NSRange)range
{
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (location+length > self.length) {
        return nil;
    } else {
        return [self substringWithRange:range];
    }
}

- (NSRange)safeRangeOfString:(NSString *)aString
{
    if (aString == nil) {
        return NSMakeRange(NSNotFound, 0);
    } else {
        return [self rangeOfString:aString];
    }
}

- (NSRange)safeRangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask
{
    if (aString == nil) {
        return NSMakeRange(NSNotFound, 0);
    } else {
        return [self rangeOfString:aString options:mask];
    }
}

- (NSString *)safeStringByAppendingString:(NSString *)aString
{
    if (aString == nil) {
        return [self stringByAppendingString:@""];
    } else {
        return [self stringByAppendingString:aString];
    }
}

- (id)safeInitWithString:(NSString *)aString
{
    if (aString == nil) {
        return [self initWithString:@""];
    } else {
        return [self initWithString:aString];
    }
}

+ (id)safeStringWithString:(NSString *)string
{
    if (string == nil) {
        return [self stringWithString:@""];
    } else {
        return [self stringWithString:string];
    }
}


#pragma mark - encrypt

- (NSString *)sha1 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    NSNumber * lengtn = [NSNumber numberWithUnsignedInteger:data.length];
    CC_SHA1(data.bytes, lengtn.unsignedIntValue, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return [output uppercaseString];
}

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

- (NSString *)showStr{
    return [self stringByRemovingPercentEncoding];;
}
- (NSString *)sendStr{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
}



#pragma mark - tools
- (NSString *)formatScientificNumber
{
    if (self == nil) {
        return self;
    }
    BOOL isPoint = NO;
    NSMutableString *num = [NSMutableString stringWithString:self];
    NSArray *array = [self componentsSeparatedByString:@"."];
    
    // NSMutableString * mstr = [[NSMutableString alloc] init];
    for (int i = 0; i < num.length; i++) {
        unichar ch = [num characterAtIndex:i];
        if (ch == '.') {
            isPoint = YES;
            num = array.firstObject;
        }
    }
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    if (isPoint) {
        NSMutableString * str2 = [[NSMutableString alloc] initWithString:array.lastObject];
        
        NSString * ss;
        if (str2.length >= 2) {
            ss = [str2 substringToIndex:2];
        }else {
            ss = array.lastObject;
        }
        
        
        return [NSString stringWithFormat:@"%@.%@",newstring,ss];
    }
    
    return [NSString stringWithFormat:@"%@.00",newstring] ;
}



- (NSString *)formatNilToEmptyString {
    return self != nil && self.length > 0 ? self : @"";
}
- (NSString *)deleteSpace{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (NSString *)replaceStr:(NSString *)str range:(NSRange)range{
    NSMutableString * num = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@"
                                                               ,self]];
    [num replaceCharactersInRange:range withString:str];
    return num;
    
}
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (NSString *)addFirstStr:(NSString *)str{
    return [NSString stringWithFormat:@"%@%@",str,self];
}
- (NSString *)addLastStr:(NSString *)str{
    return [NSString stringWithFormat:@"%@%@",str,self];
}
- (NSString *)firstString {
    if (self == nil || self.length == 0) {
        return @"";
    }
    return [self substringToIndex:1];
}

-(NSString *)desensitizationName:(NSString *)name{
    if (name && name.length>1) {
        NSMutableString *str = [NSMutableString string];
        for (int i=0; i<name.length-1; i++) {
            [str appendString:@"*"];
        }
        name = [name stringByReplacingCharactersInRange:NSMakeRange(0, name.length-1) withString:str];
    }
    return name;
}

-(NSString *)desensitizationOcrIDcard:(NSString *)idcard{
    if (idcard && idcard.length>8) {
        idcard = [idcard stringByReplacingCharactersInRange:NSMakeRange(4, idcard.length-8) withString:@"**********"];
    }
    
    return idcard;
}

- (BOOL)isValidString
{
    if (nil == self
        || ![self isKindOfClass:[NSString class]]
        || [self deleteSpace].length <= 0 || [self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}
+ (BOOL)isValidWithString:(id)str{
    if (nil == str
        || ![str isKindOfClass:[NSString class]]
        || [str deleteSpace].length <= 0 || [str isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}
- (BOOL)stringCheckingWithPattern:(NSString *)pattern
{
    if ([pattern isValidString]
        && [self isValidString]) {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSTextCheckingResult *firstMacth = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
        if (firstMacth) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)isMobileNumber{
    NSString *phoneNum = [self deleteSpace];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    return (phoneNum.length == 11) && [phoneNum stringCheckingWithPattern:@"^[1][3-9]+\\d{9}$"];
}

//判断是否是邮箱
- (BOOL)isEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
- (BOOL)isCode {
    if ([self isValidString ]) {
        if ([self deleteSpace].length >6) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return NO;
    }
}
//判断密码是否符合要求
- (BOOL)isPassWord{
    BOOL result = false;
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
}
//判断身份证是否合法
- (BOOL)isIDCard{
    
    if (self.length != 18) {
        return  NO;
        
    }
    
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    
    
    NSScanner* scan = [NSScanner scannerWithString:[self substringToIndex:17]];
    
    
    
    int val;
    
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        
        sumValue+=[[self substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
        
    }
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[self substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
        
    }
 
    return  NO;
    
}
//获取字符串的宽度
- (CGFloat)getWidthWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = self;
    label.font = font;
    label.numberOfLines = 1;
    [label sizeToFit];
    CGFloat width = label.frame.size.width;
    return ceil(width);
}
- (CGFloat)getHeightWithWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = self;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return ceil(height);
}
- (NSString *)deleteSpaceComma {
    return  [self stringByReplacingOccurrencesOfString:@"," withString:@""];
}
- (NSDate *)stringToDataWithFormatter:(NSString *)ft{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:ft];
    return  [df dateFromString:self];
}
+ (NSString *)dictionaryToString:(NSDictionary *)dic{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (NSString *)textFeildMaxLenght:(int)lenght{
    int i, n = (int)[self length], l = 0, a = 0, b = 0;
    int len = 0;
    unichar c;
    for ( i = 0; i < n; i ++) {
        c = [self characterAtIndex:i];
        if(c == 127){
            NSLog(@"ddd");
        }else if (isblank(c)) {//判断输入的字符是否为空格或者换行
            b ++;
        }else if (isascii(c)){
            //判断输入的字符是否为英文
            a ++;
        }else {
            //判断输入的字符是否为中文
            l ++;
        }
        len = l +(int)ceilf((float)(a+b));// ceilf去最接近的较大整数
        if (len > lenght) {
            return [self substringToIndex:i];
        }
    }
    if (a == 0 && l == 0) {
        return self;
    }
    return self;
    
}
- (NSDictionary *)stringToDictionary{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    return dic;

}

//利用CCRandomGenerateBytes实现随机字符串的生成
+ (NSString *)randomStringWithLength:(NSInteger)length {
    length = length/2;
    unsigned char digest[length];
    CCRNGStatus status = CCRandomGenerateBytes(digest, length);
    NSString *s = nil;
    if (status == kCCSuccess) {
        s = [self stringFrom:digest length:length];
    } else {
        s = @"";
    }
    NSLog(@"randomLength---:%@",s);
    return s;
}

//将bytes转为字符串
+ (NSString *)stringFrom:(unsigned char *)digest length:(NSInteger)leng {
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < leng; i++) {
        [string appendFormat:@"%02x",digest[i]];
    }
    NSLog(@"final stringFrom:%@",string);
    return string;
}


@end
