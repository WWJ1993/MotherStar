//
//  RegistCell.h
//  ParentStar
//
//  Created by 王家辉 on 2019/12/16.
//  Copyright © 2019年 Socrates. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginRegistCommondModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RegistCell : UITableViewCell

@property (nonatomic, strong) LoginRegistCommondModel *model;

@property (nonatomic, copy) void(^textChangeBlock)(LoginRegistCommondModel *model);
@property (nonatomic, copy) void(^getCodeBlock)(UIButton *codeBtn);
@property(nonatomic, weak)UIButton *codeBtn;

+ (RegistCell *)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END