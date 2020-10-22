//
//  CommentTableViewCell.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/27.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentModel.h"

@interface CommentTableViewCell () {
    UIView *commentView;
    UIView *headerView;  //顶部视图
    
    UIView *scoreView;  //评分视图
    UIView *pentagramView;  //五角星列表
    UILabel *videoScore;  //视频评分

    
    UIView *contentView;
  
}

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickname;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIButton *like;  //点赞
@property (nonatomic, strong) UILabel *likes;  //点赞数
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) NSMutableArray *scoreArray;  //视频评分值

@end


@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        commentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:commentView];
        
        //顶部视图
        headerView = [[UIView alloc] initWithFrame:CGRectZero];
        [commentView addSubview:headerView];

        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [headerView addSubview:self.avatarImageView];
        self.avatarImageView.layer.cornerRadius = 28 / 2;  //圆形
        self.avatarImageView.clipsToBounds = YES;
     
        self.nickname = [[UILabel alloc] initWithFrame:CGRectZero];
        [headerView addSubview:self.nickname];

        self.nickname.font = PingFangSC_Regular(14);
        self.nickname.textColor = UICOLOR(@"#343338");
        
        self.date = [[UILabel alloc] initWithFrame:CGRectZero];
        [headerView addSubview:self.date];
        self.date.font = PingFangSC_Regular(10);  //字体待修改
        self.date.textColor = UICOLOR(@"#343338");
        
        self.like = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerView addSubview:self.like];
        self.like.frame = CGRectZero;
        [self.like setImage:[UIImage imageNamed:@"comment_like_default"] forState:UIControlStateNormal];  //默认
        [self.like addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];

        self.likes = [[UILabel alloc] initWithFrame:CGRectZero];  //字体待修改
        [headerView addSubview:self.likes];
        self.likes.textAlignment = NSTextAlignmentCenter;
        self.likes.font = PingFangSC_Regular(10);  //字体待修改
        self.likes.textColor = UICOLOR(@"#F2B300");
        
        //视频评论 - 评分
        scoreView = [[UIView alloc] initWithFrame:CGRectZero];
        [commentView addSubview: scoreView];

        pentagramView = [[UIView alloc] initWithFrame:CGRectZero];
        [scoreView addSubview:pentagramView];
        [self test_masonry_horizontal_fixSpace];

        videoScore = [[UILabel alloc] initWithFrame:CGRectZero];
        [scoreView addSubview:videoScore];
        videoScore.font = PingFangSC_Medium(10);
        videoScore.textColor = UICOLOR(@"#868686");
        
        //评论内容
        contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [commentView addSubview:contentView];

        self.content = [[UILabel alloc] initWithFrame:CGRectZero];
        [contentView addSubview:self.content];
        self.content.font = PingFangSC_Regular(12);
        self.content.textColor = UICOLOR(@"#343338");
        self.content.numberOfLines = 0;
        [self.content sizeToFit];
        
        self.commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        [commentView addSubview:self.commentImageView];
        self.commentImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.commentImageView.layer.cornerRadius = 4.0f;
        self.commentImageView.layer.masksToBounds = YES;
    }
    return self;
}

/* 更改评分 */
- (void)changeScore:(NSInteger)score {
    for (int i = 0; i < self.scoreArray.count; i ++) {
        UIImageView *pentagramImage = self.scoreArray[i];
        if (score < 0) {
            if (i < labs(score)) {
                 pentagramImage.image = [UIImage imageNamed:@"pentagram_minus"];
                 [_scoreArray replaceObjectAtIndex:i withObject:pentagramImage];
             }
        } else if (score > 0){
            if (i < score) {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_plus"];
                [_scoreArray replaceObjectAtIndex:i withObject:pentagramImage];
            }
        } else {
            pentagramImage.image = [UIImage imageNamed:@"pentagram_default"];
            [_scoreArray replaceObjectAtIndex:i withObject:pentagramImage];
        }
    }
}

- (NSMutableArray *)scoreArray {
    if (!_scoreArray) {
        _scoreArray = [NSMutableArray array];
        for (int i = 0; i < 5; i ++) {
            UIImageView *pentagramImage = [[UIImageView alloc] initWithFrame:CGRectZero];
            pentagramImage.image = [UIImage imageNamed:@"pentagram_default"];  //默认
            [pentagramView addSubview:pentagramImage];  //放入五角星
            [_scoreArray addObject:pentagramImage];
        }
    }
    return _scoreArray;
}

/* 评分五角星 */
- (void)test_masonry_horizontal_fixSpace {
    // 实现masonry水平固定间隔方法
    [self.scoreArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:4 leadSpacing:0 tailSpacing:0];

    // 设置array的垂直方向的约束
    [self.scoreArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pentagramView).offset(0);
        make.height.mas_equalTo(10);
    }];
}

/* 评论点赞 */
- (void)likeAction:(UIButton *)sender {
    if (sender.selected) {
        [self.like setImage:[UIImage imageNamed:@"comment_like"] forState:UIControlStateNormal];  //默认
    } else {
        [self.like setImage:[UIImage imageNamed:@"comment_like_default"] forState:UIControlStateNormal];  //默认
    }
    
    NSInteger like = 0;
    if (sender.selected) {
        like = 1;
    } else {
        like = 0;
    }
    NSDictionary *param = @{
                              @"selectStatus":@(like),
                              @"commentId":@(self.commentModel.id)
                            };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BrainholeCommentLikeNotification" object:param];
}

- (void)updateModel:(CommentModel *)model {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.nickname.text = model.nickName;
    self.date.text = [model.createTime substringToIndex:10];
    self.likes.text =  [@(model.thumbs) stringValue];  //点赞
    
    //视频评分
    if (model.isVideoType) {
        NSInteger score = model.score;
        if (score < 0) {
            videoScore.text = [NSString stringWithFormat:@"-%li.0", (long)labs(score)];
        } else {
            videoScore.text = [NSString stringWithFormat:@"%li.0", (long)score];
        }
        [self changeScore:score];  //更改评分
        scoreView.hidden = NO;
    } else {
        scoreView.hidden = YES;
    }
    

    
  
    //评论内容
    self.content.text = model.title;
    BOOL valid = model.comPicUrl && model.comPicUrl.length > 0;
    if (valid) {
        [self.commentImageView sd_setImageWithURL:[NSURL URLWithString:model.comPicUrl]];
    }

    //评论图片
    CGFloat imageHeight = 90;
    [self.commentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_bottom).mas_offset(5.5);
        make.left.equalTo(contentView).mas_offset(0);
        make.size.mas_equalTo((valid) ? CGSizeMake(imageHeight, imageHeight) : CGSizeZero);
        make.bottom.equalTo(commentView);
    }];
}

- (void)setCommentModel:(CommentModel *)commentModel {
    [self updateModel:commentModel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(16);
        make.right.equalTo(self.contentView).mas_offset(-16);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentView).mas_offset(0);
        make.left.right.equalTo(commentView).mas_offset(0);
        make.height.mas_equalTo(28);
    }];

    [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(0);
        make.width.height.mas_equalTo(28);
    }];

    [self.nickname mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(self.avatarImageView.mas_right).mas_offset(8);
        make.height.mas_equalTo(14);
    }];
    
    [self.date mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickname.mas_bottom).mas_offset(4);
        make.left.equalTo(self.avatarImageView.mas_right).mas_offset(8);
        make.height.mas_equalTo(10);
    }];
    
    [self.likes mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.centerY.equalTo(headerView);
        make.height.mas_equalTo(10);
    }];
    
    [self.like mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.likes.mas_left).mas_offset(-4);
        make.centerY.mas_equalTo(self.avatarImageView.mas_centerY);
        make.width.height.mas_equalTo(24);
    }];
    
    [scoreView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(8);
        make.left.equalTo(self.avatarImageView.mas_right).mas_offset(8);
        make.width.mas_equalTo(SCREENWIDTH - 32);
    }];
    
    [pentagramView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.width.mas_equalTo(61);
        make.height.mas_equalTo(10);
    }];
    
    [videoScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(pentagramView.mas_right).offset(8);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(10);
    }];
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scoreView.mas_bottom).mas_offset(8);
        make.left.equalTo(self.avatarImageView.mas_right).mas_offset(8);
        make.right.mas_offset(0);
    }];
    
    [self.content mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    
    [self.commentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).mas_offset(0);
    }];
}

@end
