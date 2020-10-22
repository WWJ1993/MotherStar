//
//  GetFuelListView.m
//  MotherStar
//  加油榜
//  Created by yanming niu on 2019/12/30.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "GetFuelListView.h"
#import "GetFuelCollectionViewCell.h"
#import "GetFuelModel.h"
#import "GetFuelUserModel.h"

static NSString *getFuelCellID = @"getFuelCellWithReuseIdentifier";

@interface GetFuelListView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat height;  //整个视图高度

    CGFloat collectionViewHeight;  //加油榜高度
    
    UIView *headerView;
    UILabel *titleL;  //加油榜
    UILabel *totalL;  //加油榜总人数
    UIButton *enterButton;  //点击查看加油列表
    
    UIView *footerView;
    UILabel *fuelL;  //收到
}

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation GetFuelListView

- (NSMutableArray *)fuelUserArray {
    if (_fuelUserArray == nil) {
        _fuelUserArray = [NSMutableArray array];
    }
    return _fuelUserArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        height = frame.size.height;
        collectionViewHeight = 44;

        [self initGetFuelListView];
        
       
    }
    return self;
}

- (void)initCollectionView {
    if (self.collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        //同一行相邻两个cell的最小间距
        self.layout.minimumInteritemSpacing = 20;
        //最小两行之间的间距
        self.layout.itemSize = CGSizeMake(28, 44);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 53, SCREENWIDTH - 32, collectionViewHeight) collectionViewLayout:self.layout];
        [self.collectionView registerClass:[GetFuelCollectionViewCell class] forCellWithReuseIdentifier:getFuelCellID];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        self.collectionView.backgroundColor = UICOLOR(@"#FFFFFFFF");
        self.backgroundColor = UICOLOR(@"#FFFFFFFF");
        
        [self addSubview:self.collectionView];
    }
}

- (void)initGetFuelListView {
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:headerView];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:titleL];

    titleL.text = @"加油榜";
    titleL.font = PingFangSC_Medium(21);
    titleL.textColor = UICOLOR(@"#343338");
    titleL.numberOfLines = 1;

    totalL = [[UILabel alloc] initWithFrame:CGRectZero];
    [headerView addSubview:totalL];

    totalL.textAlignment = NSTextAlignmentRight;
    totalL.font = PingFangSC_Regular(12);
    totalL.textColor = UICOLOR(@"#343338");
    totalL.numberOfLines = 1;
    
    [self initCollectionView];
    
    footerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:footerView];

    fuelL = [[UILabel alloc] initWithFrame:CGRectZero];
    [footerView addSubview:fuelL];

    fuelL.font = PingFangSC_Regular(14);
    fuelL.textColor = UICOLOR(@"#343338");
    fuelL.numberOfLines = 1;
    
//    self.collectionView.backgroundColor = [UIColor orangeColor];
//    self.backgroundColor = [UIColor redColor];
//    headerView.backgroundColor = [UIColor greenColor];
//    footerView.backgroundColor = [UIColor blueColor];
}

/* 更新 */
- (void)updateModel:(GetFuelModel *)model {
    NSInteger fuelUsers = 0;
    NSInteger fuelNum = 0;
    if (model.isVideo) {
        fuelUsers = model.oilVideoNum;
        fuelNum = model.getVideoNum;
    } else {
        fuelUsers = model.oliPostNum;
        fuelNum = model.getOilNum;
    }
    NSString *totalString = [NSString stringWithFormat:@"%li人",(long)fuelUsers];
    totalL.attributedText = [self setAttributeSting:totalString image:[UIImage imageNamed:@"indicator_right"]];
    NSString *fuelString = [NSString stringWithFormat:@"收到 %li  ",(long)fuelNum];
    fuelL.attributedText = [self setAttributeSting:fuelString image:[UIImage imageNamed:@"fuel_black"]];
    if (self.fuelUserArray.count > 0) {
        [self.collectionView reloadData];
    }
}

- (void)setGetFuelModel:(GetFuelModel *)model {
    [self updateModel:model];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.left.mas_offset(0);
        make.right.mas_equalTo(0);
    }];
    
    [titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.width.mas_equalTo(63);
        make.height.mas_equalTo(21);
        make.bottom.mas_equalTo(headerView);
    }];
    
    [totalL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleL);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(12);
    }];
    
    [self.collectionView  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).mas_offset(12);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(collectionViewHeight);
    }];
    
    [footerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).mas_offset(14);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(14);
    }];
    
    [fuelL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerView);
    }];
   
}

- (NSAttributedString *)setAttributeSting:(NSString *)string image:(UIImage *)image {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, -2, 13, 13);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    [attributeString appendAttributedString:attachmentString];

    return attributeString;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fuelUserArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GetFuelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:getFuelCellID forIndexPath:indexPath];
    GetFuelUserModel *model = self.fuelUserArray[indexPath.row];
    cell.fuel.text = [NSString stringWithFormat:@"%li",(long)model.integral];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 14.5, 0, 14.5);
}


@end
