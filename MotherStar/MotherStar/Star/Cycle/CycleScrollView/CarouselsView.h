//
//  CarouselsView.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/15.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CarouselsView;
@protocol CarouselsCollectionViewDelegate <NSObject>

-(void)carouselsView:(CarouselsView *)carousesView didSelectedItem:(NSInteger)index;

@end
@interface CarouselsView : UIView
@property (nonatomic,weak) id <CarouselsCollectionViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *cycleArray;
-(instancetype)initWithFrame:(CGRect)frame bannerImgWidth:(CGFloat)width bannerImgHeight:(CGFloat)height leftRightSpace:(CGFloat)space itemSpace:(CGFloat)itemSpace;
- (void)setupBannerData:(NSArray *)models;

@end

NS_ASSUME_NONNULL_END
