//
//  ProfileViewController.m
//  PersonWork
//
//  Created by 贝思畅想研发 on 2019/12/13.
//  Copyright © 2019 贝思畅想研发. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileViewc.h"
#import "ProfileViewCell.h"
#import "RequestHandle.h"
#import "PhotoAlbumTools.h"
#import "OSSManager.h"
#import <UMShare/UMShare.h>

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSString *mobile;
@end

@implementation ProfileViewController

{
    NSMutableArray *_dataArray;//管理数据源
    UITableView *tableView;
    ProfileViewc *personView;
    NSDictionary *personDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.gk_navigationItem.title = @"个人资料";
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitleColor:[UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *calarItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.gk_navRightBarButtonItem =  calarItem;
    [self reatDataSource];
    [self createTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self reatDataSource];
}
-(void)click{
    NSNumber *gender = [NSNumber numberWithInteger:personView.gender];
    
    OSSManager *ossmanager = [[OSSManager alloc]init];
    [SVProgressHUD showWithStatus:@"正在提交..."];
    [ossmanager uploadImage:personView.imageView.image success:^(id  _Nullable response) {
        NSMutableDictionary *upUsersDTO = [NSMutableDictionary dictionary];
        [upUsersDTO setValue:gender forKey:@"gender"];
        [upUsersDTO setValue:self->personView.textFiled.text forKey:@"nickName"];
        [upUsersDTO setValue:[response valueForKey:@"url"] forKey:@"picUrl"];

        [RequestHandle update:upUsersDTO authorization:@"" progress:^(NSProgress * _Nonnull progress) {

        } success:^(id  _Nullable response) {
            if ([[response valueForKey:@"code"] intValue]==0) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                
                [SVProgressHUD dismissWithDelay:1.0 completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }

        } fail:^(NSError * _Nonnull error) {


        }];

        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

-(void)reatDataSource
{
      NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];

        _dataArray = [[NSMutableArray alloc]init];
       
        NSString *token = [AppCacheManager sharedSession].token;
    
        [RequestHandle searchUser:[NSDictionary new] authorization:token progress:^(NSProgress * _Nonnull progress) {
        } success:^(id  _Nullable response) {

            if ([response[@"code"] isEqual:@(0)]) {
                NSDictionary *dicJson = response[@"data"];
                [dicJson  enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSNumber class]]) {

                        obj = [NSNumber numberWithInteger:obj];
                    }
                    
                    
                }];
                
//                [defaults setValue:dicJson forKey:@"personDic"];
                self->personView.dic = response[@"data"];
                NSString *mobile = self.mobile = response[@"data"][@"mobile"];
                if (mobile.length) {
                    mobile=[mobile stringByReplacingOccurrencesOfString:[mobile substringWithRange:NSMakeRange(3,4)] withString:@"****"];

                }
                NSArray *SectionsOneData = @[@[@"icon_set_phoneno.png", @"手机号",mobile]];
                NSArray *SectionsTwoData = @[@[@"icon_set_wechat.png", @"微信",response[@"data"][@"wxName"]],@[@"icon_set_qq.png",@"QQ",response[@"data"][@"qqName"]],@[@"icon_set_sina.png",@"微博",response[@"data"][@"wbName"]]];
                [self->_dataArray addObject:SectionsOneData];
                [self->_dataArray addObject:SectionsTwoData];
                [self->tableView reloadData];
            }
            
        } fail:^(NSError * _Nonnull error) {
//            self->personDic = [defaults objectForKey:@"personDic"];
//            self->personView.dic = self->personDic;
//            NSArray *SectionsOneData = @[@[@"icon_set_phoneno.png", @"手机号",self->personDic[@"mobile"]]];
//            NSArray *SectionsTwoData = @[@[@"icon_set_wechat.png", @"微信",self->personDic[@"wxName"]],@[@"icon_set_qq.png",@"QQ",self->personDic[@"qqName"]],@[@"icon_set_sina.png",@"微博",self->personDic[@"wbName"]]];
//            [self->_dataArray addObject:SectionsOneData];
//            [self->_dataArray addObject:SectionsTwoData];
//            [self->tableView reloadData];
            
        }];
   
}
#pragma mark -  关于UITableView
-(void)createTableView
{

    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ZS_StatusBarHeight+44, self.view.frame.size.width, self.view.frame.size.height+ZS_StatusBarHeight) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
//    tableView.showsVerticalScrollIndicator = YES;

    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"ProfileViewc" owner:nil options:nil];
    personView = [viewArray firstObject];
    tableView.tableHeaderView = personView;
//    __weak typeof(ProfileViewc*) personViewweak = personView;
    
    personView.imageClickTap = ^(NSInteger Tag) {
        PhotoAlbumTools *photo = [[PhotoAlbumTools alloc]init];
        [photo openPhotoAlbum:NO mediaType:@"photo" callback:^(id  _Nonnull data) {
            UIImage *image = data;
            self->personView.imageView.image = image;
        }];
    };
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    tableView.rowHeight = 48;
    tableView.sectionFooterHeight=0;
    [self.view addSubview:tableView];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reKeyBoard)];
//    tap.delegate = self;
//    [tableView addGestureRecognizer:tap];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//
//{
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"ProfileViewCell"]) {
//        return NO;
//    }
//        return NO;
//
//
//}


//- (void)reKeyBoard
//{
//    [personView.textFiled resignFirstResponder];
//
//}



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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

      ProfileViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ProfileViewCell" owner:nil options:nil].firstObject;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
      if (indexPath.row == _dataArray.count-1) {
          setLastCellSeperatorToLeft(cell);
      }
      cell.array = _dataArray[indexPath.section][indexPath.row];
      return cell;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 40.5;
    }else{
        return 40.5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
           return 10;
       }else{
           return .001;
       }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.5)];
        //自定义颜色
        view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(16,20,150,14);
        label.numberOfLines = 0;
        label.text = @"账号和绑定";
        [self.view addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentLeft;
        label.alpha = 1.0;
        [view addSubview:label];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(16, 39.6, self.view.frame.size.width-32, 1)];
        lineView.backgroundColor =[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        [view addSubview:lineView];
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.5)];
        //自定义颜色
        view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(16,20,150,14);
        label.numberOfLines = 0;
        [self.view addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentLeft;
        label.alpha = 1.0;
        [view addSubview:label];
        label.text = @"其他登录方式";
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(16, 39.6, self.view.frame.size.width-32, 1)];
        lineView.backgroundColor =[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        [view addSubview:lineView];

        return view;
    }
    
}
static void setLastCellSeperatorToLeft(UITableViewCell* cell)
{
    cell.separatorInset =UIEdgeInsetsMake(0,0, 0, cell.bounds.size.width+200);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    bool isF;
    if ([cell.name1.text isEqualToString:@"未绑定"]) {
        isF=1;
    }else{
        isF=0;
    }
    if (indexPath.section == 1) {
        if (indexPath.row==0&&isF) {
            [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
        }else if (indexPath.row == 1&&isF){
            [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
        }else if (indexPath.row == 2&&isF){
            [self getUserInfoForPlatform:UMSocialPlatformType_Sina];
        }
        
    }
}


- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
   
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);

        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        NSLog(@"uid: %@\nopenid:%@\nname:%@\niconurl:%@\n", resp.uid,resp.openid,resp.name,resp.iconurl);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:resp.uid forKey:@"account"];
        [dic setValue:@"" forKey:@"inviteUsers"];
        [dic setValue:resp.iconurl forKey:@"logo"];
        [dic setValue:self.mobile forKey:@"mobile"];
        [dic setValue:resp.name forKey:@"nickName"];
        [dic setValue:@"" forKey:@"password"];
        [dic setValue:@"" forKey:@"smsCode"];

//        NSDictionary *dicParm;
        NSString *string ;
        if (resp.uid != NULL) {
            switch (platformType) {
                  case UMSocialPlatformType_QQ:
                    [dic setValue:@"1" forKey:@"loginType"];
                      [self threeRegist:dic];
                      break;
                  case UMSocialPlatformType_WechatSession:
                    [dic setValue:@"2" forKey:@"loginType"];
                      [self threeRegist:dic];
                      break;
                  case UMSocialPlatformType_Sina:
                    [dic setValue:@"3" forKey:@"loginType"];
                    [self threeRegist:dic];
                      break;
                  default:
                      break;
              }
            
        }
        
        
    }];
}


-(void)threeRegist:(NSDictionary *)dic{
    
    NSString *token = token();
    [RequestHandle threeRegist:dic authorization:token progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        if ([[response valueForKey:@"code"] intValue] != 0) {
            NSString *msg = [NSString stringWithFormat:@"%@",[response valueForKey:@"msg"] ];
            if (msg.length) {
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:msg];
            }
            return ;
        }
        [self reatDataSource];

    } fail:^(NSError * _Nonnull error) {
        
        
    }];
}




@end
