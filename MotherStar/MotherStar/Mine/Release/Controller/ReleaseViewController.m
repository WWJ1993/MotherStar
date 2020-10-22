//
//  ReleaseViewController.m
//  MotherStar
//
//  Created by 王文杰 on 2020/1/12.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "ReleaseViewController.h"
#import "ReleaseCell.h"
#import "ReleaseModel.h"
#import "SVProgressHUD.h"
#import "ReleaseImgCell.h"
#import "HotBrainholeModel.h"
#import "HotBrainholeTextTableViewCell.h"
#import "HotBrainholeVideoTableViewCell.h"
#import "BrainholeDetailsViewController.h"
#import "HotBrainholeVideoModel.h"
#import "LYEmptyViewHeader.h"
@interface ReleaseViewController ()//<UITableViewDataSource,UITableViewDelegate>
{
    NSString *firstPictureUrl;  //脑洞第一张图片地址
}
//@property (weak, nonatomic) UITableView *tableView;
//@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UIButton *selectBtn;
@property (nonatomic, strong)UIButton *postBtn;
@property (nonatomic, strong)UIButton *videoBtn;
//@property (nonatomic, assign) NSInteger pageNum;
//l
@property (nonatomic, weak) UILabel *lab;
@property (nonatomic, weak) UILabel *allLab;

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor * color = [UIColor whiteColor];
    //这里我们设置的是颜色，
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    //大功告成
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.title = self.isOil ?@"助燃项目":@"我的发布";
    
    self.gk_navigationBar.gk_statusBarHidden = NO;
    self.gk_navigationItem.title = self.navigationItem.title;
    [self.gk_navigationBar setGk_navBarBackgroundAlpha:0];
    self.gk_navTitleColor = [UIColor whiteColor];

//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    //        backBtn.backgroundColor = [UIColor redColor];
//    //        backBtn.titleLabel.font = FONT(14);
//    //        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    //        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"icon_arrow_back"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.gk_navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.gk_navLeftBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"icon_arrow_back"] target:self action:@selector(back)];

    self.extendedLayoutIncludesOpaqueBars = YES;

//    [self setUI];
    [self.view addSubview:self.headerView];
    self.hotBrainholeTableView.frame = CGRectMake(0, 270, SCREENWIDTH, SCREENHEIGHT-270);
    self.lab.text = self.isOil?@"共消耗燃料":@"共收获燃料";

    
    NSString *token = token();
    self.url = self.isOil?@"/user/getMyOilPost": @"/user/searchIssueVideo";
    NSString *atype = self.selectBtn == self.postBtn ?@"1":@"0";
    [self.params setValue:atype forKey:@"aType"];
    [self.params setValue:token forKey:@"Authorization"];

    [self.hotBrainholeTableView.mj_header beginRefreshing];
//[self.tableView.mj_header beginRefreshing];
    [self.view addSubview:self.headerView];
    
    self.allLab.text = [NSString stringWithFormat:@"%@ L",self.num];

}


- (void)back {
    if (self.isPostBrainhole) {
        RootViewController *rootVC = [[RootViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [self getCalendar];
//    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;//半透明
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;



}


- (void)getCalendar{
    NSString *token = token();
    NSString *Url = [BaseUrl stringByAppendingFormat:self.isOil?@"/user/getMyOilNum": @"/user/getCalendarNum"];
    
    [[RequestManager sharedInstance] GET:Url parameters:@{} authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    }  success:^(id  _Nullable response) {
        
        if ([[response valueForKey:@"code"] intValue] == 0) {
            [self.postBtn setTitle:[NSString stringWithFormat:@"脑洞 %@", [[response valueForKey:@"data"] valueForKey:self.isOil?@"oilPostNum": @"postNum"]] forState:UIControlStateNormal];
            [self.videoBtn setTitle:[NSString stringWithFormat:@"视频 %@", [[response valueForKey:@"data"] valueForKey:self.isOil?@"oilVideoNum":@"videoNum"]] forState:UIControlStateNormal];
        }else{
            NSString *msg = [response valueForKey:@"msg"];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:msg];
//            if ([[response valueForKey:@"msg"] stringValue].length) {
//            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];

}

- (void)selectAction:(UIButton *)btn {
    if (self.selectBtn == btn) {
        return;
    }
    btn.selected = YES;
    self.selectBtn.selected = NO;
    self.selectBtn = btn;
//    [self loadData:self.selectBtn == self.postBtn ?@"1":@"0"];
    NSString *atype = self.selectBtn == self.postBtn ?@"1":@"0";
    [self.params setValue:atype forKey:@"aType"];

    [self.hotBrainholeTableView.mj_header beginRefreshing];
}

#pragma mark - setter,getter
//- (NSMutableArray *)dataArray{
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray new];
//    }
//    return _dataArray;
//}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 270)];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 225)];
        imageV.image = [UIImage imageNamed:self.isOil?@"oil_bg": @"relase_bg"];
        [_headerView addSubview:imageV];
        
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(15, 200, SCREENWIDTH-30, 50)];
        subView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:subView];
        
        UILabel *lab = [[UILabel  alloc]initWithFrame:CGRectMake(15, 90, 100, 20)];
        lab.text = @"共消耗燃料";
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:12];
        [_headerView addSubview:lab];
        self.lab = lab;
        
        UILabel *subLab = [[UILabel  alloc]initWithFrame:CGRectMake(15, 120, SCREENWIDTH-30, 25)];
        subLab.text = @"23,454 L";
        subLab.textColor = [UIColor whiteColor];
        subLab.font = [UIFont boldSystemFontOfSize:25];
        [_headerView addSubview:subLab];
        self.allLab = subLab;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (SCREENWIDTH-30)*0.5, 40)];
        [btn setTitle:@"脑洞" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:@"EFB400"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHex:@"343338"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [subView addSubview:btn];
        btn.selected = YES;
        self.selectBtn = btn;
        self.postBtn = btn;
        
        
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake((SCREENWIDTH-30)*0.5, 0, (SCREENWIDTH-30)*0.5, 40)];
        [btn1 setTitle:@"视频" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithHex:@"EFB400"] forState:UIControlStateSelected];
        [btn1 setTitleColor:[UIColor colorWithHex:@"343338"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [subView addSubview:btn1];
        self.videoBtn = btn1;

        
    }
    return _headerView;
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
