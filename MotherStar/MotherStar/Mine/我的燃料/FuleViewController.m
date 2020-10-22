//
//  FuleViewController.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/16.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "FuleViewController.h"
#import "FuleTableViewCell.h"
#import "RequestHandle.h"
#import "MJRefresh.h"
#define ZS_ISIphoneX    (([UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width) >= 2.16)
#define ZS_StatusBarHeight (ZS_ISIphoneX ? 44.f : 20.f)
@interface FuleViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *tabView;

@property (weak, nonatomic) IBOutlet UIButton *huo;

@property (weak, nonatomic) IBOutlet UIButton *xiao;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *num;


@end

@implementation FuleViewController

{
    NSMutableArray *_dataArray;//管理数据源
    NSInteger pageNum;
    NSInteger pageSize;
    NSInteger type;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tabView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _tabView.layer.cornerRadius = 8;
    _tabView.clipsToBounds=NO;
    _tabView.layer.shadowColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:0.5].CGColor;
    _tabView.layer.shadowOffset = CGSizeMake(0,1);
    _tabView.layer.shadowOpacity = 1;
    _tabView.layer.shadowRadius = 13.5;
    [self reatDataSource];
    [self createTableView];
    
    self.num.text = [NSString stringWithFormat:@"%@ L",self.numStr];
}

-(void)reatDataSource
{
    type = 0;
    pageNum = 1;
    pageSize = 20;
    _dataArray = [[NSMutableArray alloc]init];
//    [self getMyOilNum:@(type)pageNum:@(pageNum) pageSize:@(pageSize)];
}


-(void)getMyOilNum:(NSNumber*) type pageNum:(NSNumber *)pagenum pageSize:(NSNumber*) pagesize{
    
    NSString *token = token();
    NSDictionary *dic = @{@"Authorization":token,@"integralType":type,                             @"pageNum":@(pageNum),};
    [RequestHandle myIntegralList:dic authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        NSDictionary *dic = response;
        if (dic[@"code"] ) {
            
//            self->_num.text = [NSString stringWithFormat:@"%@L",dic[@"data"][@"total"]];
            NSArray *list = dic[@"data"][@"list"];
            if (!list.count) {
                self->pageNum --;
            }
            [self->_dataArray addObjectsFromArray:dic[@"data"][@"list"]];
            [self->_tableView reloadData];
            if ([self->_tableView.mj_header isRefreshing]) [self->_tableView.mj_header endRefreshing];
            if (list.count) {
                [self->_tableView.mj_footer endRefreshing];
            }else{
                [self->_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } fail:^(NSError * _Nonnull error) {
        
    }];

}



#pragma mark -  关于UITableView
-(void)createTableView
{
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.rowHeight = 70;
    _tableView.sectionFooterHeight=0;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableView.mj_header = [StarRefreshGifHeader headerWithRefreshingBlock:^{
        //进行数据刷新操作
        [self->_dataArray removeAllObjects];
        self->pageNum = 1;
        [self getMyOilNum:@(self->type)pageNum:@(self->pageNum) pageSize:@(self->pageSize)];

    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
   
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->pageNum ++;
        [self getMyOilNum:@(self->type)pageNum:@(self->pageNum) pageSize:@(self->pageSize)];
    }];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"———————— The End ————————" forState:MJRefreshStateNoMoreData];
    _tableView.mj_footer = footer;
}
#pragma mark - UITableViewDataSource Method


//必须要实现的数据源代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        FuleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FuleTableViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"FuleTableViewCell" owner:nil options:nil].firstObject;
        }
    
    cell.dic = _dataArray[indexPath.row];
//    if (indexPath.row == [_dataArray count]-1) {
//        [self createFooter];
//    }else{
//    }
        return cell;
}

-(void) createFooter{
    
    UIView *view = [[UIView alloc]init];
    if ((_dataArray.count+1)*70<_tableView.frame.size.height) {
        
        NSInteger i =_tableView.frame.size.height-_dataArray.count*70;
        view.frame =CGRectMake(0, 0, _tableView.frame.size.width, i);
    }else{
        view.frame =CGRectMake(0, 0, _tableView.frame.size.width, 66);
    }
           
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((view.frame.size.width-60)/2,view.frame.size.height-18-20,60,18);
    label.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"The End";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIView *lineLeftview = [[UIView alloc] init];
    lineLeftview.frame = CGRectMake(24,label.frame.origin.y+label.frame.size.height/2,(view.frame.size.width-60)/2-5-24,0.5);
    lineLeftview.backgroundColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.0];
    [view addSubview:lineLeftview];
    
    UIView *lineRightview = [[UIView alloc] init];
    lineRightview.frame = CGRectMake((view.frame.size.width-60)/2+60+5,label.frame.origin.y+label.frame.size.height/2,(view.frame.size.width-60)/2-5-24,0.5);
    lineRightview.backgroundColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.0];
    [view addSubview:lineRightview];
    
    _tableView.tableFooterView = view;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (IBAction)zhuanAction:(UIButton *)sender {

        _huo.titleLabel.textColor = [UIColor colorWithRed:239/255.0 green:180/255.0 blue:0/255.0 alpha:1.0];
        _xiao.titleLabel.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.0];
    pageNum = 1;
    pageSize = 20;
    type = 0;
    [_dataArray removeAllObjects];
    [self.tableView.mj_header beginRefreshing];

//    [self getMyOilNum:@(type)pageNum:@(pageNum) pageSize:@(pageSize)];
}

- (IBAction)xiaoAction:(UIButton *)sender {
    _huo.titleLabel.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.0];
    [_xiao setTitleColor:[UIColor colorWithRed:239/255.0 green:180/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    pageNum = 1;
    pageSize = 20;
    type = 2;
    [_dataArray removeAllObjects];
    [self.tableView.mj_header beginRefreshing];

//    [self getMyOilNum:@(type)pageNum:@(pageNum) pageSize:@(pageSize)];
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
