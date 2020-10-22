//
//  CommentSectionHeaderView.m
//  MotherStar
//
//  Created by yanming niu on 2020/1/4.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "CommentSectionHeaderView.h"
@interface CommentSectionHeaderView () {
    UILabel *titleL;
    UIView *sortView;
//    UIButton *sortByTimeButton;
    UILabel *sortByTimeL;
}
@end

@implementation CommentSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.text = @"评论";
        titleL.font = PingFangSC_Medium(21);
        titleL.textColor = UICOLOR(@"#343338");
        titleL.numberOfLines = 1;
        [self.contentView addSubview:titleL];
        
        sortView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:sortView];

        _sortByTimeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_sortByTimeButton setEnlargeEdgeWithTop:20 right:30 bottom:20 left:20];
        [_sortByTimeButton setImage:[UIImage imageNamed:@"soryByTime"] forState:UIControlStateNormal];
        [_sortByTimeButton addTarget:self action:@selector(sortByTimeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sortByTimeButton];
        [sortView addSubview:_sortByTimeButton];

        sortByTimeL = [[UILabel alloc] initWithFrame:CGRectZero];
        sortByTimeL.text = @"按时间";
        sortByTimeL.font = PingFangSC_Regular(12);
        sortByTimeL.textColor = UICOLOR(@"#343338");
        sortByTimeL.numberOfLines = 1;
        [sortView addSubview:sortByTimeL];
        
        self.contentView.backgroundColor = UICOLOR(@"#FFFFFF");  
    }
   
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(16);
//        make.bottom.mas_equalTo(10);
        make.width.mas_equalTo(42);
        make.height.mas_equalTo(21);
    }];
    
    [sortView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(12);
    }];
    
    [_sortByTimeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    
    [sortByTimeL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(12);
    }];
    
}


/* 评论查询 - 时间/热度 */
- (void)sortByTimeAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sortByTime:)]) {
        [self.delegate sortByTime:sender];
        [self updateSortStatus:sender];
    }
}

/* 更新查询状态 */
- (void)updateSortStatus:(UIButton *)sender {
    if (sender.isSelected) {
        sortByTimeL.text = @"按热度";
    } else {
        sortByTimeL.text = @"按时间";
    }
}
     
@end
