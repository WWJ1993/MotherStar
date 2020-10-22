//
//  CommentSectionHeaderView.h
//  MotherStar
//
//  Created by yanming niu on 2020/1/4.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HeaderViewDelegate <NSObject>
//- (void)updateSortStatus:(UIButton *)sender;
@optional
- (void)sortByTime:(UIButton *)sender;  //按时间或热度排序
@end

@interface CommentSectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIButton *sortByTimeButton;
@property(nonatomic,weak) id<HeaderViewDelegate> delegate;
//- (void)updateSortStatus:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
