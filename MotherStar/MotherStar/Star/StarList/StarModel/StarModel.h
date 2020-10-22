//
//  StarModel.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/25.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StarModel : NSObject <NSCoding>
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *tagTitle;
@property (nonatomic, strong) NSString *starLogo;
@end

NS_ASSUME_NONNULL_END
