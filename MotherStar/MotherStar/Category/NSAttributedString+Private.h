//
//  NSAttributedString+Private.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/20.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Private)
+ (NSMutableAttributedString *)setLineSpacing:(NSAttributedString *)attString                                                        lineSpaceing:(CGFloat)lineSpacing;

@end

NS_ASSUME_NONNULL_END
