//
//  HotBrainholeModel.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/26.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "HotBrainholeVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@class UserModel;
@class GetFuelModel;

@interface HotBrainholeModel : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger original;  //原创
@property (nonatomic, strong) NSString *title;  //脑洞标题
@property (nonatomic, strong) NSString *nickName;  //用户昵称
@property (nonatomic, strong) NSString *picUrl;  //用户头像
@property (nonatomic, strong) NSString *createTime;  //脑洞创建时间

@property (nonatomic, strong) NSString *oilNum;  //燃料
@property (nonatomic, strong) NSString *content;  //脑洞普通文本
@property (nonatomic, strong) NSAttributedString *contentAttribute;  //脑洞富文本
@property (nonatomic, strong) NSString *firstPictureUrl;  //脑洞第一张图片

@property (nonatomic, strong) NSArray *tagArray;  //标签

@property (nonatomic, strong) UserModel *userModel;  

@property (nonatomic, strong) NSString *starTag;  //星球名称
@property (nonatomic, strong) NSString *starTagId;  //星球Id  进入星球详情

@property (nonatomic, strong) NSString *source;  //来源

@property (nonatomic, assign) NSInteger likeNum;  //点赞
@property (nonatomic, assign) NSInteger isStatus;  //点赞状态
@property (nonatomic, assign) NSInteger shareNum;  //分享

@property (nonatomic, assign) NSInteger brainholeType;  //脑洞、视频类型  已废弃

@property (nonatomic, strong) GetFuelModel *getFuelModel;  //加油数

@property (nonatomic, strong) NSMutableArray *getFuelUserArray;  //加油榜单

@property (nonatomic, strong) NSMutableArray *commentArray;  //评论

@property (nonatomic, strong) NSMutableArray *videoArray;  //脑洞下的视频

@property (nonatomic, strong) NSIndexPath *tableViewCellIndex;  //脑洞下的视频




@end

NS_ASSUME_NONNULL_END
