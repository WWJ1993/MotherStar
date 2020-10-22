//
//  LoginCell.m
//  ParentStar
//
//  Created by 王家辉 on 2019/12/16.
//  Copyright © 2019年 Socrates. All rights reserved.
//

#import "LoginCell.h"
@interface LoginCell ()<UITextFieldDelegate>
@property(nonatomic, weak)UIImageView *icon;
@property(nonatomic, weak)UIButton *rightIconBtn;
@property(nonatomic, weak)UITextField *textField;

@end

@implementation LoginCell


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
    
    UIImageView *icon = [UIImageView new];
    [bgView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(15);
        make.centerY.mas_equalTo(bgView);
    }];
    self.icon = icon;
    
    UIButton *rightIconBtn = [UIButton new];
    [bgView addSubview:rightIconBtn];
    [rightIconBtn addTarget:self action:@selector(selectIconAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(bgView);
        
    }];
    self.rightIconBtn = rightIconBtn;
    
    UITextField *textField = [UITextField new];
    textField.font = [UIFont systemFontOfSize:14];
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    textField.returnKeyType = UIReturnKeyDone;
    [bgView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(icon.mas_right).mas_offset(5);
        make.right.mas_equalTo(rightIconBtn.mas_left).mas_offset(5);
    }];
    textField.delegate = self;
    self.textField = textField;
}

//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//取消第一响应者
    return YES;
}
- (void)selectIconAction:(UIButton *)btn{
    if (self.model.isPwd) {
        btn.selected = !btn.selected;
        self.textField.secureTextEntry = !btn.selected;
    }
    if (self.model.isDel) {
        self.textField.text = @"";
        self.model.text = @"";
    }
    
}
- (void)textFieldEditingChanged:(UITextField *)textField{    if ([self.model.key isEqualToString:@"mobile"]&&textField.text.length>11) {
        textField.text = [textField.text substringToIndex:11];
    }
    if ([self.model.key isEqualToString:@"password"]&&textField.text.length>12) {
        textField.text = [textField.text substringToIndex:12];
    }
    self.model.text = textField.text;
    if (self.textChangeBlock) {
        self.textChangeBlock(self.model);
    }
}

- (void)setModel:(LoginRegistCommondModel *)model{
    _model = model;
    [self.icon setImage:[UIImage imageNamed:model.icon]];
    [self.rightIconBtn setImage:[UIImage imageNamed:model.rightIcon] forState:UIControlStateNormal];
    if (model.selectIcon) {
        [self.rightIconBtn setImage:[UIImage imageNamed:model.selectIcon] forState:UIControlStateSelected];
    }
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:model.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1.0]}];
    self.textField.attributedPlaceholder = placeholderString;
    self.textField.secureTextEntry = model.isPwd;
    self.textField.keyboardType = model.keyboardType;
    

}
+ (LoginCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"LoginCell";
    LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[LoginCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    return cell;
}

@end
