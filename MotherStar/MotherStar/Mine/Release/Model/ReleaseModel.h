//
//  ReleaseModel.h
//  MotherStar
//
//  Created by 王文杰 on 2020/1/12.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReleseSubModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface HotPostModel : NSObject

//@property (nonatomic, strong) ReleseSubModel *post;
//"title": "测试重复带视频",
//"content": "和超市上班加到几点能到",
//"imgList": "http:motherplanet--test.oss-cn-beijing.aliyuncs.comimageandroid_1578650372584.png",
//"likeNum": 0,
//"shareNum": 0,
//"oilNum": 0,
//"tags": null,
//"starTagId": null,
//"starTag": null,
//"nickName": "文杰",
//"headImage": "https://motherplanet--test.oss-cn-beijing.aliyuncs.com/image/1578837924148_7db3330f.png"

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *imgList;
@property (nonatomic, copy) NSString *likeNum;
@property (nonatomic, copy) NSString *shareNum;
@property (nonatomic, copy) NSString *oilNum;
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *starTagId;
@property (nonatomic, copy) NSString *starTag;
@property (nonatomic, copy) NSString *nickName;
@end


@interface ReleaseModel : NSObject

@property (nonatomic, strong) HotPostModel *hotPost;

@end


NS_ASSUME_NONNULL_END
