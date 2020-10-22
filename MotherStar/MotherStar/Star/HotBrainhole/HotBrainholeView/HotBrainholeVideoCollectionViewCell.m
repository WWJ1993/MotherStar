//
//  HotBrainholeVideoCollectionViewCell.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/31.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "HotBrainholeVideoCollectionViewCell.h"
#import "HotBrainholeVideoModel.h"
#import "JXButton.h"


@interface HotBrainholeVideoCollectionViewCell () {
    UIView *headerView;  //顶栏
    
    UIImageView *avatarImageView;
    UILabel *nickname;
    
    UIView *playCountsView;
    
    UIImageView *playCountsImageView;
    UILabel *videoPlayCounts;
    
    JXButton *playButton;
    
    UIView *footerView;  //底栏
    EdgeInsetsLabel *videoTitle;
}


@end


@implementation HotBrainholeVideoCollectionViewCell {
    UIView *starView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initHotBrainholeVideoCollectionViewCell];
    }
    return self;
}

- (void)initHotBrainholeVideoCollectionViewCell {
    //视频封面
    self.firstFrameImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:self.firstFrameImageView];

    //顶栏
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:headerView];

    avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    avatarImageView.userInteractionEnabled = YES;
    avatarImageView.image = [UIImage imageNamed:@"default_avatar"];  //test
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width /2;  //圆形
    avatarImageView.clipsToBounds = YES;
    [headerView addSubview:avatarImageView];

    //昵称
    nickname = [[UILabel alloc] initWithFrame:CGRectZero];
    nickname.font = PingFangSC_Regular(14);
    nickname.textColor = UICOLOR(@"#FFFFFF");
    [headerView addSubview:nickname];

    //播放量
    playCountsView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView addSubview: playCountsView];

    self.tag = self.hotBrainholeVideoModel.collectionViewTag;

    playCountsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    playCountsImageView.image = [UIImage imageNamed:@"image_videoPlayCounts_white"];
    [playCountsView addSubview: playCountsImageView];

    videoPlayCounts = [[UILabel alloc] initWithFrame:CGRectZero];
    videoPlayCounts.font = PingFangSC_Medium(12);
    videoPlayCounts.textColor = UICOLOR(@"#FFFFFF");
    [playCountsView addSubview: videoPlayCounts];

    playButton = [[JXButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:playButton];
    [playButton setImage:[UIImage imageNamed:@"button_play"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];

    //底栏
    footerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:footerView];

    videoTitle = [[EdgeInsetsLabel alloc] initWithFrame:CGRectZero];
    [footerView addSubview:videoTitle];
    
    videoTitle.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);  //top,left,bottom,right 设置左内边距
    videoTitle.font = PingFangSC_Medium(14);
    videoTitle.textColor = UICOLOR(@"#FFFFFF");
    videoTitle.numberOfLines = 1;

    //支持嵌套在collectionView中的cell里播放 - 暂时屏蔽播放，直接跳转至横屏播放
    _playerSuperView = [[UIView alloc] init];  //视频播放所在层
    [self.contentView addSubview:_playerSuperView];
    
    _playerSuperView.tag = self.hotBrainholeVideoModel.playerSuperViewTag;
    _playerSuperView.frame = self.bounds;
    _playerSuperView.backgroundColor = [UIColor clearColor];
    [_playerSuperView addSubview:playButton];
    
    [self layoutIfNeeded];
    
    self.tag = self.hotBrainholeVideoModel.collectionViewTag;  //定位
    _playerSuperView.tag = self.hotBrainholeVideoModel.playerSuperViewTag;  //定位

}

/* 播放通知 */
- (void)play {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivePlayVideoNotification" object:self];
}

- (void)updateModel:(HotBrainholeVideoModel *)model {
    [self.firstFrameImageView sd_setImageWithURL:[NSURL URLWithString:model.videoCover]];
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.urlName] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    nickname.text = model.name;
    videoPlayCounts.text = [@(model.playNum) stringValue];
    [playButton setTitle:model.videoDuration forState:UIControlStateNormal];

    videoTitle.text = model.videoTitle;
    
    _playerSuperView.tag = self.hotBrainholeVideoModel.playerSuperViewTag;  // test
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateModel:self.hotBrainholeVideoModel];
    
    [self.firstFrameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
     }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(8);
        make.left.mas_offset(6);
        make.right.mas_offset(-6);
        make.height.mas_equalTo(24);
    }];
    
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.width.height.mas_equalTo(24);
    }];
    
    [nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).mas_offset(6);
        make.left.equalTo(avatarImageView.mas_right).mas_offset(8);
        make.height.mas_equalTo(12);
    }];
    
    [playCountsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(6);
        make.right.mas_offset(-6);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(12);
    }];
    
    [playCountsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(10);
    }];
    
    [videoPlayCounts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(0);
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(12);
    }];
    
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.mas_equalTo(34);
    }];
    
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(playButton.mas_bottom).mas_offset(42.5);
        make.left.mas_offset(11);
        make.right.mas_offset(-11);
        make.height.mas_equalTo(19);
        make.bottom.equalTo(self.contentView);
    }];
    
    [videoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerView);
    }];
}


@end
