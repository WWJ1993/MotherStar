//
//  PhotoAlbumTools.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/13.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "PhotoAlbumTools.h"
#import "UIImage+Frame.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface PhotoAlbum: NSObject <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) MediaBlock mediaBlock;

@end

@implementation PhotoAlbum

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage * image = nil;
    NSString *duration = NULL;
       if ([mediaType isEqualToString:( NSString *)kUTTypeImage]) {
           image = [info objectForKey:UIImagePickerControllerOriginalImage];
           if (self.mediaBlock) {
               self.mediaBlock(image);
           }
        } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
           NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
           image = [UIImage getVideoPreViewImage:mediaURL];  //第一帧
           duration = [NSString getVideoDuration:mediaURL];
           if (self.mediaBlock) {
               NSDictionary *dic = @{
                                      @"image":image,
                                      @"duration":duration,
                                      @"url":mediaURL
                                    };
               self.mediaBlock(dic);
           }
        }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

@interface PhotoAlbumTools ()
@property (nonatomic, strong) PhotoAlbum *photoAlbum;
@end

@implementation PhotoAlbumTools

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initImagePickerController];
    }
    return self;
}

- (void)initImagePickerController {
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.navigationBar.translucent = NO;
    self.photoAlbum = [[PhotoAlbum alloc] init];
    self.delegate = self.photoAlbum;
}

/*
 * 单选打开图片或视频界面
 * 多选有相册和拍照选项
 */
- (void)openPhotoAlbum:(BOOL)singleSelection mediaType:(NSString *)type callback:(MediaBlock)mediaBlock{
    self.photoAlbum.mediaBlock = mediaBlock;
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *album = nil;
    UIAlertAction *camera = nil;
    if (singleSelection) {
        if ([type isEqual:@"photo"]) {
            [self getMediaType:@"photo"];
        } else {
            [self getMediaType:@"movie"];
        }
        [rootVC presentViewController:self animated:YES completion:nil];
        return;
    } else {
        album = [UIAlertAction actionWithTitle:@"相册"
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * _Nonnull action) {
            [self getMediaType:@"photo"];
            [rootVC presentViewController:self animated:YES completion:nil];
        }];
        camera = [UIAlertAction actionWithTitle:@"拍照"
                                          style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * _Nonnull action) {
            [self getMediaType:@"camera"];
            [rootVC presentViewController:self animated:YES completion:nil];
        }];
    }

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [rootVC dismissViewControllerAnimated:YES completion:nil];
    }];

    [alert addAction:camera];
    [alert addAction:album];
    [alert addAction:cancel];
    alert.modalPresentationStyle = UIModalPresentationFullScreen;
    [rootVC presentViewController:alert animated:YES completion:nil];
}

- (void)getMediaType:(NSString *)type {
    if ([type isEqual:@"photo"]) {
        self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
    } else if ([type isEqual:@"movie"]) {
        self.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
        self.sourceType= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else if ([type isEqual:@"camera"]) {
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
}


@end

