//
//  CarouselsCollectionViewCell.m
//  MotherStar
//
//  Created by yanming niu on 2020/1/15.
//  Copyright © 2020年 yanming niu. All rights reserved.
//

#import "CarouselsCollectionViewCell.h"
#import "CycleModel.h"

@interface CarouselsCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;  //轮播图片
@property (nonatomic, strong) UIImageView *promptImageView;  //加急
@property (nonatomic, strong) UILabel *title;  //标题
@property (nonatomic, strong) UILabel *subTitle;  //副标题
@end

@implementation CarouselsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
 
    self.contentView.backgroundColor = UICOLOR(@"#FFFFFF");
//    self.contentView.backgroundColor = [UIColor grayColor];
    self.contentView.layer.cornerRadius = 8;
    self.contentView.clipsToBounds = YES;
    

    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.userInteractionEnabled = YES;
    _imageView.layer.cornerRadius = 8;
    _imageView.clipsToBounds = YES;
    
    //    向左偏移10 （-10，0）
    //    向右偏移10 （10，0）
    //    向上偏移10 （0，-10）
    //    向下偏移10 （0，10）
    //    阴影的颜色：imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    阴影的透明度：imgView.layer.shadowOpacity = 0.4f;
    //    阴影的圆角：imgView.layer.shadowRadius = 4.0f;
    //    阴影偏移量：imgView.layer.shadowOffset = CGSizeMake(0,0);//Defaults to (0, -3).
    
    //投影  待修改
    self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
    self.contentView.layer.shadowColor = UICOLOR(@"#6D6D6D").CGColor;
    self.contentView.layer.shadowOpacity = 1;
    self.contentView.layer.shadowRadius = 13.5;
    
    _title = [[UILabel alloc] initWithFrame:CGRectZero];
    _title.numberOfLines = 1;
    _title.font = PingFangSC_Medium(18);
    _title.textColor = UICOLOR(@"#343338");
    
    _subTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _subTitle.numberOfLines = 1;
    _subTitle.font = PingFangSC_Regular(10);
    _subTitle.textColor = UICOLOR(@"#868686");
    
    [self.contentView addSubview:_imageView];
    [self.contentView addSubview:_title];
    [self.contentView addSubview:_subTitle];
    
    //脑洞视频+评分
    [self layoutIfNeeded];
}

- (void)updateModel {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.cycleModel.bannerPic]];
    self.title.text = self.cycleModel.bannerName;
    self.subTitle.text = self.cycleModel.bannerSubtitle;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateModel];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.top.mas_equalTo(0);
        make.bottom.equalTo(self.subTitle.mas_bottom).mas_offset(20);
    }];

     [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.top.mas_equalTo(0);
         make.height.mas_equalTo(193);
     }];
     
     [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(self.imageView.mas_bottom).offset = 10;
         make.left.mas_equalTo(8);
         make.right.mas_equalTo(-12);
         make.height.offset = 24;
     }];
    
     [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(self.title.mas_bottom).offset = 10;
//         make.left.mas_equalTo(8);
//         make.right.mas_equalTo(-12);
         make.left.right.equalTo(self.title);
         make.height.mas_equalTo(10);
         make.bottom.mas_equalTo(0);
     }];
    
    _imageView.frame = self.bounds;

   
}

@end
