//
//  ProfileViewCell.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/16.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "ProfileViewCell.h"

@interface  ProfileViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iamgeView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hight;

@end

@implementation ProfileViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setArray:(NSArray *)array{
    _iamgeView.image = [UIImage imageNamed:array[0]];
    _name.text = [NSString stringWithFormat:@"%@", array[1]];
    NSString *str = [NSString stringWithFormat:@"%@", array[2]];
    if ([str isEqualToString:@""]) {
        _name1.text = @"未绑定";
        _name1.textColor =  [UIColor colorWithRed:239/255.0 green:180/255.0 blue:0/255.0 alpha:1.0];
    }else{
        if ([_name.text isEqualToString:@"手机号"]) {
            _imageView1.image = [UIImage imageNamed:@"duihao"];
            NSString *numberString = [array[2] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            _name1.text = [NSString stringWithFormat:@"%@", numberString];
            
            
        }else{
        _name1.text = [NSString stringWithFormat:@"%@", array[2]];
        _imageView1.image = [UIImage imageNamed:@""];
        _hight.constant = 0;
        }
    }
    
}
- (IBAction)bangAction:(id)sender {
    
}

@end
