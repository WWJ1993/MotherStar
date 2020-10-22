//
//  CustomLabel.h
//  Biaobei
//
//  Created by 王家辉 on 2019/12/12.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomLabel : UILabel
@property (nonatomic, assign) UIEdgeInsets textInsets; // 控制字体与控件边界的间隙
@end

@interface EdgeInsetsLabel : UILabel

@property(nonatomic, assign) UIEdgeInsets edgeInsets;

@end

NS_ASSUME_NONNULL_END
