//
//  CommentViewController.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/17.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIImageView *imageView0;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@property (weak, nonatomic) IBOutlet UILabel *titlabel;

@end

@implementation CommentViewController
{
    NSArray *array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navigationItem.title = @"评论";
    array = @[_imageView0, _imageView1,_imageView2,_imageView3,_imageView4];
}

- (IBAction)btnAction1:(UIButton *)sender {
    [self.btn1 setImage:[UIImage imageNamed:@"pingfen.png"] forState:UIControlStateNormal];
    [self.btn2 setImage:[UIImage imageNamed:@"tuoyuan.png"] forState:UIControlStateNormal];
    self.btn1.tag = 1;
    self.btn2.tag = 0;
}


- (IBAction)btnAction2:(UIButton *)sender {
    [self.btn1 setImage:[UIImage imageNamed:@"tuoyuan.png"] forState:UIControlStateNormal];
      [self.btn2 setImage:[UIImage imageNamed:@"fufenji.png"] forState:UIControlStateNormal];
    self.btn1.tag = 0;
    self.btn2.tag = 1;
}


- (IBAction)clickAction:(UITapGestureRecognizer *)sender {
    [self show:0];
}
- (IBAction)clickAction1:(id)sender {
    [self show:1];

}
- (IBAction)clickAction2:(id)sender {
    [self show:2];

}

- (IBAction)clickAction3:(id)sender {
    [self show:3];
}

- (IBAction)clickAction4:(id)sender {
    [self show:4];
}

-(void)show:(NSInteger ) i{
    
        if (_btn1.tag==1) {
               
           }else{
               
           }
    
    for (int v =0; v<=i; v++) {
        UIImageView *imageView = array[v];
        if (_btn1.tag==1) {
            imageView.image = [UIImage imageNamed:@"wuxingq.png"];
            self.titlabel.text = [NSString stringWithFormat:@"+%d", v+1];
        }else{
            imageView.image = [UIImage imageNamed:@"fufen.png"];
            self.titlabel.text = [NSString stringWithFormat:@"-%d", v+1];

        }
    }
    for (int v =i+1; v<array.count; v++) {
        UIImageView *imageView = array[v];
        imageView.image = [UIImage imageNamed:@"wuxing.png"];

    }
    
    
}


@end
