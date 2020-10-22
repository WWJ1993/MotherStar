//
//  ReportViewController.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/17.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportViewCell.h"
@interface ReportViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *selectArray;
@end

@implementation ReportViewController
{
    NSMutableArray *_dataArray;//管理数据源
    UITableView *tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navigationItem.title = @"举报";
    [self reatDataSource];
    [self createTableView];
}

-(void)reatDataSource
{
    NSArray *SectionsTwoData = @[@[@"icon_set_wechat.png", @"微信",@"广告或垃圾信息"],@[@"icon_set_qq.png",@"QQ",@"不雅词句，辱骂和不友善"],@[@"icon_set_sina.png",@"微博",@"低俗或色情"],@[@"icon_set_wechat.png", @"微信",@"未经授权的视频资源"],@[@"icon_set_qq.png",@"QQ",@"低俗或泄漏他人隐私"],@[@"icon_set_sina.png",@"微博",@"引战或过于偏激的主观判断"],@[@"icon_set_sina.png",@"微博",@"违反相关的法律法规、管理规定"],@[@"icon_set_sina.png",@"微博",@"侵犯我的权益"],@[@"icon_set_sina.png",@"微博",@"其它原因"]];
    _dataArray = [[NSMutableArray alloc]init];
    [_dataArray addObjectsFromArray:SectionsTwoData];
    
}
#pragma mark -  关于UITableView
-(void)createTableView
{
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ZS_StatusBarHeight+44, self.view.frame.size.width, self.view.frame.size.height-ZS_StatusBarHeight-44) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.rowHeight = 50;
    tableView.sectionFooterHeight=0;
    [self.view addSubview:tableView];
    {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0,0,self.view.frame.size.width,76);
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, (76-46)/2,self.view.frame.size.width-100, 46)];
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithRed:239/255.0 green:180/255.0 blue:0/255.0 alpha:1.0];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 8;
        btn.titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        [view addSubview:btn];
        tableView.tableFooterView = view;
    }

}


-(void)click{
    if (!self.selectArray.count) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"请选择举报内容"];

        return;
    }
    [SVProgressHUD showSuccessWithStatus:@"举报成功"];
    [SVProgressHUD dismissWithDelay:1.0 completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - UITableViewDataSource Method


//必须要实现的数据源代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      ReportViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ReportViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ReportViewCell" owner:nil options:nil].firstObject;
        }
        cell.label.text = _dataArray[indexPath.row][2];
        return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReportViewCell * selectCell = [tableView cellForRowAtIndexPath:indexPath];
    if (selectCell.button.selected) {
        ReportViewCell * cell;
        for (ReportViewCell * subCell in self.selectArray) {
            if ([subCell.label.text isEqualToString:selectCell.label.text]) {
                cell = subCell;
            }
        }
        if (cell) [self.selectArray removeObject:cell];
    }else{
        if (self.selectArray.count>=3) {
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"最多选择3个"];
            return;
        }
        [self.selectArray addObject:selectCell];
    }
    selectCell.button.selected = !selectCell.button.selected;

        
}

- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

@end
