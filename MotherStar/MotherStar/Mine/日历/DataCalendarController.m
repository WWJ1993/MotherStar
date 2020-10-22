//
//  DataCalendarController.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/12.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "DataCalendarController.h"
#import "LXCalender.h"
#import "UIColor+Expanded.h"
#import "UIView+LX_Frame.h"
#import "RequestHandle.h"
#define WeakSelf(weakSelf)  __weak __typeof(self) weakSelf = self;
#define NAVH (MAX(Device_Width, Device_Height)  == 812 ? 88 : 64)
#define TABBARH 49
#define Device_Width  [[UIScreen mainScreen] bounds].size.width//获取屏幕宽高
#define Device_Height [[UIScreen mainScreen] bounds].size.height
@interface DataCalendarController ()
@property(nonatomic,strong)LXCalendarView *calenderView;
@end

@implementation DataCalendarController
{
    UIView *showView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.gk_navigationItem.title = @"数据日历";
    self.calenderView =[[LXCalendarView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.gk_navigationBar.frame), Device_Width - 0, 0)];
    self.calenderView.currentMonthTitleColor =[UIColor hexStringToColor:@"343338"];
    self.calenderView.lastMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    self.calenderView.nextMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    
    self.calenderView.isHaveAnimation = YES;
    
    self.calenderView.isCanScroll = YES;
    
    self.calenderView.isShowLastAndNextBtn = YES;
    
    self.calenderView.isShowLastAndNextDate = YES;

    self.calenderView.todayTitleColor =[UIColor purpleColor];
    
    self.calenderView.selectBackColor =[UIColor colorWithRed:102/255.0 green:146/255.0 blue:238/255.0 alpha:1.0];

    self.calenderView.backgroundColor =[UIColor whiteColor];
    
    [self.calenderView dealData];
    
    [self.view addSubview:self.calenderView];
    
    __weak __typeof__(self) weakSelf = self;
    self.calenderView.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day, NSInteger isCun, NSDictionary *dicNum) {
        NSLog(@"%ld年 - %ld月 - %ld日---%ld",(long)year,(long)month,(long)day,(long)isCun);
            [self->showView removeFromSuperview];
            [weakSelf ShowAction:dicNum];

    };

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


-(void) ShowAction:(NSDictionary *)dic{
//    发布脑洞，上传视频，收到评论，支持消耗燃料量，获得支持燃料量
    
    if (dic != nil) {
        showView = [[UIView alloc]initWithFrame:CGRectMake(0, self.calenderView.lx_bottom+31,self.view.frame.size.width,200)];
          [self.view addSubview:showView];
        
          NSArray *labelNumArray =@[dic[@"postNum"],dic[@"videoNum"],dic[@"commentNum"],dic[@"loseNum"],dic[@"getNum"]];
          CGFloat y=0;
        NSString *str1 = [NSString stringWithFormat:@"发布了 %@ 个视频", dic[@"videoNum"]];
          NSString *str2 = [NSString stringWithFormat:@"上传了 %@ 个视频",dic[@"postNum"]];
          NSString *str3 = [NSString stringWithFormat:@"收到了 %@ 条评论",dic[@"commentNum"]];
          NSString *str4 = [NSString stringWithFormat:@"支持梦想消耗了 %@L 燃料",dic[@"loseNum"]];
          NSString *str5 = [NSString stringWithFormat:@"才华出众获得了 %@L 燃料",dic[@"getNum"]];
          NSArray *labelTit=@[str1,str2,str3,str4,str5];
          
          NSArray *colorBack = @[@"#EFB400",@"#FF8784",@"#6692EE",@"#6DD264",@"#B37AE6"];
          
          NSArray *rangeList1 = @[@(0),@(4),@(4),@(2),@(6),@(3)];
          NSArray *rangeList2 = @[@(0),@(4),@(4),@(2),@(6),@(3)];
          NSArray *rangeList3 = @[@(0),@(4),@(4),@(2),@(6),@(3)];
          NSArray *rangeList4 = @[@(0),@(8),@(8),@(3),@(11),@(2)];
          NSArray *rangeList5 = @[@(0),@(8),@(8),@(3),@(11),@(2)];
          NSArray *range = @[rangeList1,rangeList2,rangeList3,rangeList4,rangeList5];
          
          for (int i=0; i<labelNumArray.count; i++) {
              UIView *view = [[UIView alloc] init];
//              if ([labelNumArray[i] isEqual:@(0)]) {
//                  view.frame = CGRectMake(26,y,12,0);
//              }else{
                  view.frame = CGRectMake(26,y,12,12);
//              }
              view.backgroundColor = [UIColor hexStringToColor:colorBack[i]];
              view.layer.cornerRadius = 6;
              [showView addSubview:view];
              
              UILabel *label = [[UILabel alloc] init];
//              if ([labelNumArray[i] isEqual:@(0)]) {
//                  label.frame = CGRectMake(view.lx_right+10,y,200,0);
//              }else{
                  label.frame = CGRectMake(view.lx_right+10,y,200,14);
//              }
              label.numberOfLines = 0;
              [showView addSubview:label];
              label.font = [UIFont systemFontOfSize:14];
              NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:labelTit[i] attributes: @{NSForegroundColorAttributeName: [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.0]}];
              NSArray *rangeList = range[i];
              [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.000000]} range:NSMakeRange([rangeList[0] integerValue], [rangeList[1] integerValue])];

              [string addAttributes:@{ NSForegroundColorAttributeName: [UIColor hexStringToColor:colorBack[i]]} range:NSMakeRange([rangeList[2] integerValue], [rangeList[3] integerValue])];

              [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.000000]} range:NSMakeRange([rangeList[4] integerValue], [rangeList[5] integerValue])];

              label.attributedText = string;
              label.textAlignment = NSTextAlignmentLeft;
              label.alpha = 1.0;
//              if ([labelNumArray[i] isEqual:@(0)]) {
//                  y=label.frame.origin.y+0+0;
//              }else{
                  y=label.frame.origin.y+label.frame.size.height+22;
//              }
          }
          
          self.calenderView.view = showView;
        
    }else{
         showView = [[UIView alloc]initWithFrame:CGRectMake(0, self.calenderView.lx_bottom+31,self.view.frame.size.width,200)];
                  [self.view addSubview:showView];
                
                  NSArray *labelNumArray =@[@"0",@"0",@"0",@"0",@"0"];
                  CGFloat y=0;
                  NSString *str1 = [NSString stringWithFormat:@"发布了 %@ 个视频", @"0"];
                  NSString *str2 = [NSString stringWithFormat:@"上传了 %@ 个视频",@"0"];
                  NSString *str3 = [NSString stringWithFormat:@"收到了 %@ 条评论",@"0"];
                  NSString *str4 = [NSString stringWithFormat:@"支持梦想消耗了 %@L 燃料",@"0"];
                  NSString *str5 = [NSString stringWithFormat:@"才华出众获得了 %@L 燃料",@"0"];
                  NSArray *labelTit=@[str1,str2,str3,str4,str5];
                  
                  NSArray *colorBack = @[@"#EFB400",@"#FF8784",@"#6692EE",@"#6DD264",@"#B37AE6"];
                  
                  NSArray *rangeList1 = @[@(0),@(4),@(4),@(2),@(6),@(3)];
                  NSArray *rangeList2 = @[@(0),@(4),@(4),@(2),@(6),@(3)];
                  NSArray *rangeList3 = @[@(0),@(4),@(4),@(2),@(6),@(3)];
                  NSArray *rangeList4 = @[@(0),@(8),@(8),@(3),@(11),@(2)];
                  NSArray *rangeList5 = @[@(0),@(8),@(8),@(3),@(11),@(2)];
                  NSArray *range = @[rangeList1,rangeList2,rangeList3,rangeList4,rangeList5];
                  
                  for (int i=0; i<labelNumArray.count; i++) {
                      UIView *view = [[UIView alloc] init];
        //              if ([labelNumArray[i] isEqual:@(0)]) {
        //                  view.frame = CGRectMake(26,y,12,0);
        //              }else{
                          view.frame = CGRectMake(26,y,12,12);
        //              }
                      view.backgroundColor = [UIColor hexStringToColor:colorBack[i]];
                      view.layer.cornerRadius = 6;
                      [showView addSubview:view];
                      
                      UILabel *label = [[UILabel alloc] init];
        //              if ([labelNumArray[i] isEqual:@(0)]) {
        //                  label.frame = CGRectMake(view.lx_right+10,y,200,0);
        //              }else{
                          label.frame = CGRectMake(view.lx_right+10,y,200,14);
        //              }
                      label.numberOfLines = 0;
                      [showView addSubview:label];
                      label.font = [UIFont systemFontOfSize:14];
                      NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:labelTit[i] attributes: @{NSForegroundColorAttributeName: [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.0]}];
                      NSArray *rangeList = range[i];
                      [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.000000]} range:NSMakeRange([rangeList[0] integerValue], [rangeList[1] integerValue])];

                      [string addAttributes:@{ NSForegroundColorAttributeName: [UIColor hexStringToColor:colorBack[i]]} range:NSMakeRange([rangeList[2] integerValue], [rangeList[3] integerValue])];

                      [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.000000]} range:NSMakeRange([rangeList[4] integerValue], [rangeList[5] integerValue])];

                      label.attributedText = string;
                      label.textAlignment = NSTextAlignmentLeft;
                      label.alpha = 1.0;
        //              if ([labelNumArray[i] isEqual:@(0)]) {
        //                  y=label.frame.origin.y+0+0;
        //              }else{
                          y=label.frame.origin.y+label.frame.size.height+22;
        //              }
                  }
                  
                  self.calenderView.view = showView;
    }
    
    
}


@end
