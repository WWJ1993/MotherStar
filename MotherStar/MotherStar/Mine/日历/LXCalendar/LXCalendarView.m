//
//  LXCalendarView.m
//  LXCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2020年 漫漫. All rights reserved.
//

#import "LXCalendarView.h"
#import "LXCalendarHearder.h"
#import "LXCalendarWeekView.h"
#import "LXCalenderCell.h"
#import "LXCalendarMonthModel.h"
#import "NSDate+GFCalendar.h"
#import "LXCalendarDayModel.h"
#import "UIView+LX_Frame.h"
#import "RequestHandle.h"
@interface LXCalendarView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)LXCalendarHearder *calendarHeader; //头部
@property(nonatomic,strong)LXCalendarWeekView *calendarWeekView;//周
@property(nonatomic,strong)UICollectionView *collectionView;//日历
@property(nonatomic,strong)NSMutableArray *monthdataA;//当月的模型集合
@property(nonatomic,strong)NSDate *currentMonthDate;//当月的日期
@property(nonatomic,strong)UISwipeGestureRecognizer *leftSwipe;//左滑手势
@property(nonatomic,strong)UISwipeGestureRecognizer *rightSwipe;//右滑手势


@end
@implementation LXCalendarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.currentMonthDate = [NSDate date];

        [self setup];
        
        
    }
    return self;
}
-(void)dealData{
    
    
    [self responData];
}
-(void)setup{
    [self addSubview:self.calendarHeader];
    __weak __typeof__(self) weakSelf = self;

//    WeakSelf(WeakSelf);
    self.calendarHeader.leftClickBlock = ^{
        [weakSelf rightSlide];
    };
    
    self.calendarHeader.rightClickBlock = ^{
        [weakSelf leftSlide];

    };
    [self addSubview:self.calendarWeekView];
    
    [self addSubview:self.collectionView];
    
    self.lx_height = self.collectionView.lx_bottom;
    
    
    //添加左滑右滑手势
   self.leftSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
   self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.collectionView addGestureRecognizer:self.leftSwipe];
    
    self.rightSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.collectionView addGestureRecognizer:self.rightSwipe];
}
#pragma mark --左滑手势--
-(void)leftSwipe:(UISwipeGestureRecognizer *)swipe{
    
    [self leftSlide];
}
#pragma mark --左滑处理--
-(void)leftSlide{
    self.currentMonthDate = [self.currentMonthDate nextMonthDate];
    
    [self performAnimations:kCATransitionFromRight];
    [self responData];
    [_view removeFromSuperview];
}
#pragma mark --右滑处理--
-(void)rightSlide{
    
    self.currentMonthDate = [self.currentMonthDate previousMonthDate];
    [self performAnimations:kCATransitionFromLeft];
    
    [self responData];
    [_view removeFromSuperview];

}
#pragma mark --右滑手势--
-(void)rightSwipe:(UISwipeGestureRecognizer *)swipe{
   
    [self rightSlide];
}
#pragma mark--动画处理--
- (void)performAnimations:(NSString *)transition{
    CATransition *catransition = [CATransition animation];
    catransition.duration = 0.5;
    [catransition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    catransition.type = kCATransitionPush; //choose your animation
    catransition.subtype = transition;
    [self.collectionView.layer addAnimation:catransition forKey:nil];
}

-(void)requestData:(NSNumber*) date{
    NSString *token = token();
//    NSString *token = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoidXNlciIsInVzZXJOYW1lIjoiMTc4MDIxNTAwMjUiLCJleHAiOjE1NzY4MjMxOTYsInVzZXJJZCI6Ijc3In0.NdLgxnoRj0oNaSGuowGEXbaIgKnv44LYWaA57J2l1Ks";
//    NSDictionary *dic = @{@"Authorization":token,@"date":date};
//    [RequestHandle getCalendarMonth:dic authorization:token progress:^(NSProgress * _Nonnull progress) {
//
//    } success:^(id  _Nullable response) {
//
//    } fail:^(NSError * _Nonnull error) {
//
//    }];
}


#pragma mark--数据以及更新处理--
-(void)responData{
    
    [self.monthdataA removeAllObjects];
    
    NSDate *previousMonthDate = [self.currentMonthDate previousMonthDate];
    
    NSDate *nextMonthDate = [self.currentMonthDate  nextMonthDate];
    
    LXCalendarMonthModel *monthModel = [[LXCalendarMonthModel alloc]initWithDate:self.currentMonthDate];
    
    LXCalendarMonthModel *lastMonthModel = [[LXCalendarMonthModel alloc]initWithDate:previousMonthDate];
    
     LXCalendarMonthModel *nextMonthModel = [[LXCalendarMonthModel alloc]initWithDate:nextMonthDate];
    
    self.calendarHeader.dateStr = [NSString stringWithFormat:@"%ld年%ld月",monthModel.year,monthModel.month];
    NSString *dateSt;
    if (monthModel.month<10) {
       dateSt = [NSString stringWithFormat:@"%ld0%ld",monthModel.year,monthModel.month];
    }else{
        dateSt = [NSString stringWithFormat:@"%ld%ld",monthModel.year,monthModel.month];
    }
    NSNumber *date = @([dateSt intValue]);
    NSString *token = token();
       NSDictionary *dic = @{@"Authorization":token,@"date":date};
       [RequestHandle getCalendarMonth:dic authorization:token progress:^(NSProgress * _Nonnull progress) {
           
       } success:^(id  _Nullable response) {
           
            NSInteger firstWeekday = monthModel.firstWeekday;
               
               NSInteger totalDays = monthModel.totalDays;

               for (int i = 0; i <35; i++) {
                   
                   LXCalendarDayModel *model =[[LXCalendarDayModel alloc]init];
                   
                   //配置外面属性
                   [self configDayModel:model];
                   
                   model.firstWeekday = firstWeekday;
                   model.totalDays = totalDays;
                   
                   model.month = monthModel.month;
                   
                   model.year = monthModel.year;
                   
//                   int x = arc4random() % 2;
//                   model.isCun = x;
//
                   
                   //上个月的日期
                   if (i < firstWeekday) {
                       model.day = lastMonthModel.totalDays - (firstWeekday - i) + 1;
                       model.isLastMonth = YES;
                   }
                   
                   //当月的日期
                   if (i >= firstWeekday && i < (firstWeekday + totalDays)) {
                       
                       model.day = i -firstWeekday +1;
                       model.isCurrentMonth = YES;
                       
                       
//                       增加标识
                      NSArray *array = response[@"data"];
                       for (NSDictionary *dicDate in array) {
                           NSString *dayString = [NSString stringWithFormat:@"%ld",model.day];
                           NSString *monthString = [NSString stringWithFormat:@"%ld",model.month];
                           
                           if (model.day<10) {
                               dayString = [NSString stringWithFormat:@"0%ld",model.day];
                           }
                           if (model.month<10) {
                               monthString = [NSString stringWithFormat:@"0%ld",model.month];
                           }
                           NSString *dateString = [NSString stringWithFormat:@"%ld%@%@",model.year,monthString,dayString];
                           
                           
                           
                           NSString *dateTime = [NSString stringWithFormat:@"%@",dicDate[@"create_time"]];
                           
                           if ([dateString isEqualToString:dateTime]) {
                               model.isCun = 1;
                               model.dicNum = dicDate;
                           }
                       }

                       //标识是今天
                       if ((monthModel.month == [[NSDate date] dateMonth]) && (monthModel.year == [[NSDate date] dateYear])) {
                           if (i == [[NSDate date] dateDay] + firstWeekday - 1) {
                               
                               model.isToday = YES;
                               model.isSelected = YES;
                               if (self.selectBlock) {
                                   self.selectBlock(model.year, model.month, model.day,model.isCun, model.dicNum);
                               }
                           }
                       }else if(model.day == 1){
                           model.isSelected = YES;
                           if (self.selectBlock) {
                               self.selectBlock(model.year, model.month, model.day,model.isCun, model.dicNum);
                           }
                       }
                       
                   }
                   
                    //下月的日期
                   if (i >= (firstWeekday + monthModel.totalDays)) {
                       
           //            model.day = i -firstWeekday - nextMonthModel.totalDays +1;
           //            model.isNextMonth = YES;
                       break;
                   }
                   
                   
                 
                   
                   [self.monthdataA addObject:model];
                   
               }

               [self.collectionView reloadData];
           
           
       } fail:^(NSError * _Nonnull error) {
           
       }];
    
    
//    NSInteger firstWeekday = monthModel.firstWeekday;
//
//    NSInteger totalDays = monthModel.totalDays;
//
//    for (int i = 0; i <35; i++) {
//
//        LXCalendarDayModel *model =[[LXCalendarDayModel alloc]init];
//
//        //配置外面属性
//        [self configDayModel:model];
//
//        model.firstWeekday = firstWeekday;
//        model.totalDays = totalDays;
//
//        model.month = monthModel.month;
//
//        model.year = monthModel.year;
//        int x = arc4random() % 2;
//        model.isCun = x;
//
//        //上个月的日期
//        if (i < firstWeekday) {
//            model.day = lastMonthModel.totalDays - (firstWeekday - i) + 1;
//            model.isLastMonth = YES;
//        }
//
//        //当月的日期
//        if (i >= firstWeekday && i < (firstWeekday + totalDays)) {
//
//            model.day = i -firstWeekday +1;
//            model.isCurrentMonth = YES;
//
//            //标识是今天
//            if ((monthModel.month == [[NSDate date] dateMonth]) && (monthModel.year == [[NSDate date] dateYear])) {
//                if (i == [[NSDate date] dateDay] + firstWeekday - 1) {
//
//                    model.isToday = YES;
//
//                }
//            }
//
//        }
//         //下月的日期
//        if (i >= (firstWeekday + monthModel.totalDays)) {
//
////            model.day = i -firstWeekday - nextMonthModel.totalDays +1;
////            model.isNextMonth = YES;
//            break;
//        }
//
//
//        [self.monthdataA addObject:model];
//
//    }
//
//    [self.collectionView reloadData];
    
}
-(void)configDayModel:(LXCalendarDayModel *)model{
    

    //配置外面属性
    model.isHaveAnimation = self.isHaveAnimation;
    
    model.currentMonthTitleColor = self.currentMonthTitleColor;
    
    model.lastMonthTitleColor = self.lastMonthTitleColor;
    
    model.nextMonthTitleColor = self.nextMonthTitleColor;
    
    model.selectBackColor = self.selectBackColor;
    
    model.isHaveAnimation = self.isHaveAnimation;
    
    model.todayTitleColor = self.todayTitleColor;
    
    model.isShowLastAndNextDate = self.isShowLastAndNextDate;
    model.selectLabelColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.monthdataA.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"cell";
    LXCalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    if (!cell) {
        cell =[[LXCalenderCell alloc]init];
        
    }
    
    cell.model = self.monthdataA[indexPath.row];

    cell.backgroundColor =[UIColor whiteColor];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    LXCalendarDayModel *model = self.monthdataA[indexPath.row];
    model.isSelected = YES;
    
    [self.monthdataA enumerateObjectsUsingBlock:^(LXCalendarDayModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj != model) {
            obj.isSelected = NO;
        }
    }];
    
    if (self.selectBlock) {
        self.selectBlock(model.year, model.month, model.day,model.isCun, model.dicNum);
    }
    [collectionView reloadData];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.calendarHeader.frame = CGRectMake(0, 0, self.lx_width, 44);
}
#pragma mark---懒加载
-(LXCalendarHearder *)calendarHeader{
    if (!_calendarHeader) {
        _calendarHeader =[LXCalendarHearder showView];
        _calendarHeader.frame = CGRectMake(0, 0, self.lx_width, 35);
        _calendarHeader.backgroundColor =[UIColor whiteColor];
    }
    return _calendarHeader;
}
-(LXCalendarWeekView *)calendarWeekView{
//    if (!_calendarWeekView) {
//        _calendarWeekView =[[LXCalendarWeekView alloc]initWithFrame:CGRectMake(0, self.calendarHeader.lx_bottom, self.lx_width, 50)];
//        _calendarWeekView.weekTitles = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
//    }
    
    if (!_calendarWeekView) {
        _calendarWeekView =[[LXCalendarWeekView alloc]initWithFrame:CGRectMake(0, self.calendarHeader.lx_bottom, self.lx_width, 44)];
        _calendarWeekView.weekTitles = @[@" S ",@" M ",@" Y ",@" W ",@" T ",@" T ",@" S "];
    }
    
    
    return _calendarWeekView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flow =[[UICollectionViewFlowLayout alloc]init];
        //325*403
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 0;
        flow.sectionInset =UIEdgeInsetsMake(0 , 0, 0, 0);
        
        flow.itemSize = CGSizeMake(self.lx_width/7, 44);
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, self.calendarWeekView.lx_bottom, self.lx_width, 5 * 44+10) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        UINib *nib = [UINib nibWithNibName:@"LXCalenderCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];
        _collectionView.layer.cornerRadius = 10;
//        _collectionView.layer.masksToBounds = YES;
//        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.clipsToBounds = NO;
        _collectionView.layer.shadowColor = [UIColor colorWithRed:131/255.0 green:134/255.0 blue:163/255.0 alpha:0.12].CGColor;
        _collectionView.layer.shadowOffset = CGSizeMake(0,6);
        _collectionView.layer.shadowOpacity = 1;
        _collectionView.layer.shadowRadius = 5;
        
    }
    return _collectionView;
}
-(NSMutableArray *)monthdataA{
    if (!_monthdataA) {
        _monthdataA =[NSMutableArray array];
    }
    return _monthdataA;
}

/*
 * 当前月的title颜色
 */
-(void)setCurrentMonthTitleColor:(UIColor *)currentMonthTitleColor{
    _currentMonthTitleColor = currentMonthTitleColor;
}
/*
 * 上月的title颜色
 */
-(void)setLastMonthTitleColor:(UIColor *)lastMonthTitleColor{
    _lastMonthTitleColor = lastMonthTitleColor;
}
/*
 * 下月的title颜色
 */
-(void)setNextMonthTitleColor:(UIColor *)nextMonthTitleColor{
    _nextMonthTitleColor = nextMonthTitleColor;
}

/*
 * 选中的背景颜色
 */
-(void)setSelectBackColor:(UIColor *)selectBackColor{
    _selectBackColor = selectBackColor;
}

/*
 * 选中的是否动画效果
 */

-(void)setIsHaveAnimation:(BOOL)isHaveAnimation{
    
    _isHaveAnimation  = isHaveAnimation;
}

/*
 * 是否禁止手势滚动
 */
-(void)setIsCanScroll:(BOOL)isCanScroll{
    _isCanScroll = isCanScroll;
    
    self.leftSwipe.enabled = self.rightSwipe.enabled = isCanScroll;
}

/*
 * 是否显示上月，下月的按钮
 */

-(void)setIsShowLastAndNextBtn:(BOOL)isShowLastAndNextBtn{
    _isShowLastAndNextBtn  = isShowLastAndNextBtn;
    self.calendarHeader.isShowLeftAndRightBtn = isShowLastAndNextBtn;
}


/*
 * 是否显示上月，下月的的数据
 */
-(void)setIsShowLastAndNextDate:(BOOL)isShowLastAndNextDate{
    _isShowLastAndNextDate =  isShowLastAndNextDate;
}
/*
 * 今日的title颜色
 */

-(void)setTodayTitleColor:(UIColor *)todayTitleColor{
    _todayTitleColor = todayTitleColor;
}
@end
