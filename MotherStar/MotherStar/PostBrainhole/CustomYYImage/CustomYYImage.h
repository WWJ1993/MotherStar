//
//  CustomYYImage.h
//  LeeMall
//
//  Created by Cuiyan Li on 2017/3/28.
//  Copyright © 2020年 MaxWellPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYImage/YYImage.h>
@protocol ImageViewDataSource <NSObject>

- (void)p_longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress;

@end
@interface CustomYYImage : UIView
@property (nonatomic, strong) id image;
@property(nonatomic,assign)float imageW;
@property(nonatomic,assign)float imageH;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger location;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) id<ImageViewDataSource> dataSource;

- (instancetype)initWithDataSourece:(id<ImageViewDataSource>)dataSource;

@end
