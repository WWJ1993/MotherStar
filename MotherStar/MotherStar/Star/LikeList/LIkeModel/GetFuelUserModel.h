//
//  GetFuelUserModel.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/11.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetFuelUserModel : NSObject
@property (nonatomic, strong) NSString *picUrl;  //头像
@property (nonatomic, assign) NSInteger integral;  //加油数
@property (nonatomic, copy) NSString *supportNum;  //支持数
@property (nonatomic, copy)  NSString *nickName;  //昵称

@end

NS_ASSUME_NONNULL_END
