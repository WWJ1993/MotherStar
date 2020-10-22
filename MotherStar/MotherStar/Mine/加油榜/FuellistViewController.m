//
//  FuellistViewController.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/16.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "FuellistViewController.h"
#import "FuellistViewCell.h"
#import "RequestHandle.h"
#import "GetFuelUserModel.h"
//#define ZS_ISIphoneX    (([UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width) >= 2.16)
//#define ZS_StatusBarHeight (ZS_ISIphoneX ? 44.f : 20.f)
@interface FuellistViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger pageNum;
//@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation FuellistViewController
//{
////    NSMutableArray *_dataArray;//管理数据源
//    UITableView *tableView;
////    NSNumber *pageNum;
////    NSNumber *pageSize;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加油榜";
    self.gk_navigationItem.title = @"加油榜";
//    pageNum = @(1);
//    pageSize = @(20);
    [self createTableView];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

-(void)reatDataSource
{
    
    
    NSString *fuelListUrl = [BaseUrl stringByAppendingFormat:self.isVideo?@"/integral/getOilVideoList": @"/integral/getOilPostList"];
    NSString *token = token();
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@(self.pageNum) forKey:@"pageNum"];
    [param setValue:self.pid forKey: self.isVideo?@"videoId":@"postId"];

    [[RequestManager sharedInstance] GET:fuelListUrl parameters:param authorization:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.dataArray removeAllObjects];
            MJRefreshDispatchAsyncOnMainQueue(self.tableView.mj_footer.state = MJRefreshStateIdle;)
            [self.tableView.mj_header endRefreshing];
        }
        self.pageNum++;

        
        if ([[response valueForKey:@"code"] intValue] == 0) {
            NSArray *getFuelArray = response[@"data"][@"list"];
            for (NSInteger i = 0; i < getFuelArray.count; i++) {
                NSDictionary *fulDic = getFuelArray[i];
                
                NSString *supportNum = fulDic[@"supportNum"];
                NSNumber *integralNumber = fulDic[@"integral"][@"integral"];
                NSInteger integral = [integralNumber integerValue];
                NSString *picUrl = fulDic[@"user"][@"picUrl"];
                NSString *nickName = fulDic[@"user"][@"nickName"];

                GetFuelUserModel *userModel = [[GetFuelUserModel alloc] init];
                userModel.integral = integral;
                userModel.picUrl = picUrl;
                userModel.supportNum = supportNum;
                userModel.nickName = nickName;
                [self.dataArray addObject:userModel];

            }
            
            
            self.label.text = [NSString stringWithFormat: @"共 %ld 位",self.dataArray.count];
            if ([self.tableView.mj_footer isRefreshing]) {
                if (getFuelArray.count) {
                    if (self.footerView.frame.size.height>0) {
                        self.footerView.frame = CGRectMake(0, 0, SCREENWIDTH, 0);
                    }
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    self.pageNum--;

                    CGFloat heigth = self.tableView.frame.size.height - self.tableView.rowHeight * self.dataArray.count - self.tableView.mj_footer.mj_h;
                    self.footerView.frame = CGRectMake(0, 0, SCREENWIDTH, heigth>0?heigth:0);
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            [self.tableView reloadData];


        }else{
            
            if ([self.tableView.mj_footer isRefreshing]) {
                [self.tableView.mj_footer endRefreshing];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];

    
    
//    _dataArray = [[NSMutableArray alloc]init];
//    NSDictionary *param = @{@"pageNum":pageNum,@"pageSize":pageSize,@"postId":@(1)};
//
//    if (1) {
//
//
//    }else{
//
//
//
//
//    }
    
    
}

#pragma mark -  关于UITableView
-(void)createTableView
{
    
   
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, CGRectGetMaxY(self.gk_navigationBar.frame)+8, SCREENWIDTH-30, 14);
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentRight;
    label.alpha = 1.0;
    
    [self.view addSubview:label];
    self.label = label;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(self.gk_navigationBar.frame)+30 , SCREENWIDTH, SCREENHEIGHT-CGRectGetMaxY(self.gk_navigationBar.frame)-30) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.rowHeight = 48;
    tableView.sectionFooterHeight=0;
    tableView.tableFooterView = self.footerView;
    [self.view addSubview:tableView];

    self.tableView = tableView;
    self.tableView.mj_header   = [StarRefreshGifHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self reatDataSource];
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reatDataSource)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"———————— The End ————————" forState:MJRefreshStateNoMoreData];

//    footer.stateLabel.hidden = YES;
    self.tableView.mj_footer = footer;


}
#pragma mark - UITableViewDataSource Method


//必须要实现的数据源代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetFuelUserModel *model = self.dataArray[indexPath.row];
    
    FuellistViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FuellistViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FuellistViewCell" owner:nil options:nil].firstObject;
    }
    cell.model = model;
    cell.numLab.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    return cell;

    
}





- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView new];
    }
    return _footerView;
}


@end
