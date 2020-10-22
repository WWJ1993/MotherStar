//
//  SearchViewController.m
//  MotherStar
//
//  Created by 王文杰 on 2020/2/3.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
@interface SearchViewController ()<PYSearchViewControllerDelegate,PYSearchViewControllerDataSource>

@end

@implementation SearchViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.searchBar.placeholder = @"请输入关键词";
        self.hotSearchStyle = PYHotSearchStyleDefault;
        self.searchHistoryTitle = @"历史探索";
        self.showHotSearch = NO;

    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.gk_NavBarInit = NO;
    WeakSelf;
    self.didSearchBlock = ^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        SearchResultViewController *vc = [SearchResultViewController new];
        vc.keyword = searchText;
        vc.searchHistoriesCachePath = weakSelf.searchHistoriesCachePath;
        vc.searchClickBlock = ^(NSString * _Nonnull keyword) {
            weakSelf.searchBar.text = keyword;
        };
//        vc.searchViewControllerShowMode = PYSearchResultShowModePush;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(@"saveSearchCacheAndRefreshView")];
    #pragma clang diagnostic pop


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
