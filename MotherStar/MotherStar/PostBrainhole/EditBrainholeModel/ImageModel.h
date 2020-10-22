//
//  ImageModel.h
//  TextViewDemo
//
//  Created by 井庆林 on 16/7/29.
//  Copyright © 2016年 JingQL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *fullUrl;
@property (nonatomic, copy) NSString *abbrUrl;
@property (nonatomic, copy) NSString *title;
@property(nonatomic,strong)NSMutableArray*ansArr;
@property(nonatomic,strong)NSString*typeStr;
@property(nonatomic,strong)NSString*isMore;
@property(nonatomic,strong)NSString*contentID;
@property(nonatomic,copy)NSString*width;
@property(nonatomic,copy)NSString*height;

@end
