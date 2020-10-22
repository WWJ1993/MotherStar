//
//  registModel.h
//  ParentStar
//
//  Created by 王家辉 on 2019/12/16.
//  Copyright © 2019年 Socrates. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginRegistCommondModel : NSObject
@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *rightIcon;
@property(nonatomic, copy) NSString *selectIcon;
@property(nonatomic, assign) UIKeyboardType keyboardType;
@property(nonatomic, copy) NSString *footerText;

//
@property(nonatomic, copy) NSString *key;
//@property(nonatomic, copy) NSString *value;


@property(nonatomic, assign) BOOL isCoder;  //验证码cell
@property(nonatomic, assign) BOOL isPwd;  //密码cell
@property(nonatomic, assign) BOOL isDel;  //可删除cell

+ (NSArray <LoginRegistCommondModel *>*)getRegistArray;     //注册
+ (NSArray <LoginRegistCommondModel *>*)getLoginArray;      //登录
+ (NSArray <LoginRegistCommondModel *>*)getForgetPwdArray;  //忘记密码
+ (NSArray <LoginRegistCommondModel *>*)getPhoneArray;      //绑定手机号
+ (BOOL)judgePassWordLegal:(NSString *)pass;
@end

NS_ASSUME_NONNULL_END
