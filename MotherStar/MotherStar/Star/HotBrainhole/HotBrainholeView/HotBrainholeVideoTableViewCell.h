//
//  HotBrainholeVideoTableViewCell.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/30.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HotBrainholeModel;

@interface HotBrainholeVideoTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickname;
@property (nonatomic, strong) UITextView *content;  //脑洞内容 - 富文本
@property (nonatomic, strong) IXAttributeTapLabel *tagL;  //标签  支持富文本、点击事件
@property (nonatomic, strong) UILabel *fuel;  //燃料数
@property (nonatomic, strong) UILabel *starName;  //星球名称
@property (nonatomic, strong) UILabel *likeSum;  //点赞数
@property (nonatomic, strong) UILabel *shareSum;  //分享数

@property (nonatomic, strong) HotBrainholeModel *brainholeModel;  //脑洞

//@property (nonatomic, strong) NSMutableArray *videoListArray;  //脑洞下所有的视频


@end

NS_ASSUME_NONNULL_END
