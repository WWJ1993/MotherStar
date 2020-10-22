//
//  UIImage+Frame.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/13.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "UIImage+Frame.h"
//#import <AppKit/AppKit.h>
#import <AVFoundation/AVFoundation.h>


@implementation UIImage (Frame)

/* 获取视频第一帧 */
+ (UIImage *) getVideoPreViewImage:(NSURL *)url {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}
@end
