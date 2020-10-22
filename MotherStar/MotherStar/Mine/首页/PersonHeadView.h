//
//  PersonView.h
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/10.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ImageClickTap)(NSInteger Tag);
@interface PersonHeadView : UIView
@property (weak, nonatomic) IBOutlet UIView *view;
@property (nonatomic,copy) ImageClickTap imageClickTap;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *fabuTitle;

@property (weak, nonatomic) IBOutlet UILabel *fabuTitleValue;
@property (weak, nonatomic) IBOutlet UILabel *ranliaoLabel;

@property (weak, nonatomic) IBOutlet UILabel *zhichiLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhichiLabelVale;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;



@end

NS_ASSUME_NONNULL_END
