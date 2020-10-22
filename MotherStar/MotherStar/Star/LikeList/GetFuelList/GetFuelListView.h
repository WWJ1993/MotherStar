//
//  GetFuelListView.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/30.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GetFuelModel;
@interface GetFuelListView : UIView
@property (nonatomic, strong) NSMutableArray *fuelUserArray;
@property (nonatomic, strong) GetFuelModel *getFuelModel;

@end

NS_ASSUME_NONNULL_END
