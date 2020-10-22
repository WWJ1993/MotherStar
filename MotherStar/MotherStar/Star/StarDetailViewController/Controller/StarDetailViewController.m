//
//  StarDetailViewController.m
//  MotherStar
//
//  Created by 王文杰 on 2020/1/13.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "StarDetailViewController.h"
#import "ReleaseCell.h"
#import "ReleaseImgCell.h"
#import "StarDetailVideoCell.h"
#import "ReleaseModel.h"
#import "HotBrainholeModel.h"
#import "HotBrainholeTextTableViewCell.h"
#import "HotBrainholeVideoTableViewCell.h"
#import "BrainholeDetailsViewController.h"
#import "HotBrainholeVideoModel.h"
#import "LYEmptyViewHeader.h"

@interface StarDetailViewController ()//<UITableViewDelegate,UITableViewDataSource>
{
    NSString *firstPictureUrl;  //脑洞第一张图片地址
}
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UIView *headerView;
//@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak) UIImageView *headerBgView;
@property (nonatomic, weak) UILabel *lab;
@property (nonatomic, weak) UILabel *starIntroduce;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) BOOL isTime;

@end

@implementation StarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navigationItem.title =@"星球";
    self.gk_navigationBar.hidden = NO;
    self.url = @"/post/starDetails";
    [self.params setValue:self.pid forKey:@"ids"];
    [self.params setValue:@"-oil_num" forKey:@"sort"];

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
    
    self.hotBrainholeTableView.tableHeaderView.frame =     self.hotBrainholeTableView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), SCREENWIDTH, SCREENHEIGHT-CGRectGetMaxY(self.headerView.frame));

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.gk_navigationBar setGk_navBarBackgroundAlpha:0];
      self.gk_navTitleColor = [UIColor whiteColor];
    [self star];
    [self.hotBrainholeTableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;//半透明
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.gk_navigationBar setGk_navBarBackgroundAlpha:1];
      self.gk_navTitleColor = [UIColor blackColor];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)timeAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.isTime = btn.selected;
    if (self.isTime) {
        [self.params setValue:@"-createTime" forKey:@"sort"];
    }else{
        [self.params setValue:@"-oil_num" forKey:@"sort"];
    }
    [self.hotBrainholeTableView.mj_header beginRefreshing];
}
//post/starById
- (void)star{
    NSString *token = token();
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/post/starById"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.pid forKey:@"id"];
    if (self.isTime) {
        [dic setValue:@"-createTime" forKey:@"sort"];
    }

    [[RequestManager sharedInstance] GET:Url parameters:dic authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        if ([[response valueForKey:@"code"] intValue]  == 0) {
            NSString *starLogo = [NSString nullToString :[[response valueForKey:@"data"] valueForKey:@"starFile"]];
            [self.headerBgView sd_setImageWithURL:[NSURL URLWithString:starLogo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            NSDictionary *data = [response valueForKey:@"data"];
            NSString *tagTitle = [data valueForKey:@"tagTitle"];
            self.gk_navigationItem.title = tagTitle;
            NSString *postNum = [NSString stringWithFormat:@"%@", [data valueForKey:@"postNum"]];
            NSString *tagHot = [NSString stringWithFormat:@"%@",[data valueForKey:@"tagHot"]];
            NSString *str = [NSString stringWithFormat: @"项目 %@    热度指数 %@",postNum,tagHot];

            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];

            [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18]            range:[str rangeOfString:postNum]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18]            range:[str rangeOfString:tagHot]];

            self.lab.attributedText = attrStr;
            
            NSString *starIntroduce = [[response valueForKey:@"data"] valueForKey:@"starIntroduce"];
            self.starIntroduce.text = starIntroduce;
            
            CGFloat height = [self getStringHeightWithText:self.starIntroduce.text font:[UIFont systemFontOfSize:10] viewWidth:SCREENWIDTH]+250;

            self.headerView.frame = CGRectMake(0, 0, SCREENWIDTH, height);
            self.hotBrainholeTableView.tableHeaderView.frame =     self.hotBrainholeTableView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), SCREENWIDTH, SCREENHEIGHT-CGRectGetMaxY(self.headerView.frame));
;
            
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;

   // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectZero];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        imageV.image = [UIImage imageNamed:@"placeholder"];
        [_headerView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-50);
        }];
        self.headerBgView = imageV;
        
        UIButton *btn = [UIButton new];
        [btn setImage:[UIImage imageNamed:@"soryByTime"] forState:UIControlStateNormal];
        [btn setTitle:@" 按热度" forState:UIControlStateSelected];
        [btn setTitle:@" 按时间" forState:UIControlStateNormal];

//        [btn setTitleColor:[UIColor colorWithHex:@"dfdfdf"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:@"272727"] forState:UIControlStateNormal];


        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(timeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageV.mas_bottom).mas_offset(5);
            make.bottom.mas_equalTo(_headerView.mas_bottom).mas_offset(-5);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(70);
        }];
        
        UILabel *lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = [UIColor whiteColor];
        [_headerView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(StatusAndNaviHeight+ 15);
        }];
        self.lab = lab;
        
        
        UILabel *subLab = [UILabel new];
        subLab.font = [UIFont systemFontOfSize:12];
        subLab.textColor = [UIColor whiteColor];
//        subLab.backgroundColor = [UIColor redColor];
        subLab.numberOfLines = 0;
        [_headerView addSubview:subLab];
        [subLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(imageV.mas_bottom).mas_offset(-5);
            make.top.mas_equalTo(lab.mas_bottom).mas_offset(10);
        }];
        self.starIntroduce = subLab;
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
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
