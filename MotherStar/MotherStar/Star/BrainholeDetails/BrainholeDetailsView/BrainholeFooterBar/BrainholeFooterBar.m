//
//  BrainholeFooterBar.m
//  MotherStar
//
//  Created by yanming niu on 2020/1/12.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "BrainholeFooterBar.h"
#import "JXButton.h"
#import "BrainholeFooterBarModel.h"


@interface BrainholeFooterBar () {
    UIImageView *backgroundView;
    JXButton *uploadButton;
    JXButton *commentButton;
    JXButton *likeButton;
    JXButton *shareButton;
    UIView *getFuelBackupgroundView;
    JXButton *getFuelButton;
}

@end

@implementation BrainholeFooterBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, SCREENWIDTH, 49)];
        backgroundView.userInteractionEnabled = YES;
        backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        backgroundView.image = [UIImage imageNamed:@"BrainholeFooterBar_background"];
        [self addSubview:backgroundView];
//        backgroundView height 49  self 58
//        self.backgroundColor = [UIColor blueColor];
//        backgroundView.layer.borderColor = [[UIColor redColor] CGColor];
//        backgroundView.layer.borderWidth = 1.0f;  //测试
        
        uploadButton = [[JXButton alloc] initWithFrame:CGRectMake(30.5, 12, 42, 30)];
        uploadButton.tag = 11;
        [uploadButton setTitle:@"上传视频" forState:0];
        [uploadButton setTitleColor:[UIColor blackColor] forState:0];
        [uploadButton setImage:[UIImage imageNamed:@"BrainholeFooterBar_upload"] forState:0];
        [uploadButton addTarget:self action:@selector(targetAction:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:uploadButton];
        
        commentButton = [[JXButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 4, 12, 40, 30)];
        commentButton.tag = 12;
        commentButton.titleLabel.font = PingFangSC_Medium(10);
        [commentButton setTitle:@"0" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [commentButton setImage:[UIImage imageNamed:@"BrainholeFooterBar_comment"] forState:UIControlStateNormal];
        [backgroundView addSubview:commentButton];
        
        likeButton = [[JXButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 30, 12, 40, 30)];
        likeButton.tag = 13;
        [likeButton setTitle:@"0" forState:0];
        [likeButton setTitleColor:[UIColor blackColor] forState:0];
        [likeButton setImage:[UIImage imageNamed:@"BrainholeFooterBar_like"] forState:0];
        [backgroundView addSubview:likeButton];
        
        shareButton = [[JXButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 + 46, 12, 40, 30)];
        shareButton.tag = 14;
        [shareButton setTitle:@"0" forState:0];
        [shareButton setTitleColor:[UIColor blackColor] forState:0];
        [shareButton setImage:[UIImage imageNamed:@"BrainholeFooterBar_share"] forState:0];
        [backgroundView addSubview:shareButton];
        
        
//        CGRect addFuelBGViewFrame = CGRectMake(SCREENWIDTH / 2 + 101.5, 0, 49, 49);
        getFuelBackupgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        getFuelBackupgroundView.backgroundColor = UICOLOR(@"#EFB400");
        getFuelBackupgroundView.layer.cornerRadius = 49/2;  //圆形
        getFuelBackupgroundView.clipsToBounds = YES;
        [self addSubview:getFuelBackupgroundView];
        
        [getFuelBackupgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.greaterThanOrEqualTo(@(SCREENWIDTH/2+101.5+20 + 3));
            make.width.mas_offset(49);
            make.height.mas_offset(49);
        }];

        getFuelButton = [[JXButton alloc] initWithFrame:CGRectMake(5, 3, 40, 40)];
        getFuelButton.tag = 15;

        [getFuelButton setTitle:@"0" forState:0];
        [getFuelButton setTitleColor:[UIColor blackColor] forState:0];
        [getFuelButton setImage:[UIImage imageNamed:@"BrainholeFooterBar_getFuel"] forState:0];
        [getFuelBackupgroundView addSubview:getFuelButton];
        
        self.itemArray = @[uploadButton, commentButton, likeButton, shareButton, getFuelButton];
        SEL action = @selector(targetAction:);
        for (UIButton *button in self.itemArray) {
            [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
//        [self test_masonry_horizontal_fixSpace];

    }
    return self;
}

- (void)targetAction:(UIButton *)sender {
    if (sender.tag == 13) {
          sender.selected = !sender.selected;
          if (sender.selected) {
              if (self.footerModel.like == 0) {
                  [likeButton setTitle:[@(self.footerModel.likes + 1) stringValue] forState:0];
                  [likeButton setImage:[UIImage imageNamed:@"footer_like"] forState:UIControlStateNormal];
              } else {
                  [likeButton setTitle:[@(self.footerModel.likes - 1) stringValue] forState:0];
                  [likeButton setImage:[UIImage imageNamed:@"footer_like_default"] forState:UIControlStateNormal];
              }
          } else {
              [likeButton setImage:[UIImage imageNamed:@"footer_like_default"] forState:UIControlStateNormal];
          }
      }
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"BrainholeDetailFooterNotification" object:@(sender.tag)];
}

- (void)setFooterModel:(BrainholeFooterBarModel *)footerModel {
    if (footerModel.like == 0) {
        [likeButton setImage:[UIImage imageNamed:@"footer_like_default"] forState:0];
    } else {
        [likeButton setImage:[UIImage imageNamed:@"footer_like"] forState:0];
    }

    [commentButton setTitle:[@(footerModel.comments) stringValue] forState:0];
    [likeButton setTitle:[@(footerModel.likes) stringValue] forState:0];
    [shareButton setTitle:[@(footerModel.shares) stringValue] forState:0];
    [getFuelButton setTitle:[@(footerModel.fuels) stringValue] forState:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
  
//    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_offset(SCREENWIDTH);
//        make.height.mas_equalTo(49);
//        make.bottom.mas_offset(0);
//    }];

//    [uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(0);
//        make.left.equalTo(backgroundView).mas_offset(31);
//        make.width.mas_offset(22);
//        make.height.mas_offset(22);
//    }];
//
//    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(0);
//        make.right.equalTo(likeButton.mas_left).mas_offset(43.5);
//        make.width.mas_offset(22);
//        make.height.mas_offset(22);
//
//    }];
//
//    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(0);
//        make.centerX.equalTo(backgroundView);
//        make.width.mas_offset(22);
//        make.height.mas_offset(22);
//    }];
//
//    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(0);
//        make.left.equalTo(likeButton.mas_right).mas_offset(46);
//        make.width.mas_offset(22);
//        make.height.mas_offset(22);
//    }];
//
//    [getFuelBackupgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(0);
//        make.right.mas_offset(22);
//        make.width.height.mas_offset(49);
//    }];
//
//    [getFuelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(0);
//        make.left.right.mas_offset(0);
//        make.width.height.mas_offset(23);
//    }];
}


@end
