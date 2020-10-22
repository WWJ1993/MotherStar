//
//  registModel.m
//  ParentStar
//
//  Created by 王家辉 on 2019/12/16.
//  Copyright © 2019年 Socrates. All rights reserved.
//

#import "LoginRegistCommondModel.h"

@implementation LoginRegistCommondModel
+ (NSArray <LoginRegistCommondModel *>*)getRegistArray{
    LoginRegistCommondModel *model1 = [LoginRegistCommondModel new];
    model1.placeholder = @"请输入手机号";
    model1.key = @"mobile";
    model1.keyboardType = UIKeyboardTypeNumberPad;
    model1.isDel = YES;

    LoginRegistCommondModel *model2 = [LoginRegistCommondModel new];
    model2.placeholder = @"请输入验证码";
    model2.isCoder = YES;
    model2.key = @"smsCode";
    model2.keyboardType = UIKeyboardTypeNumberPad;

    LoginRegistCommondModel *model3 = [LoginRegistCommondModel new];
    model3.placeholder = @"请输入密码";
    model3.footerText = @"* 6-12位的英文加数字";
    model3.key = @"password";
    model3.isPwd = YES;
    model3.isDel = YES;

    LoginRegistCommondModel *model4 = [LoginRegistCommondModel new];
    model4.placeholder = @"请输入邀请码(选填)";
    model4.key = @"inviteUsers";
    model4.isDel = YES;

    return @[model1,model2,model3,model4];
}

+ (NSArray <LoginRegistCommondModel *>*)getLoginArray{
    LoginRegistCommondModel *model1 = [LoginRegistCommondModel new];
    model1.placeholder = @"请输入手机号";
    model1.icon = @"icon／number";
    model1.rightIcon = @"icon／delete";
    model1.isDel = YES;
    model1.key = @"mobile";
    model1.keyboardType = UIKeyboardTypeNumberPad;

    LoginRegistCommondModel *model2 = [LoginRegistCommondModel new];
    model2.placeholder = @"请输入密码";
    model2.icon = @"icon／cipher";
    model2.rightIcon = @"icon／hide";
    model2.selectIcon = @"icon／emerge";

    model2.isPwd = YES;
    model2.key = @"password";

    return @[model1,model2];
}

+ (NSArray <LoginRegistCommondModel *>*)getForgetPwdArray{
    LoginRegistCommondModel *model1 = [LoginRegistCommondModel new];
    model1.placeholder = @"请输入手机号";
    model1.key = @"mobile";
    model1.keyboardType = UIKeyboardTypeNumberPad;
    model1.isDel = YES;

    LoginRegistCommondModel *model2 = [LoginRegistCommondModel new];
    model2.placeholder = @"请输入验证码";
    model2.isCoder = YES;
    model2.key = @"smsCode";
    model2.keyboardType = UIKeyboardTypeNumberPad;

    LoginRegistCommondModel *model3 = [LoginRegistCommondModel new];
    model3.placeholder = @"请输入新密码";
    model3.footerText = @"* 6-12位的英文加数字";
    model3.key = @"password";
    model3.isPwd = YES;
    model3.isDel = YES;

    
    return @[model1,model2,model3];
}

+ (NSArray <LoginRegistCommondModel *>*)getPhoneArray{
    LoginRegistCommondModel *model1 = [LoginRegistCommondModel new];
    model1.placeholder = @"请输入手机号";
    model1.key = @"mobile";
    model1.keyboardType = UIKeyboardTypeNumberPad;
    model1.isDel = YES;

    LoginRegistCommondModel *model2 = [LoginRegistCommondModel new];
    model2.placeholder = @"请输入验证码";
    model2.isCoder = YES;
    model2.key = @"smsCode";
    model2.keyboardType = UIKeyboardTypeNumberPad;

//    LoginRegistCommondModel *model3 = [LoginRegistCommondModel new];
//    model3.placeholder = @"请输入密码";
//    model3.footerText = @"* 6-12位的英文加数字";
//    model3.key = @"password";
//    model3.isPwd = YES;
    
    LoginRegistCommondModel *model4 = [LoginRegistCommondModel new];
    model4.placeholder = @"请输入邀请码(选填)";
    model4.key = @"inviteUsers";
    model4.isDel = YES;

    return @[model1,model2,model4];
}

+ (BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,12}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}



@end
