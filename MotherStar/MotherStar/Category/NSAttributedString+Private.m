//
//  NSAttributedString+Private.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/20.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "NSAttributedString+Private.h"

@implementation NSAttributedString (Private)

//富文本设置行间距
+ (NSMutableAttributedString *)setLineSpacing:(NSMutableAttributedString *)attString                                                 lineSpaceing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attString length])];
    return attString;
}

@end
