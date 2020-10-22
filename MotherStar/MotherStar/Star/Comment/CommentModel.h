//
//  CommentModel.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/27.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString  *nickName;
@property (nonatomic, strong) NSString  *picUrl;  //评论内容图片
@property (nonatomic, strong) NSString  *title;  //评论内容
@property (nonatomic, strong) NSString  *createTime;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger thumbs;  //评论点赞数
@property (nonatomic, assign) NSInteger thumbsType;
@property (nonatomic, strong) NSString  *comPicUrl;
@property (nonatomic, assign) BOOL isVideoType;


//@property (nonatomic, strong) NSString  *headImage;

@end

NS_ASSUME_NONNULL_END
