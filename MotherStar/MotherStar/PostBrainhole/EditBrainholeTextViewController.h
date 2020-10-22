//
//  EditBrainholeTextViewController.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/9.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BrainholeBlock)(NSString *);

@interface EditBrainholeTextViewController : BaseViewController
@property (nonatomic, copy) BrainholeBlock brainholeBlock;
@property (nonatomic, strong) NSString *brainholeText;  //html文本

@end

NS_ASSUME_NONNULL_END
