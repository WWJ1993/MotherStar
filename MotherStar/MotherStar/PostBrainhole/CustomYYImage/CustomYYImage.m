//
//  CustomYYImage.m
//  LeeMall
//
//  Created by Cuiyan Li on 2017/3/28.
//  Copyright © 2020年 MaxWellPro. All rights reserved.
//

#import "CustomYYImage.h"
#import <Masonry.h>
@interface CustomYYImage()
@property (nonatomic, strong) YYAnimatedImageView *imageView;

@end
@implementation CustomYYImage
- (instancetype)initWithDataSourece:(id<ImageViewDataSource>)dataSource {
    if (self = [super init]) {
        _dataSource = dataSource;
        
        _imageView = [[YYAnimatedImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_imageView.mas_width);
            make.height.equalTo(_imageView.mas_height);
            make.top.equalTo(self);
            make.centerX.equalTo(self);
        }];
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        _uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        self.title = @"";
        
    }
    return self;
}
- (void)setImage:(id)image {
    _image = image;
    if ([image isKindOfClass:[UIImage class]]) {
        _imageView.image = image;
    } else {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _image = image;
        }];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
