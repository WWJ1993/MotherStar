//
//  SearchResultViewController.m
//  MotherStar
//
//  Created by 王文杰 on 2020/2/3.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()<UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UILabel *relestLab;
@end

@implementation SearchResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.url = @"/post/search";
    [self.params setValue:self.keyword forKey:@"keyword"];
    WeakSelf;
    self.loadBlock = ^{
        weakSelf.relestLab.text = [NSString stringWithFormat:@"搜素结果%ld条",weakSelf.braninholesArray.count];
    };
    [self setUI];
    
    [self.hotBrainholeTableView.mj_header beginRefreshing];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

}

- (void)setUI{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //        backBtn.backgroundColor = [UIColor redColor];
    //        backBtn.titleLabel.font = FONT(14);
    //        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    //        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREENWIDTH-75, 30)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    [titleView addSubview:searchBar];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) { // iOS 11
        [NSLayoutConstraint activateConstraints:@[
                                                  [searchBar.topAnchor constraintEqualToAnchor:titleView.topAnchor],
                                                  [searchBar.leftAnchor constraintEqualToAnchor:titleView.leftAnchor],
                                                  [searchBar.rightAnchor constraintEqualToAnchor:titleView.rightAnchor],
                                                  [searchBar.bottomAnchor constraintEqualToAnchor:titleView.bottomAnchor]
                                                  ]];
    } else {
        searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    searchBar.placeholder = @"请输入关键词";
//    searchBar.backgroundImage = [NSBundle py_imageNamed:@"clearImage"];
    searchBar.delegate = self;
    for (UIView *subView in [[searchBar.subviews lastObject] subviews]) {
        if ([[subView class] isSubclassOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subView;
            textField.font = [UIFont systemFontOfSize:16];
//            _searchTextField = textField;
            break;
        }
    }
    searchBar.text = self.keyword;
    self.searchBar = searchBar;
    
//    titleView.backgroundColor = [UIColor redColor];
//    self.navigationItem.titleView = titleView;
    self.gk_navTitleView =titleView;
    
    UILabel *relestLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.gk_navigationBar.frame), SCREENWIDTH-30, 40)];
    relestLab.textColor = [UIColor colorWithHex:@"868686"];
    relestLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:relestLab];
    
    self.relestLab = relestLab;
    
    
    self.hotBrainholeTableView.tableHeaderView.frame =     self.hotBrainholeTableView.frame = CGRectMake(0, CGRectGetMaxY(self.relestLab.frame), SCREENWIDTH, SCREENHEIGHT-CGRectGetMaxY(self.relestLab.frame));

//    UILabel *endLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.hotBrainholeTableView.frame), SCREENWIDTH-30, 40)];
//    endLab.textColor = [UIColor colorWithHex:@"343338"];
//    endLab.font = [UIFont systemFontOfSize:14];
//    endLab.textAlignment = NSTextAlignmentCenter;
//    endLab.text = @"———————— The End ————————";
//    endLab.adjustsFontSizeToFitWidth = YES;
//    [self.view addSubview:endLab];
    

    
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSMutableArray *searchHistories = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath]];
//    if (self.keyword.length && ![searchHistories containsObject:self.keyword]) {
        [searchHistories insertObject:self.keyword atIndex:0];
        BOOL success = [NSKeyedArchiver archiveRootObject:searchHistories toFile:self.searchHistoriesCachePath];
//    }
    if (success && self.searchClickBlock) {
        self.searchClickBlock(self.keyword);
    }
    
    [self.hotBrainholeTableView.mj_header beginRefreshing];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.keyword = searchText;
    [self.params setValue:self.keyword forKey:@"keyword"];
//    [self.hotBrainholeTableView.mj_header beginRefreshing];
//    NSLog(@"%@",searchText);
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
