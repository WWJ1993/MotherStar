//
//  PhotoAlbumTools.h
//  MotherStar
//
//  Created by yanming niu on 2019/12/13.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MediaBlock)(id data);

@interface PhotoAlbumTools : UIImagePickerController
//@property (nonatomic, copy) MediaBlock mediaBlock;
- (void)openPhotoAlbum:(BOOL)singleSelection
             mediaType:(NSString *)type
              callback:(MediaBlock)mediaBlock;

@end

NS_ASSUME_NONNULL_END
