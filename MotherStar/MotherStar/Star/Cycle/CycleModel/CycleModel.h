//
//  CycleModel.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/8.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CycleModel : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *bannerName;
@property (nonatomic, strong) NSString *bannerSubtitle;
@property (nonatomic, strong) NSString *bannerPic;  //url地址
@property (nonatomic, strong) NSString *bannerGrade;
@property (nonatomic, assign) NSInteger bannerType;
@property (nonatomic, strong) NSString *linkUrl;



@end

NS_ASSUME_NONNULL_END
