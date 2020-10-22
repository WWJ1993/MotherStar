//
//  GloablModel.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/10.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GloablModel.h"
#import "StarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GloablModel : NSObject
@property (nonatomic, strong) NSArray<StarModel *> *starsArray;
@end

NS_ASSUME_NONNULL_END
