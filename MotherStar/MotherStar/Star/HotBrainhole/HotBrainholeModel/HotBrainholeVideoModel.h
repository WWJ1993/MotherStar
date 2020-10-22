//
//  HotBrainholeVideoModel.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/30.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotBrainholeVideoModel : NSObject
@property (nonatomic, assign) NSInteger id;  //脑洞视频Id -  获取视频详情的Id

@property (nonatomic, strong) NSString *name;  //封面用户昵称
@property (nonatomic, strong) NSString *urlName;  //封面用户头像
@property (nonatomic, strong) NSString *createTime;  //创建时间

@property (nonatomic, assign) NSInteger share;  //视频分享


@property (nonatomic, strong) NSString *postIdVideo;  //播放量
@property (nonatomic, strong) NSString *videoId;  //具体视频的Id
@property (nonatomic, strong) NSString *videoTitle;
@property (nonatomic, strong) NSString *videoDuration;
@property (nonatomic, strong) NSString *videoCover;  //视频封面
@property (nonatomic, strong) NSString *urlPainting;  //视频源

@property (nonatomic, strong) NSString *videoDescribe;  //视频描述
@property (nonatomic, assign) NSInteger score;  //视频评分
@property (nonatomic, assign) NSInteger playNum;  //视频播放量
@property (nonatomic, assign) NSInteger original;  //视频原创

@property (nonatomic, strong) NSIndexPath *collectionViewCellIndexPath;
@property (nonatomic, assign) NSInteger playerSuperViewTag;

@property (nonatomic, strong) NSIndexPath *tableViewCellIndex;
@property (nonatomic, assign) NSInteger collectionViewTag;



@end

NS_ASSUME_NONNULL_END
