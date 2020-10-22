//
//  RegistCell.m
//  ParentStar
//
//  Created by 王家辉 on 2019/12/16.
//  Copyright © 2019年 Socrates. All rights reserved.
//

#import "RegistCell.h"


@interface RegistCell ()<UITextFieldDelegate>
@property(nonatomic, weak)UITextField *textField;
@property(nonatomic, weak)UIButton *delBtn;


@end

@implementation RegistCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
//    self.contentView.backgroundColor = [UIColor redColor];
    return self;
}

- (void)setUI{
    UIView *bgView = [UIView new];
    bgView.layer.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0].CGColor;
    bgView.layer.cornerRadius = 8;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    UITextField *textField = [UITextField new];
    textField.font = [UIFont systemFontOfSize:14];
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    [bgView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    self.textField = textField;
    
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [codeBtn setTitleColor:[UIColor colorWithRed:239/255.0 green:180/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0] forState:UIControlStateDisabled];

    [codeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(100);
    }];
    self.codeBtn = codeBtn;
    
    UIButton *delBtn = [UIButton new];
    [delBtn setImage:[UIImage imageNamed:@"icon／delete"] forState:UIControlStateNormal];
    [bgView addSubview:delBtn];
    [delBtn addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.hidden = YES;
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(bgView);
        
    }];
    self.delBtn = delBtn;
}
- (void)delAction:(UIButton *)btn{
    btn.hidden = YES;
    self.textField.text  = @"";
}
- (void)textFieldEditingChanged:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    self.model.text = textField.text;
    if (self.model.isDel) {
        self.delBtn.hidden = !self.textField.text.length;
    }
    if (self.textChangeBlock) {
        self.textChangeBlock(self.model);
    }
    if ([self.model.key isEqualToString:@"mobile"]&&textField.text.length>11) {
        textField.text = [textField.text substringToIndex:11];
    }
    if ([self.model.key isEqualToString:@"password"]&&textField.text.length>12) {
        textField.text = [textField.text substringToIndex:12];
    }
    if ([self.model.key isEqualToString:@"smsCode"]&&textField.text.length>6) {
        textField.text = [textField.text substringToIndex:6];
    }
}

//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//取消第一响应者
    return YES;
}

- (void)getCode{
    if (self.getCodeBlock) {
        self.getCodeBlock(self.codeBtn);
    }
    
}

- (void)setModel:(LoginRegistCommondModel *)model{
    _model = model;
    self.textField.text = model.text;
//    self.textField.placeholder = model.placeholder;
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:model.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1.0]}];
    self.textField.attributedPlaceholder = placeholderString;
    self.codeBtn.hidden = !model.isCoder;
    if (model.isCoder) {
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(self.codeBtn.mas_left);
        }];
    }
    if (model.isDel) {
        self.delBtn.hidden = !self.textField.text.length;
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(self.delBtn.mas_left);
        }];
    }
    
    self.textField.secureTextEntry = model.isPwd;
    self.textField.keyboardType = model.keyboardType;
}


+ (RegistCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"RegistCell";
    RegistCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[RegistCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    return cell;
}

@end
