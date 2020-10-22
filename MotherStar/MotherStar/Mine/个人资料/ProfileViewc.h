//
//  ProfileView.h
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/16.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ImageClickTap)(NSInteger Tag);

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewc : UIView
@property (copy, nonatomic) NSArray *dic;
@property (nonatomic,copy) ImageClickTap imageClickTap;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (assign, nonatomic) NSInteger gender;

@end

NS_ASSUME_NONNULL_END
