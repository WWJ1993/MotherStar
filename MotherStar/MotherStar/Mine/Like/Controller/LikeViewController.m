//
//  LikeViewController.m
//  MotherStar
//
//  Created by 王文杰 on 2020/1/13.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "LikeViewController.h"
#import "ReleaseCell.h"
#import "LikeViewController.h"
#import "HotBrainholeModel.h"
#import "HotBrainholeTextTableViewCell.h"
#import "HotBrainholeVideoTableViewCell.h"
#import "BrainholeDetailsViewController.h"
#import "HotBrainholeVideoModel.h"
#import "LYEmptyViewHeader.h"
@interface LikeViewController ()
//<UITableViewDelegate,UITableViewDataSource>
//{
//    NSString *firstPictureUrl;  //脑洞第一张图片地址
//}
//@property (nonatomic, strong)NSMutableArray *dataArray;
//@property (nonatomic, weak) UITableView *tableView;
//@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation LikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor * color = [UIColor blackColor];
    //这里我们设置的是颜色，
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    //大功告成
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    
    self.navigationItem.title = @"我的喜欢";
    self.gk_navigationItem.title = @"我的喜欢";

//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    //        backBtn.backgroundColor = [UIColor redColor];
//    //        backBtn.titleLabel.font = FONT(14);
//    //        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    //        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
//    self.gk_navLeftBarButtonItem = self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.gk_navLeftBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"back_black"] target:self action:@selector(back)];

    self.url = @"/post/myLike";
//    self.params
//    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self loadData];
    [self.hotBrainholeTableView.mj_header beginRefreshing];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
