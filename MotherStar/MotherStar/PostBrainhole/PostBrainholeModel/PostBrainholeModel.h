//
//  PostBrainholeModel.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/10.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostBrainholeModel : NSObject

@property (nonatomic, strong) NSString *issueTitle;
@property (nonatomic, strong) NSString *issueContent;
@property (nonatomic, assign) NSInteger issueOriginal;
@property (nonatomic, strong) NSString *issueSource;
@property (nonatomic, assign) NSInteger issueStar;
@property (nonatomic, strong) NSString *issueTag;
@property (nonatomic, strong) NSString *issueVideoDescribe;
@property (nonatomic, assign) NSInteger issueVideoOriginal;
@property (nonatomic, strong) NSString *issueVideoSource;
@property (nonatomic, strong) NSString *issueVideoTag;
@property (nonatomic, strong) NSString *issueVideoTitle;
@property (nonatomic, strong) NSString *painTing;
@property (nonatomic, strong) NSString *videoDuration;
@property (nonatomic, assign) NSInteger postId;



//{
//    "issueContent":"dgdf",
//    "issueOriginal":0,
//    "issueSource":"",
//    "issueStar":312,
//    "issueTag":"",
//    "issueTitle":"",
//    "issueVideoDescribe":"",
//    "issueVideoOriginal":1,
//    "issueVideoSource":"",
//    "issueVideoTag":"",
//    "issueVideoTitle":"",
//    "painTing":"asdfasdf",
//    "videoDuration":""
//}


@end

NS_ASSUME_NONNULL_END
