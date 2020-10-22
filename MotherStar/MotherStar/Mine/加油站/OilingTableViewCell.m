//
//  OilingTableViewCell.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/11.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "OilingTableViewCell.h"

@interface OilingTableViewCell()

@end
@implementation OilingTableViewCell
{
    NSNumber *taskId;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.progress.frame ;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 6.0f);
    self.progress.transform = transform;//设定宽高
    self.progress.contentMode = UIViewContentModeScaleAspectFill;
    //设定两端弧度
    self.progress.layer.cornerRadius = 6.0;
    self.progress.layer.masksToBounds = YES;
    //设定progressView的现实进度（一般情况下可以从后台获取到这个数字）
//    [self.progress setProgress:0.70 animated:YES];
    
    _btn.layer.cornerRadius = 17.5;
    _btn.layer.masksToBounds = YES;
    _btn.layer.borderColor = [UIColor colorWithRed:239/255.0 green:180/255.0 blue:0/255.0 alpha:1.0].CGColor;
    _btn.layer.borderWidth = 1.0;
    
}

- (IBAction)btnAction:(UIButton *)sender {
    
    if (self.buttonActionCell) {
        self.buttonActionCell(taskId);
    }
}

-(void)setDic:(NSDictionary *)dic{
    
   
    
    taskId = dic[@"id"];
    NSArray *array = @[@"like",@"cheer",@"comment",@"share",@"invite"];
    int i = [dic[@"id"] intValue];
    self.imageView.image = [UIImage imageNamed:array[i-1]];
    self.titleLabel.text = dic[@"task_name"];
    
    NSInteger upper_limit= [[dic valueForKey:@"upper_limit"] integerValue];
    NSInteger num= [[dic valueForKey:@"num"] integerValue];

    self.progressLabel.text = [NSString stringWithFormat:@"%ld/%ld", num>upper_limit?upper_limit:num,upper_limit];
//    [self.btn setTitle:[NSString stringWithFormat:@"领取%@L", dic[@"task_score"]] forState:UIControlStateNormal];
    NSNumber *a = dic[@"num"];
    NSNumber *b = dic[@"upper_limit"];
    float pro = [a floatValue]/[b floatValue];
    self.progress.progress =pro;
    
    self.btn.enabled = NO;
    if ([(NSNumber *)dic[@"receive"]  isEqual: @(1)]) {
        [_btn setTintColor:[UIColor colorWithHexString:@"#EFB400" alpha:1.0f]];
        [_btn  setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1.0f]];
        _btn.layer.borderColor = [UIColor colorWithHexString:@"#EFB400" alpha:1.0f].CGColor;
        self.btn.enabled = YES;
    }else{
        [_btn setTintColor:[UIColor colorWithHexString:@"#868686" alpha:1.0f]];
        [_btn  setBackgroundColor:[UIColor colorWithHexString:@"#868686" alpha:0.3]];
        _btn.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1.0f].CGColor;
    }
//    receive ：0.领取过，1.可领取 2.不可领取
   if ([(NSNumber *)dic[@"receive"]  isEqual: @(0)]) {
       [self.btn setTitle:[NSString stringWithFormat:@"已领取%@L", dic[@"task_score"]] forState:UIControlStateNormal];
   }else{
       [self.btn setTitle:[NSString stringWithFormat:@"领取%@L", dic[@"task_score"]] forState:UIControlStateNormal];

   }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
