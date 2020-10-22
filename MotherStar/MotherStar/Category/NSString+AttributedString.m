//
//  NSString+AttributedString.m
//  GoodReputationSunshine
//
//  Created by 胡志军 on 2019/9/25.
//  Copyright © 2019年 胡志军. All rights reserved.
//

#import "NSString+AttributedString.h"
#import <CoreText/CoreText.h>

@implementation NSString (AttributedString)

- (NSMutableAttributedString*)mutableAttributedString{
    return [[NSMutableAttributedString alloc] initWithString:self];
}
//添加字体和颜色
+ (void)changeAttributed:(NSMutableAttributedString*)attStr setSubStringFont:(UIFont*)font Color:(UIColor *)color range:(NSRange)range{
//    [mAttri addAttribute:NSForegroundColorAttributeName value:kColorGreen range:NSMakeRange( 6,6)];
//    [mAttri addAttribute:NSFontAttributeName value:kFontSize(14) range:NSMakeRange( 6,6)];

    [attStr setAttributes:@{NSForegroundColorAttributeName:color, NSFontAttributeName:font} range:range];
}

//单独改变字符串中指定字符的颜色和font
- (NSMutableAttributedString *)changeSubStirng:(NSString*)subStr font:(UIFont *)font color:(UIColor *)color{
    NSRange range = [self rangeOfString:subStr options:NSBackwardsSearch];
  NSMutableAttributedString * attStr =  [self mutableAttributedString];
    [NSString changeAttributed:attStr setSubStringFont:font Color:color range:range];
    return attStr;
    
}

//改变行间距 和字间距
-(NSMutableAttributedString *)changeLineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace{
    NSMutableAttributedString *attributedStr = [self mutableAttributedString];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    long number = textSpace;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[self length])];
    CFRelease(num);
    return attributedStr;
}
//改变行间距
- (NSMutableAttributedString *)changeLineSpace:(CGFloat)lineSpace{
    NSMutableAttributedString * attStr =  [self mutableAttributedString];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attStr;
}
- (NSMutableAttributedString *)addDelegateLineWithColor:(UIColor *)color {
    NSMutableAttributedString * attributedString = [self mutableAttributedString];
    NSRange range = NSMakeRange(0, self.length);
    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]  range:range];
    [attributedString addAttribute:NSStrikethroughColorAttributeName value:color range:range];
    return attributedString;
}

@end
