//
//  LoginViewController.m
//  ParentStar
//
//  Created by WWJ on 2019/12/16.
//  Copyright © 2019年 Socrates. All rights reserved.
//

#import "PwdLoginViewController.h"
#import "LoginCell.h"
#import "RegistViewController.h"
#import "ForgetPwdViewController.h"
#import <UMShare/UMShare.h>
#import "SVProgressHUD.h"
#import "UserInfoTools.h"
#import "RootViewController.h"

@interface PwdLoginViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)UIView *footerView;
@property (nonatomic, strong)UIButton *loginBtn;

@end

@implementation PwdLoginViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES ];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO ];
}

#pragma mark - Action
- (void)closeAction{
    [self.view endEditing:YES];
    RootViewController *rootVC = [[RootViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
//    [self dismissViewControllerAnimated:YES completion:^{
//        if (self.isLoginOut) {//推出登陆
////            UITabBarController *tabbarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
////            tabbarController.selectedIndex = 0;
//        }
//
//
//    }];
}


- (void)registAction{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[RegistViewController new]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 登录
 */
- (void)loginAction{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [self.dataArray enumerateObjectsUsingBlock:^(LoginRegistCommondModel  * model, NSUInteger idx, BOOL * _Nonnull stop) {
//
//    }];
    
    for (LoginRegistCommondModel  * model in self.dataArray) {
//        if ([model.key isEqualToString:@"password"]) {
//            if (![LoginRegistCommondModel judgePassWordLegal:model.text]) {
//                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"密码格式不正确"];
//                return ;
//            }
//        }
        [params setValue:model.text forKey:model.key];
    }
    [self login:params];
}

- (void)login:(NSDictionary *)params{
    
    
    __weak typeof(self)wself = self;
    [RequestHandle login:params success:^(id  _Nullable response) {
        [wself loginFinish:params response:response];
    } fail:^(NSError * _Nonnull error) {
        
    }];
    
}


- (void)otherLogin:(NSDictionary *)params{
    __weak typeof(self)wself = self;
    [RequestHandle otherLogin:params success:^(id  _Nullable response) {
        [wself loginFinish:params response:response];
    } fail:^(NSError * _Nonnull error) {
        
    }];
}

- (void)loginFinish:(NSDictionary *)params response:(NSDictionary *)response{
    if ([[response valueForKey:@"code"] intValue] == 0) {//登录成功
        //保存token
        [AppCacheManager sharedSession].token = [[response valueForKey:@"data"] valueForKey:@"token"];
        [self closeAction];
        return ;
    }
    if ([[response valueForKey:@"code"] intValue] == 2) {

        //绑定手机号
        RegistViewController *vc = [RegistViewController new];
        vc.isPhone = YES;
        vc.dic = params;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];

        return;
    }
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[response valueForKey:@"msg"]];
}


/**
 按钮可点判断
 */
- (void)enabled{
    for (LoginRegistCommondModel  *model in self.dataArray) {
        if (!model.text.length) {
            self.loginBtn.layer.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0].CGColor;
            self.loginBtn.enabled = NO;
            return;
        }
    }
    self.loginBtn.layer.backgroundColor = [UIColor colorWithRed:239/255.0 green:180/255.0 blue:0/255.0 alpha:1.0].CGColor;
    self.loginBtn.enabled = YES;
}
- (void)forgetPwd{
    [self presentViewController:[ForgetPwdViewController new] animated:YES completion:nil];
}

/**
 
 */
- (void)shareAction:(UIButton *)btn{
    UMSocialPlatformType type = UMSocialPlatformType_Sina;
    switch (btn.tag) {
        case 0://qq
            type = UMSocialPlatformType_QQ;
            break;
        case 1://wechat
            type = UMSocialPlatformType_WechatSession;
            break;
        case 2://微博
            type = UMSocialPlatformType_Sina;
            break;
        default:
            break;
    }
    [self getUserInfoForPlatform:type];
}
//第三方登录
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        if (error) {
            
            [SVProgressHUD showImage:[UIImage new] status:[error.userInfo valueForKey:@"message"]];
            return ;
        }
//         第三方登录数据(为空表示平台未提供)
//         授权数据
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
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:
            @{
              @"account": @"",
              @"inviteUsers": @"",
              @"loginType": @"",
              @"logo": @"",
              @"mobile": @"",
              @"nickName": @"",
              @"password": @"",
              @"smsCode": @""
            }];
        NSString *string ;
        switch (platformType) {
            case UMSocialPlatformType_QQ:
                string = @"1";
                break;
            case UMSocialPlatformType_WechatSession:
                string = @"2";
                break;
            case UMSocialPlatformType_Sina:
                string = @"3";
                break;
                
            default:
                break;
        }
        [dic setValue:string forKey:@"loginType"];
        [dic setValue:resp.iconurl forKey:@"logo"];
        [dic setValue:resp.name forKey:@"nickName"];
        [dic setValue:resp.uid forKey:@"account"];
        [self otherLogin:dic];


    }];
}

//分享
#pragma mark - UI
- (void)setUI{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"icon／close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15+StatusBarHeight);
        make.width.height.mas_equalTo(30);
    }];
    
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [jumpBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [jumpBtn setTitle:@"注册" forState:UIControlStateNormal];
    jumpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [jumpBtn setTitleColor:[UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:jumpBtn];
    [jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15+StatusBarHeight);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(60);
    }];
    
//    163*26
    UIImageView *logo = [UIImageView new];
    logo.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jumpBtn.mas_bottom).mas_offset(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(163);
        make.height.mas_equalTo(26);
    }];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 46;
    tableView.separatorStyle = 0;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logo.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.bottom.mas_equalTo(-150);
    }];
    
    tableView.tableFooterView = self.footerView;
    
    UIView *shareView = [UIView new];
    [self.view addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(150);
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UILabel *lab = [UILabel new];
    lab.text = @"———— 第三方登录 ————";
    lab.textColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    [shareView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    
    NSArray *array = @[
                       @{@"icon":@"icon_qq_login"},
                       @{@"icon":@"icon_wechat_login"},
                       @{@"icon":@"icon_sina_login"}
                       ];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary  * dic, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = idx;
        [btn setImage:[UIImage imageNamed:dic[@"icon"]] forState:UIControlStateNormal];
        [shareView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(44);
            make.top.mas_equalTo(30);
            make.left.mas_equalTo(78*idx);
        }];
    }];
}
#pragma mark - TableViewDelegate,TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LoginRegistCommondModel *model = self.dataArray[indexPath.section];
    LoginCell *cell = [LoginCell cellWithTableView:tableView];
    cell.model = model;
    cell.textChangeBlock = ^(LoginRegistCommondModel * _Nonnull model) {
        [self enabled];
    };
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 14;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
#pragma mark - setter,getter
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [LoginRegistCommondModel getLoginArray];
    }
    return _dataArray;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-100, 300)];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 24, SCREENWIDTH-100, 46)];
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        btn.layer.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0].CGColor;
        btn.layer.cornerRadius = 8;
        [btn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        btn.enabled = NO;

        self.loginBtn = btn;
    
        UIButton *forgetPwdBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-150, CGRectGetMaxY(btn.frame)+ 14, 50, 20)];
        [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [forgetPwdBtn setTitleColor:[UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateNormal];
        forgetPwdBtn.layer.cornerRadius = 8;
        [forgetPwdBtn addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:forgetPwdBtn];
        
    }
    return _footerView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+ (void)loginWithViewController:(UIViewController *)vc{
    PwdLoginViewController *loginVC = [[PwdLoginViewController alloc]init];
    [vc presentViewController:loginVC animated:NO completion:nil];
}
+ (void)loginOutViewController:(UIViewController *)vc{
    [AppCacheManager sharedSession].token = @"";
    PwdLoginViewController *loginVC = [[PwdLoginViewController alloc]init];
    loginVC.isLoginOut  = YES;
    [vc presentViewController:loginVC animated:NO completion:nil];
}

@end
