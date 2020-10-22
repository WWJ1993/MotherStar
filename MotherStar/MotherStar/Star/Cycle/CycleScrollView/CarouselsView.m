//
//  CarouselsView.m
//  MotherStar
//
//  Created by yanming niu on 2020/1/15.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "CarouselsView.h"
#import "CarouselsCollectionViewCell.h"
#import "CycleModel.h"

#define kLZ_Bannerinterval 3
#define kLZ_ScreenWidth  [UIScreen mainScreen].bounds.size.width

static NSString *carouselsCollectionCellID = @"CarouselsCollectionViewCellWithReuseIdentifier";


@interface CarouselsView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *bannerCollectionView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentPage;//当前页数
@property (nonatomic, assign) CGFloat bannerCellWidth; // banner图的宽度
@property (nonatomic, assign) CGFloat bannerCellHeight; //banner图的高度
@property (nonatomic, assign) CGFloat cellLeadingSpace;// cell之间的距离
@property (nonatomic, assign) CGFloat cellInsetLeftRight; // banner图在正中间时候，距离左右间距
@property (nonatomic, assign) NSInteger virtualCellCount;//虚拟的数据源 banner图个数

@end


@implementation CarouselsView

-(instancetype)initWithFrame:(CGRect)frame bannerImgWidth:(CGFloat)width bannerImgHeight:(CGFloat)height leftRightSpace:(CGFloat)space itemSpace:(CGFloat)itemSpace{
    if (self = [super initWithFrame:frame]) {
        
        
        _bannerCellWidth = kLZ_ScreenWidth - space*2;
        _bannerCellHeight = _bannerCellWidth/width*height;
        _cellInsetLeftRight = space;
        _cellLeadingSpace = itemSpace;
        
        [self setupConfigurations];
    }
    return self;
}

#pragma mark - lazyLoad
//-(NSMutableArray *)dataArray{
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray new];
//    }
//    return _dataArray;
//}

-(UICollectionView *)bannerCollectionView{
    if (!_bannerCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _bannerCollectionView= [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_bannerCollectionView setDelegate:self];
        [_bannerCollectionView setDataSource:self];
        _bannerCollectionView.backgroundColor = [UIColor whiteColor];
        [_bannerCollectionView setDecelerationRate:0.3];
        [self addSubview:_bannerCollectionView];
        _bannerCollectionView.showsHorizontalScrollIndicator = NO;
        [_bannerCollectionView registerClass:[CarouselsCollectionViewCell class] forCellWithReuseIdentifier:carouselsCollectionCellID];
        
        self.cycleArray = @[].mutableCopy;
    }
    return _bannerCollectionView;
}

//-(UIPageControl *)pageControl{
//    if (!_pageControl) {
//        _pageControl = [[UIPageControl alloc]init];
//        self.pageControl.currentPage = 0;
//        _pageControl.hidesForSinglePage = YES;
//        _pageControl.userInteractionEnabled = NO;
//        [self addSubview:self.pageControl];
//    }
//    return _pageControl;
//}
-(void)setupConfigurations{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self.bannerCollectionView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _bannerCellHeight)];
    [self.bannerCollectionView setContentInset:UIEdgeInsetsMake(0, _cellInsetLeftRight, 0, _cellInsetLeftRight)];
    
//    [self.pageControl setFrame:CGRectMake((CGRectGetWidth(self.bounds)-100)/2, CGRectGetHeight(self.bounds)-25, 100, 20)];
}

- (NSMutableArray *)cycleArray {
    if (_cycleArray == nil) {
        _cycleArray = @[].mutableCopy;
    }
    return _cycleArray;
}

- (void)setupBannerData:(NSArray *)models {
    if (!models || models.count == 0) return;
    
    //配置数据
    self.cycleArray = [NSMutableArray arrayWithArray:models];
    if (models.count == 1){
        self.virtualCellCount = 1;
        self.currentPage = 0;
    } else {
        self.virtualCellCount = 10000;
        self.currentPage = self.cycleArray.count * self.virtualCellCount/2;
        [self addTimer];
    }
    [self.bannerCollectionView reloadData];
    
    //默认滚动到指定位置
    [self layoutIfNeeded];
    [self.bannerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    //配置pageControl
//    self.pageControl.numberOfPages = self.cycleArray.count;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    //1. 计算滚动一页的偏移量。  第一个cell因为有contentInset影响，所以和后面每滚动一页有一个contentInset的区别
    CGFloat firstCellOffset = kLZ_ScreenWidth - 3*_cellInsetLeftRight + _cellLeadingSpace ;
    CGFloat otherCellOffsetX = kLZ_ScreenWidth -2*_cellInsetLeftRight+_cellLeadingSpace;
    
    //2. 此处判断是否需要改变页数
    if (fabs(velocity.x) <= 0.3) {
        CGFloat currentOffsetX = scrollView.contentOffset.x;
        self.currentPage = (currentOffsetX-firstCellOffset)/otherCellOffsetX+1+0.5;
    }else{
        if (velocity.x > 0) {
            self.currentPage ++;
        }else{
            self.currentPage --;
        }
    }
    
    //3.  如果，当然只是如果，一般来说只要虚拟个数设置过大，基本不可能滚动到头；若真到头了就只好重置currentPage的值喽
    if (self.currentPage >= self.cycleArray.count*self.virtualCellCount-1) {
        self.currentPage = self.cycleArray.count * self.virtualCellCount-1;
    }else if (self.currentPage <= 0) {
        self.currentPage = 0;
    }
    
    //4. 根据页数计算偏移量
    CGFloat offsetX;
    if (self.currentPage == 0) {
        offsetX = firstCellOffset;
    }else{
        offsetX = firstCellOffset + otherCellOffsetX * (self.currentPage-1);
    }
    
    //5. 设置scrollView滚动的最终停止位置
    *targetContentOffset = CGPointMake(offsetX, 0);
    
//    [self updatePageControl];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
     [self addTimer];
}

#pragma mark - timer

- (void)addTimer {
    if (_timer) return;
    _timer = [NSTimer timerWithTimeInterval:kLZ_Bannerinterval target:self selector:@selector(scrollToThePage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (!_timer) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollToThePage {
    
    self.currentPage ++;

    [self.bannerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
//    if (self.currentPage == self.cycleArray.count * self.virtualCellCount-1 || self.currentPage == 0) {
//        self.currentPage = self.cycleArray.count *self.virtualCellCount/2;
//        [self.bannerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    }
    
//    [self updatePageControl];
}

#pragma mark - Private
//-(void)updatePageControl{
//    self.pageControl.currentPage = self.currentPage % self.cycleArray.count;
//}



#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cycleArray.count * self.virtualCellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CarouselsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:carouselsCollectionCellID forIndexPath:indexPath];
    NSInteger row = indexPath.item % self.cycleArray.count;
    NSLog(@"\n indexPath.item  %li  -- row  %li \n", indexPath.item, row);

    CycleModel *cycleModel = self.cycleArray[row];
    cell.cycleModel = cycleModel;
    [cell setNeedsLayout];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bannerCellWidth, self.bannerCellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return _cellLeadingSpace;
}


- (void)collectionView:(CarouselsView *)carouselsView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(carouselsView:didSelectedItem:)]) {
        long itemIndex = (int) indexPath.item % self.cycleArray.count;

        [self.delegate carouselsView:carouselsView didSelectedItem:itemIndex];
    }
}

@end

