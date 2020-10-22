//
//  OilingHeadView.h
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/11.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ButtonClick)(UIButton * sender);
@interface OilingHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *limitLab;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *msgLab;
@property (nonatomic,copy) ButtonClick buttonAction;
@property (nonatomic,copy) void (^integBlock)();


@end

NS_ASSUME_NONNULL_END
