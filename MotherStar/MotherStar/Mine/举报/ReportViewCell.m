//
//  ReportViewCell.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/17.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "ReportViewCell.h"

@implementation ReportViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.button.userInteractionEnabled = NO;
}

- (IBAction)click:(id)sender {
//    UIButton *btn = sender;
//    if (btn.tag == 0) {
//        btn.tag=1;
//        [btn setImage:[UIImage imageNamed:@"pingfen.png"] forState:UIControlStateNormal];
//    }else{
//        btn.tag=0;
//        [btn setImage:[UIImage imageNamed:@"tuoyuan.png"] forState:UIControlStateNormal];
//    }
//
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if (_button.tag == 0) {
//           _button.tag=1;
//           [_button setImage:[UIImage imageNamed:@"tuoyuan.png"] forState:UIControlStateNormal];
//       }else{
////           pingfen.png
//           _button.tag=0;
//           [_button setImage:[UIImage imageNamed:@"pingfen.png"] forState:UIControlStateNormal];
//       }

    
}

@end
