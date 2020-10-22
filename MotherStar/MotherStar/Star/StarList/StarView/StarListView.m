//
//  StarListView.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/25.
//  Copyright © 2019 yanming niu. All rights reserved.
//


#import "StarListView.h"
#import "StarCollectionViewCell.h"
#import "StarModel.h"

static NSString *starCellID = @"StarCellWithReuseIdentifier";

@interface StarListView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat collectionViewHeight;
}

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation StarListView

- (NSMutableArray *)starsArray {
    if (_starsArray == nil) {
        _starsArray = @[].mutableCopy;
    }
    return _starsArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
     NSInteger count = self.starsArray.count;

            if (count == 0) {
                collectionViewHeight = 0;  //不显示
            } else if (count <= 4 ) {
                collectionViewHeight = 74;
            } else {
                collectionViewHeight = 169;  //两行
            }
            collectionViewHeight = 169;  //临时

            if (count > 0) {
                if (self.layout == nil) {
                    self.layout = [[UICollectionViewFlowLayout alloc] init];
                    //同一行相邻两个cell的最小间距
                    self.layout.minimumInteritemSpacing = 38;
                    //最小两行之间的间距
                    self.layout.minimumLineSpacing = 21;
                    self.layout.itemSize = CGSizeMake(50, 74);
                }
                
                if (self.collectionView == nil) {
                    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kFBaseWidth - 32, collectionViewHeight) collectionViewLayout:self.layout];
                    [self.collectionView registerClass:[StarCollectionViewCell class] forCellWithReuseIdentifier:starCellID];
                    self.collectionView.delegate = self;
                    self.collectionView.dataSource = self;
                    
                    self.collectionView.backgroundColor = UICOLOR(@"#FFFFFFFF");
                    self.backgroundColor = UICOLOR(@"#FFFFFFFF");
                    
                    [self addSubview:self.collectionView];
                }
            }
}


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.starsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:starCellID forIndexPath:indexPath];
    StarModel *model = self.starsArray[indexPath.row];
    cell.starTitle.text = model.tagTitle;
    [cell.starImageView sd_setImageWithURL:[NSURL URLWithString:model.starLogo]];
    [cell.starImageView sd_setImageWithURL:[NSURL URLWithString:model.starLogo] placeholderImage:[UIImage imageNamed:@"default_avatar"]];

    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    StarModel *model = self.starsArray[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StarDetailsNotification" object:@(model.id)]; //星球Id
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 14.5, 0, 14.5);
}

@end
