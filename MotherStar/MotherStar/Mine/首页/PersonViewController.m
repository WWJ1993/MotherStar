//
//  PersonViewController.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/10.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonHeadView.h"
#import "PersonCacheViewCell.h"
#import "PersonTableViewCell.h"
#import "AboutViewController.h"
#import "OpinionViewController.h"
#import "OilingViewController.h"
#import "DataCalendarController.h"
#import "HLAlertViewBlock.h"
#import "WMZDialog.h"
#import "MyProgressHUD.h"
#import "ProfileViewController.h"
#import "FuellistViewController.h"
#import "FuleViewController.h"
#import "ReportViewController.h"
#import "CommentViewController.h"
#import "RequestHandle.h"
#import "PYTempViewController.h"
#import "PYSearchViewController.h"
#import "PYTempViewController.h"
#import "PwdLoginViewController.h"
#import "ReleaseViewController.h"
#import "LikeViewController.h"

#import "MineLikeViewController.h"




#define fileManager [NSFileManager defaultManager]

#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
@interface PersonViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSString *getOil;
@property (nonatomic, copy) NSString *loseOil;
@property (nonatomic, copy) NSString *oil;

@end

@implementation PersonViewController
{
    NSMutableArray *_dataArray;//管理数据源
    UITableView *tableView;
    PersonHeadView *personView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self searchUser];
    [self reatDataSource];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
   [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.title = @"";
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

-(void)reatDataSource
{
    
    NSArray *SectionsOneData = @[@[@"calendar.png", @"数据日历"],@[@"filling station.png",@"加油站"],@[@"编组 4.png",@"我的喜欢"]];
    NSArray *SectionsTwoData = @[@[@"clean.png", @"清除缓存"],@[@"tickling.png",@"意见反馈"],@[@"about.png",@"关于我们"],@[@"out.png",@"退出登录"]];
    _dataArray = [[NSMutableArray alloc]init];
    [_dataArray addObject:SectionsOneData];
    [_dataArray addObject:SectionsTwoData];
}
#pragma mark -  关于UITableView
-(void)createTableView
{
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -ZS_StatusBarHeight, self.view.frame.size.width, self.view.frame.size.height+ZS_StatusBarHeight) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = YES;
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"PersonHeadView" owner:nil options:nil];
    personView = [viewArray firstObject];
    tableView.tableHeaderView = personView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakSelf = self;

    personView.imageClickTap = ^(NSInteger Tag) {
        
        switch (Tag) {
            case 0:
            {
                ProfileViewController *profileViewController = [[ProfileViewController alloc]init];
                profileViewController.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:profileViewController animated:YES];
//                FuellistViewController *fuellistController = [[FuellistViewController alloc]init];
//                [weakSelf.navigationController pushViewController:fuellistController animated:YES];
//                fuellistController.hidesBottomBarWhenPushed = YES;
            }
                break;
            case 1:
            {
                ReleaseViewController *vc = [ReleaseViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                vc.num = weakSelf.getOil;
                [weakSelf.navigationController  pushViewController:vc animated:YES ];
//                ReportViewController *roportController = [[ReportViewController alloc]init];
//                roportController.hidesBottomBarWhenPushed = YES;
//                [weakSelf.navigationController pushViewController:roportController animated:YES];
            }
                break;
            case 2:
            {
                FuleViewController *fuleController = [[FuleViewController alloc]init];
                fuleController.hidesBottomBarWhenPushed = YES;
                fuleController.numStr = weakSelf.oil;
                [weakSelf.navigationController pushViewController:fuleController animated:YES];
            }
                break;
            case 3:
            {
                ReleaseViewController *vc = [ReleaseViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                vc.isOil = YES;
                vc.num = weakSelf.loseOil;
                [weakSelf.navigationController  pushViewController:vc animated:YES ];
                
//                CommentViewController *commentController = [[CommentViewController alloc]init];
//                commentController.hidesBottomBarWhenPushed = YES;
//                [weakSelf.navigationController pushViewController:commentController animated:YES];
//                PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:NSLocalizedString(@"请输入关键字", @"") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
//                    [searchViewController.navigationController pushViewController:[[PYTempViewController alloc] init] animated:YES];
//                }];
//                searchViewController.searchHistoryStyle = PYSearchHistoryStyleBorderTag;
//                [self.navigationController pushViewController:searchViewController animated:YES];
                
            }
                break;
            
            default:
                break;
        }
        
    };
    
    //关于tableview的简单设置
    //设置行高，用属性设置是所有行都这么高
    tableView.rowHeight = 48;
    
    //设置组头视图的高度
//    tableView.sectionHeaderHeight = 0;
    tableView.sectionFooterHeight=0;
    [self.view addSubview:tableView];
}
#pragma mark - UITableViewDataSource Method


//必须要实现的数据源代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *sectionArray = _dataArray[section];
    return [sectionArray count];
}
//告诉tableView要分几组显示
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回组数
    return [_dataArray count];
}
//刷新和创建cell,返回要显示的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row == 0) {
      PersonCacheViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCacheViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PersonCacheViewCell" owner:nil options:nil].firstObject;
            cell.cache.text = [self getCacheSize];
        }
        cell.title.text = _dataArray[indexPath.section][indexPath.row][1];
        cell.image.image = [UIImage imageNamed:_dataArray[indexPath.section][indexPath.row][0]];
        return cell;
    }else{
       PersonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonTableViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PersonTableViewCell" owner:nil options:nil].firstObject;
        }
        cell.title.text = _dataArray[indexPath.section][indexPath.row][1];
        cell.image.image = [UIImage imageNamed:_dataArray[indexPath.section][indexPath.row][0]];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OilingViewController *oilingController = [[OilingViewController alloc]init];
    
    OpinionViewController *opinionController = [[OpinionViewController alloc]init];
    AboutViewController *aboutController = [[AboutViewController alloc]init];
    DataCalendarController *dataCalendarController = [[DataCalendarController alloc]init];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            dataCalendarController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dataCalendarController animated:YES];
        }else if (indexPath.row==1){
            oilingController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:oilingController animated:YES];
        }else if (indexPath.row==2){//我的喜欢
            LikeViewController *vc = [LikeViewController new];
            
//            MineLikeViewController *vc = [[MineLikeViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if (indexPath.row==0) {
            PersonCacheViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [MyProgressHUD showWithStatus:@"正在清理缓存"];

            if ([self clearCaches]) {
                cell.cache.text = @"0";
                [self performSelector:@selector(removeCachev) withObject:nil afterDelay:1.0f];
            }else{
                [self performSelector:@selector(removeCachev) withObject:nil afterDelay:1.0f];
            }
            
    
        }else if (indexPath.row==1){
            opinionController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:opinionController animated:YES];
        }else if (indexPath.row==2){
            aboutController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutController animated:YES];
        }else if (indexPath.row==3){
            WeakSelf;
            [MotherPlanetAlertView alertViewWithTitle:@"退出登录" message:@"确定退出登录" ok:@"确定" cancel:@"取消" okBlock:^{
                [PwdLoginViewController loginOutViewController:weakSelf];
            } cancelBlock:nil];
            
//            HLAlertViewBlock * alertView = [[HLAlertViewBlock alloc] initWithTittle:@"退出登录" message:@"确定退出登录？" block:^(NSInteger index) {
//                if (index == AlertBlockSureButtonClick) {
//                      [self alertCauseButtonClick];
//                }else{
//                      [self alertSureButtonClick];
//                }
//            }];
//
//            [alertView show];
        }
    }
}


-(void)removeCachev{
     [MyProgressHUD dismiss];
     [MyProgressHUD showSuccessWithStatus:@"缓存已清理" duration:1.0];
}

#pragma mark --- 弹窗点击事件
- (void)alertSureButtonClick{
    NSLog(@"点击了确认按钮");
    NSString *token = token();
    [RequestHandle signOut:[NSDictionary new] authorization:token progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        
        [PwdLoginViewController loginOutViewController:self];
//        LoginViewController *loginVC = [[LoginViewController alloc]init];
//        UIWindow *window = [UIApplication sharedApplication].windows[0];
//        window.rootViewController = loginVC;
        
    } fail:^(NSError * _Nonnull error) {

    }];
    
}
- (void)alertCauseButtonClick{
    NSLog(@"点击了取消按钮");
}


-(void)searchUser{
    
    NSString *token = token();
    [RequestHandle searchUser:[NSDictionary new] authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
      
        if ([response[@"code"] isEqual:@(0)]) {
            NSArray *sexArray = @[@"baomi",@"man1",@"woman1"];
            NSArray *sexheadArray = @[@"baomihead",@"head",@"womanhead"];
            NSURL *url = [NSURL URLWithString:response[@"data"][@"picUrl"]];
            NSNumber *gender = response[@"data"][@"gender"];
            [self->personView.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:sexheadArray[[gender intValue]]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
            }];
            self.getOil = response[@"data"][@"getOil"];
            self.loseOil = response[@"data"][@"loseOil"];
            self.oil = response[@"data"][@"oil"];

            self->personView.fabuTitleValue.text = [NSString stringWithFormat:@"已获%@L", self.getOil];
            self->personView.zhichiLabelVale.text = [NSString stringWithFormat:@"支持%@L", self.loseOil];
            self->personView.ranliaoLabel.text = [NSString stringWithFormat:@"%@L", self.oil];
            self->personView.nameLabel.text = [NSString stringWithFormat:@"%@", response[@"data"][@"nickName"]];
            self->personView.sexImageView.image = [UIImage imageNamed:sexArray[[gender intValue]]];
        }
        
    } fail:^(NSError * _Nonnull error) {
        
    }];
    
    [RequestHandle getMyOilNum:[NSDictionary new] authorization:token progress:^(NSProgress * _Nonnull progress) {

    } success:^(id  _Nullable response) {
        if ([response[@"code"] isEqual:@(0)]) {
                 self->personView.zhichiLabel.text = [NSString stringWithFormat:@"%@",response[@"data"][@"Num"]];
             }

    } fail:^(NSError * _Nonnull error) {

    }];

    [RequestHandle  getCalendarNum:[NSDictionary new] authorization:token progress:^(NSProgress * _Nonnull progress) {

    } success:^(id  _Nullable response) {
        if ([response[@"code"] isEqual:@(0)]) {
            
            self->personView.fabuTitle.text = [NSString stringWithFormat:@"%@",response[@"data"][@"AllNum"]];
        }

    } fail:^(NSError * _Nonnull error) {


    }];

}


// 获取cachePath路径下文件夹大小
- (NSString *)getCacheSize {
    
    // 调试
    #ifdef DEBUG
    // 如果文件夹不存在或者不是一个文件夹那么就抛出一个异常
    // 抛出异常会导致程序闪退,所以只在调试阶段抛出，发布阶段不要再抛了,不然极度影响用户体验
    BOOL isDirectory = NO;
    BOOL isExist = [fileManager fileExistsAtPath:cachePath isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
        NSException *exception = [NSException exceptionWithName:@"文件错误" reason:@"请检查你的文件路径!" userInfo:nil];
        [exception raise];
    }
    //发布
    #else
    #endif
    
    //获取“cachePath”文件夹下面的所有文件
    NSArray *subpathArray= [fileManager subpathsAtPath:cachePath];
    
    NSString *filePath = nil;
    long long totalSize = 0;
    
    for (NSString *subpath in subpathArray) {
        // 拼接每一个文件的全路径
        filePath =[cachePath stringByAppendingPathComponent:subpath];

        // isDirectory，是否是文件夹，默认不是
        BOOL isDirectory = NO;
        
        // isExist，判断文件是否存在
        BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        // 文件不存在,是文件夹,是隐藏文件都过滤
        if (!isExist || isDirectory || [filePath containsString:@".DS"]) continue;
   
        // attributesOfItemAtPath 只可以获得文件属性，不可以获得文件夹属性，这个也就是需要遍历文件夹里面每一个文件的原因
        long long fileSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        totalSize += fileSize;
    }
    
    // 将文件夹大小转换为 M/KB/B
    NSString *totalSizeString = nil;
    
    if (totalSize > 1000 * 1000) {
        totalSizeString = [NSString stringWithFormat:@"%.1fM",totalSize / 1000.0f /1000.0f];
    } else if (totalSize > 1000) {
        totalSizeString = [NSString stringWithFormat:@"%.1fKB",totalSize / 1000.0f ];
    } else {
        totalSizeString = [NSString stringWithFormat:@"%.1fB",totalSize / 1.0f];
    }
    return totalSizeString;
}


// 清除cachePath文件夹下缓存大小
- (BOOL)clearCaches {
    
    // 拿到cachePath路径的下一级目录的子文件夹
    // contentsOfDirectoryAtPath:error:递归
    // subpathsAtPath:不递归
    NSArray *subpathArray = [fileManager contentsOfDirectoryAtPath:cachePath error:nil];
    // 如果数组为空，说明没有缓存或者用户已经清理过，此时直接return
    if (subpathArray.count == 0) {
        #ifdef DEBUG
        NSLog(@"此缓存路径很干净,不需要再清理了");
        #else
        #endif
        return NO;
    }
    
    NSError *error = nil;
    NSString *filePath = nil;
    
    BOOL flag = NO;
    for (NSString *subpath in subpathArray) {
        
        filePath = [cachePath stringByAppendingPathComponent:subpath];
        
        if ([fileManager fileExistsAtPath:cachePath]) {
          // 删除子文件夹
          BOOL isRemoveSuccessed = [fileManager removeItemAtPath:filePath error:&error];

            if (isRemoveSuccessed) { // 删除成功
                flag = YES;
            }
        }
    }
    if (NO == flag) {
        #ifdef DEBUG
        NSLog(@"提示:您已经清理了所有可以访问的文件,不可访问的文件无法删除");  // 调试阶段才打印
        #else
        #endif
    }
   
    return flag;
}


@end
