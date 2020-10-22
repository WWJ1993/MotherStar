//
//  ProfileView.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/16.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "ProfileViewc.h"
#import "UIImageView+WebCache.h"
@interface ProfileViewc()
@property (weak, nonatomic) IBOutlet UIImageView *manImageView;
@property (weak, nonatomic) IBOutlet UIImageView *womanImageView;
@property (weak, nonatomic) IBOutlet UIImageView *baoImageView;


@end

@implementation ProfileViewc

-(void)drawRect:(CGRect)rect{
    [_textFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 48;
}

- (IBAction)manAction:(id)sender {
    _manImageView.image = [UIImage imageNamed:@"icon_man_sel"];
    _womanImageView.image = [UIImage imageNamed:@"woman.png"];
    _baoImageView.image = [UIImage imageNamed:@"womannor.png"];
    _gender = 1;
}

- (IBAction)woAction:(id)sender {
    
    _manImageView.image = [UIImage imageNamed:@"man.png"];
    _womanImageView.image = [UIImage imageNamed:@"icon_woman_nor"];
    _baoImageView.image = [UIImage imageNamed:@"womannor.png"];
    _gender = 2;
}

- (IBAction)baoAction:(id)sender {
    _manImageView.image = [UIImage imageNamed:@"man.png"];
    _womanImageView.image = [UIImage imageNamed:@"woman.png"];
    _baoImageView.image = [UIImage imageNamed:@"icon_woman_nor(1).png"];
    _gender = 0;
}


- (IBAction)imageAction:(id)sender {
    if (self.imageClickTap) {
        self.imageClickTap(0);
    }
}


-(void)setDic:(NSDictionary *)dic{
    NSNumber *gender = dic[@"gender"];
    NSArray *sexheadArray = @[@"baomihead",@"head",@"womanhead"];
    NSURL *url = [NSURL URLWithString:dic[@"picUrl"]];
    
    [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:sexheadArray[[gender intValue]]]];
    NSArray *sexArray = @[@"icon_woman_nor(1)",@"icon_man_sel",@"icon_woman_nor"];
    NSArray *viewArray = @[_baoImageView,_manImageView,_womanImageView];
    ((UIImageView *)viewArray[[gender intValue]]).image = [UIImage imageNamed:sexArray[[gender intValue]]];
    self.textFiled.text = [dic valueForKey:@"nickName"];
    _gender = [gender integerValue];
    
}

- (void) textFieldDidChange:(UITextField *)textField
{

    NSInteger kMaxLength = 9;
    NSString *toBeString = textField.text;
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        
        UITextRange *selectedRange = [textField markedTextRange];
        
        //获取高亮部分
        
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            
            if (toBeString.length > kMaxLength) {
                
                textField.text = [toBeString substringToIndex:kMaxLength];
                [textField resignFirstResponder];
                
            }
            
        }
        
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
        
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > kMaxLength) {
            
            textField.text = [toBeString substringToIndex:kMaxLength];
            
        }
        
    }
 
}


@end
