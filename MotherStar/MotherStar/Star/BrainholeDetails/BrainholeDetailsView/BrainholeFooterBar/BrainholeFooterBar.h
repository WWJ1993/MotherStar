//
//  BrainholeFooterBar.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/12.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BrainholeFooterBarModel;
NS_ASSUME_NONNULL_BEGIN

@interface BrainholeFooterBar : UIView
@property (nonatomic, strong) BrainholeFooterBarModel *footerModel;  //用户昵称
@property (nonatomic, strong) NSArray *itemArray; 

@end

NS_ASSUME_NONNULL_END
