//
//  GetFuelView.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/20.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void( ^CompleteBlock)(void);

@interface GetFuelView : UIView
@property (nonatomic, assign) NSInteger myFuel;
- (void)showAction;
- (void)closeAction;
@end

NS_ASSUME_NONNULL_END
