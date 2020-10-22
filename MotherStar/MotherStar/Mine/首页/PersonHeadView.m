//
//  PersonView.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/10.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "PersonHeadView.h"

@implementation PersonHeadView


-(void)drawRect:(CGRect)rect{

    _view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _view.layer.cornerRadius = 8;
    _view.layer.shadowColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:0.5].CGColor;
    _view.layer.shadowOffset = CGSizeMake(0,1);
    _view.layer.shadowOpacity = 1;
    _view.layer.shadowRadius = 13.5;
    _view.clipsToBounds = NO;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 45;
}

- (IBAction)tapAction:(id)sender {
    if (self.imageClickTap) {
        self.imageClickTap(0);
    }
}


- (IBAction)fabuAction:(id)sender {
    if (self.imageClickTap) {
           self.imageClickTap(1);
       }
}


- (IBAction)ranAction:(id)sender {
    if (self.imageClickTap) {
           self.imageClickTap(2);
       }
}

- (IBAction)zhiAction:(id)sender {
    
    if (self.imageClickTap) {
           self.imageClickTap(3);
       }
    
}
- (void)pushTap{
    if (self.imageClickTap) {
        self.imageClickTap(0);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushTap)]];
    [self.sexImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushTap)]];

}


@end
