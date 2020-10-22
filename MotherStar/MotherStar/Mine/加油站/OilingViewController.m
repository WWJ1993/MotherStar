//
//  OilingViewController.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/11.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "OilingViewController.h"
#import "OilingHeadView.h"
#import "OilingTableViewCell.h"
#import "RequestHandle.h"
#import "MJRefresh.h"
#import "ShareViewController.h"
#import "MPWebViewController.h"
@interface OilingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) OilingHeadView *oilingView;
@end

@implementation OilingViewController
{
    NSMutableArray *_dataArray;//管理数据源
    UITableView *tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.title = @"加油站";
    self.gk_navigationItem.title = @"加油站";
    [self reatDataSource];
    [self createTableView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}


-(void)reatDataSource
{
    _dataArray = [[NSMutableArray alloc]init];
    NSString *token = token();

    [RequestHandle searchTask:[NSDictionary new] authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        [self->tableView.mj_header endRefreshing];
        if ([[response valueForKey:@"code"] intValue]==0) {
            
            [self->_dataArray addObjectsFromArray:response[@"data"]];
            for (int i = 0; i<self->_dataArray.count; i++) {
                NSDictionary *item =self->_dataArray[i];
                NSInteger pid = [[item valueForKey: @"id"] intValue];
                if (pid == 5) {
                    [self->_dataArray removeObjectAtIndex:i];
                    NSInteger task_score =[ [item valueForKey:@"task_score"]intValue];
                    NSInteger num =[ [item valueForKey:@"num"]intValue];
                    self.oilingView.msgLab.text = [NSString stringWithFormat: @"已成功邀请%ld位好友，并成功获得 %ldL",num,task_score*num];
                    self.oilingView.limitLab.text = [NSString stringWithFormat:@"每成功邀请一位好友得 %ldL 燃料",task_score];
                }
            }
            [self->tableView reloadData];
        }
    } fail:^(NSError * _Nonnull error) {

    }];

}

-(void)getOil:(NSNumber *)taskId{
    
    NSString *token = token();
    NSDictionary *param = @{@"taskId":taskId};
    
    [RequestHandle getOil:param authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        [self reatDataSource];
    } fail:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark -  关于UITableView
-(void)createTableView
{
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ZS_StatusBarHeight+44, self.view.frame.size.width, self.view.frame.size.height-ZS_StatusBarHeight-44) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"OilingHeadView" owner:nil options:nil];
    OilingHeadView *oilingView = [viewArray firstObject];
    tableView.tableHeaderView = oilingView;
    WeakSelf;
    oilingView.buttonAction = ^(UIButton * _Nonnull sender) {
        NSLog(@"-------------接收到邀请事件---------");
//        http://directions.motherplanet.cn/integ/
        ShareViewController *vc = [ShareViewController new];
        [weakSelf.navigationController pushViewController:vc animated:YES];

    };
    oilingView.integBlock = ^{
        MPWebViewController *vc = [MPWebViewController new];
        vc.navigationItem.title = @"玩法攻略";
        vc.url = @"http://directions.motherplanet.cn/integ/";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.oilingView = oilingView;
    
    tableView.rowHeight = 82;
    tableView.sectionFooterHeight=0;
    [self.view addSubview:tableView];
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reatDataSource];
      }];
}
#pragma mark - UITableViewDataSource Method


//必须要实现的数据源代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

//刷新和创建cell,返回要显示的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;

      OilingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OilingTableViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"OilingTableViewCell" owner:nil options:nil].firstObject;
        }
    if (indexPath.row == _dataArray.count-1) {
        setLastCellSeperatorToLeft(cell);
    }
    cell.dic = _dataArray[indexPath.row];
    cell.buttonActionCell = ^(NSNumber * _Nonnull taskId) {
        [weakSelf getOil:taskId];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

static void setLastCellSeperatorToLeft(UITableViewCell* cell)
{
//     去除最后一行cell的分割线
    cell.separatorInset =UIEdgeInsetsMake(0,0, 0, cell.bounds.size.width+200);
}

@end
