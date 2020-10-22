//
//  MotherPlanetAlertView.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/24.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Block)(void);

@interface MotherPlanetAlertView : UIView
@property (nonatomic, copy) Block okBlock;
@property (nonatomic, copy) Block cancelBlock;
@property (nonatomic, assign) BOOL canRemove;
-(void)remove ;
-(instancetype)init:(NSString *)title
            message:(NSString *)message
                 ok:(NSString *)ok
             cancel:(NSString *)cancel;
-(instancetype)initDeviceToken:(NSString *)deviceToken;

+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message
                        ok:(NSString *)ok
                    cancel:(NSString *)cancel
                   okBlock:(void(^)(void))okBlock
                   cancelBlock:(void(^)(void))cancelBlock;
@end

NS_ASSUME_NONNULL_END
