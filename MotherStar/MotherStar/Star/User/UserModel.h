//
//  UserModel.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/11.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
@property (nonatomic, strong) NSString *nickName;  //用户昵称
@property (nonatomic, strong) NSString *picUrl;  //用户头像
@end

NS_ASSUME_NONNULL_END
