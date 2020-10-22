//
//  RegistViewController.m
//  ParentStar
//
//  Created by WWJ on 2019/12/16.
//  Copyright © 2019年 Socrates. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistCell.h"
#import "RequestManager.h"
#import "MLLinkLabel.h"
#import "SVProgressHUD.h"
#import "MPWebViewController.h"
@interface RegistViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UIView *footerView;
@property (nonatomic, weak)UIButton *registBtn;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)MLLinkLabel *linkLabel;
@property (nonatomic, weak)UIButton *agreeBtn;
@property (nonatomic, strong)UIButton *codeBtn;
@property (nonatomic, strong)dispatch_source_t timers;


@end

@implementation RegistViewController
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
    self.agreeBtn.hidden = self.linkLabel.hidden = self.isPhone;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
//发送验证码
- (void)getCode:(NSString *)mobile btn:(UIButton *)codeBtn{
    if (self.isPhone) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:mobile forKey:@"mobile"];
        
        [params setValue:[self.dic valueForKey:@"loginType"] forKey:@"loginType"];
        [RequestHandle requestVerificationThreeCode:params success:^(id  _Nullable response) {
            if ([[response valueForKey:@"code"] intValue] == 2 && self.isPhone && self.dataArray.count == 3) {//展示输入密码
                LoginRegistCommondModel *model3 = [LoginRegistCommondModel new];
                model3.placeholder = @"请输入密码";
                model3.footerText = @"* 6-12位的英文加数字";
                model3.key = @"password";
                model3.isPwd = YES;
                [self.dataArray insertObject:model3 atIndex:2];
                [self.tableView reloadData];
                self.agreeBtn.hidden = self.linkLabel.hidden = NO;
            }
           //发送验证码
            if ([[response valueForKey:@"code"] intValue] == 3//手机号已注册
                ||[[response valueForKey:@"code"] intValue] == 2) {
                self.codeBtn = codeBtn;
                [self verificationCode];
            }
            
            NSString *msg = [NSString stringWithFormat:@"%@",[response valueForKey:@"msg"] ];
            if (msg.length) {
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:msg];
                return ;
            }

        } fail:^(NSError * _Nonnull error) {
            
        }];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:mobile forKey:@"mobile"];
    
    [RequestHandle requestVerificationSendCode:params success:^(id  _Nullable response) {
        if ([[response valueForKey:@"code"] intValue] != 0) {//手机号已注册
            NSString *msg = [NSString stringWithFormat:@"%@",[response valueForKey:@"msg"] ];
            if (msg.length) {
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:msg];
                return ;
            }
        }
        self.codeBtn = codeBtn;
        [self verificationCode];
    } fail:^(NSError * _Nonnull error) {
        
    }];
//    [RequestManager post:@"sms/send" params:params success:^(id  _Nullable response) {
//        if ([[response valueForKey:@"code"] intValue] != 0) {
//            //提示
//            NSLog(@"%@",[response valueForKey:@"msg"]);
//            return ;
//        }
//

//    } fail:^(NSError * _Nonnull error) {
//
//    }];

}

//倒计时
- (void)verificationCode{
    __block int timeout=60;
    self.codeBtn.enabled = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timers = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timers,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self.timers, ^{
        if(timeout<=0){
            dispatch_source_cancel(self.timers);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.codeBtn.enabled = YES;
                self.codeBtn = nil;
            });
            return ;
        }
        NSString *strTime = [NSString stringWithFormat:@"重新获取(%.2ds)", timeout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.codeBtn setTitle:strTime forState:UIControlStateDisabled];
        });
        timeout--;
    });
    dispatch_resume(self.timers);
}

//注册
- (void)regist{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:
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
    if (self.isPhone) {
        [params addEntriesFromDictionary:self.dic];
    }
//    [self.dataArray enumerateObjectsUsingBlock:^(LoginRegistCommondModel  *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([model.key isEqualToString:@"mobile"]&&model.text.length == 0) {
//            //TODO:校验手机号
//            return ;
//        }
//        if ([model.key isEqualToString:@"password"]) {
//            if (![LoginRegistCommondModel judgePassWordLegal:model.text]) {
//                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"密码格式不正确"];
//                return ;
//            }
//        }
//        [params setValue:model.text.length?model.text:@"" forKey:model.key];
//    }];
    
    
    for (LoginRegistCommondModel  * model in self.dataArray) {
//        if ([model.key isEqualToString:@"mobile"]&&model.text.length == 0) {
//            //TODO:校验手机号
//            return ;
//        }
        if ([model.key isEqualToString:@"password"]) {
            if (![LoginRegistCommondModel judgePassWordLegal:model.text]) {
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"密码格式不正确"];
                return ;
            }
        }
        [params setValue:model.text.length?model.text:@"" forKey:model.key];
    }

    if (self.isPhone) {//绑定手机号，第三方登录保存token
        [RequestHandle threeRegist:params success:^(id  _Nullable response) {
            
            [self registFinish:response];
        } fail:^(NSError * _Nonnull error) {
            
        }];
        return;
    }
    [RequestHandle regist:params success:^(id  _Nullable response) {
        [self registFinish:response];
//        if ([[response valueForKey:@"code"] intValue]==0) {
//            [self closeAction];
//            return ;
//        }
//        NSString *msg = [NSString stringWithFormat:@"%@",[response valueForKey:@"msg"] ];
//        if (msg.length) {
//            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:msg];
//        }
    } fail:^(NSError * _Nonnull error) {
        
    }];
}

- (void)registFinish:(NSDictionary *)response{
    if ([[response valueForKey:@"code"] intValue]==0) {
        [AppCacheManager sharedSession].token = [[response valueForKey:@"data"] valueForKey:@"token"];
        [self dismissViewController];
        return ;
    }
    NSString *msg = [NSString stringWithFormat:@"%@",[response valueForKey:@"msg"] ];
     if (msg.length) {
         [SVProgressHUD showImage:[UIImage imageNamed:@""] status:msg];
     }
}
- (void)dismissViewController{
    UIViewController *vc =  self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:^{
        RootViewController *rootVC = [[RootViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    }];
    
}
//按钮可点判断
- (void)enabled{
    BOOL enabled = [self canEnabled];
    if (enabled) {
        self.registBtn.layer.backgroundColor = [UIColor colorWithRed:239/255.0 green:180/255.0 blue:0/255.0 alpha:1.0].CGColor;
        self.registBtn.enabled = YES;

    }else{
        self.registBtn.layer.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0].CGColor;
        self.registBtn.enabled = NO;
    }
}

- (BOOL)canEnabled{
    if (!self.agreeBtn.hidden&&!self.agreeBtn.selected) return NO;
    for (LoginRegistCommondModel  *model in self.dataArray) {
        if ([model.key isEqualToString:@"inviteUsers"]) {
            continue;
        }
        if (!model.text.length) {
            self.registBtn.layer.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0].CGColor;
            self.registBtn.enabled = NO;
            return NO;
        }
    }
    return YES;
}

- (void)agreeAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    [self enabled];
}
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
    if (!self.isPhone) {
        
        UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [jumpBtn addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
        [jumpBtn setTitle:@"跳过" forState:UIControlStateNormal];
        //    jumpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [jumpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.view addSubview:jumpBtn];
        [jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15+StatusBarHeight);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(60);
        }];
    
    }
    UILabel *logoLable = [UILabel new];
    logoLable.text =  self.isPhone?@"绑定手机": @"注册";
    logoLable.textAlignment = NSTextAlignmentCenter;
    logoLable.font = [UIFont boldSystemFontOfSize:26];
    [self.view addSubview:logoLable];
    [logoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(closeBtn.mas_bottom).mas_offset(30);
        make.left.right.mas_equalTo(0);
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
        make.top.mas_equalTo(logoLable.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.bottom.mas_equalTo(0);
    }];
    
    tableView.tableFooterView = self.footerView;
    self.tableView = tableView;
}
#pragma mark - TableViewDelegate,TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf = self;
    LoginRegistCommondModel *model = self.dataArray[indexPath.section];
    RegistCell *cell = [RegistCell cellWithTableView:tableView];
    cell.model = model;
    cell.textChangeBlock = ^(LoginRegistCommondModel * _Nonnull model) {
        [weakSelf enabled];
    };
    cell.getCodeBlock = ^(UIButton * _Nonnull codeBtn) {
        NSString *mobile = @"";
        for (LoginRegistCommondModel *model in self.dataArray) {
            if ([model.key isEqualToString:@"mobile"]) {
                mobile = model.text;
            }
        }
        if (mobile.length == 0) {
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"请输入手机号"];

            return ;
        }
        [weakSelf getCode:mobile btn:codeBtn];
    };
    if (model.isCoder && self.codeBtn) {//正在倒计时
        self.codeBtn = cell.codeBtn;
        self.codeBtn.enabled = NO;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 14;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    LoginRegistCommondModel *model = self.dataArray[section];
    UILabel *lab = [UILabel new];
    lab.text = model.footerText;
    lab.font = [UIFont systemFontOfSize:10];
    lab.textColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0];
    return lab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    LoginRegistCommondModel *model = self.dataArray[section];
    
    return model.footerText?14:0.0001;
}
#pragma mark - setter,getter
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:self.isPhone?[LoginRegistCommondModel getPhoneArray]: [LoginRegistCommondModel getRegistArray]];
    }
    return _dataArray;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-100, 300)];
        //TODO:富文本
        MLLinkLabel *label = [MLLinkLabel new];
        label.frame = CGRectMake(0,20,SCREENWIDTH-100,10);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1.000000];
        [_footerView addSubview:label];
        NSString *linkStr1 = @"用户协议";
        NSString *linkStr2 = @"隐私政策";
        NSString *str = [NSString stringWithFormat: @"我已同意母星系%@和%@",linkStr1,linkStr2];

        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attrStr addAttribute:NSLinkAttributeName value:@"http://directions.motherplanet.cn/priva/" range:[str rangeOfString:linkStr1]];
        [attrStr addAttribute:NSLinkAttributeName value:@"http://directions.motherplanet.cn/priva/" range:[str rangeOfString:linkStr2]];
        
        label.attributedText = attrStr;
        for (MLLink *link in label.links) {
            link.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:52/255.0 green:51/255.0 blue:56/255.0 alpha:1.000000]};
        }
        [label invalidateDisplayForLinks];
        [label setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSLog(@"linkValue:%@",link.linkValue);
            MPWebViewController *vc  = [MPWebViewController new];
            vc.navigationItem.title = [NSString stringWithFormat:@"%@", linkText];
            vc.url = link.linkValue;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [label sizeToFit];
        CGRect rect = label.frame;
        label.frame = CGRectMake((SCREENWIDTH - 100-rect.size.width)*.5,20,rect.size.width,rect.size.height);
        self.linkLabel = label;
        
        
        UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [agreeBtn setImage:[UIImage imageNamed:@"icon／disagree"] forState:UIControlStateNormal];
        [agreeBtn setImage:[UIImage imageNamed:@"icon／agree"] forState:UIControlStateSelected];
        agreeBtn.frame = CGRectMake(label.frame.origin.x-3-rect.size.height, label.frame.origin.y, rect.size.height, rect.size.height);
        [agreeBtn addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:agreeBtn];
        self.agreeBtn = agreeBtn;
        
//        MLLink *label = [[MLLink alloc] init];
//        label.frame = CGRectMake(0,20,SCREENWIDTH-100,10);
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text =@"我已同意母星系用户协议和隐私政策";
        
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 45, SCREENWIDTH-100, 46)];
        [btn setTitle:@"注册" forState:UIControlStateNormal];
        btn.layer.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0].CGColor;
        btn.enabled = NO;
        btn.layer.cornerRadius = 8;
        [btn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        self.registBtn = btn;
        
    }
    return _footerView;
}

@end
