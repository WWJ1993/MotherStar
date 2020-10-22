//
//  ForgetPwdViewController.m
//  ParentStar
//
//  Created by WWJ on 2019/12/17.
//  Copyright © 2019 Socrates. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "RegistCell.h"
#import "RequestManager.h"
#import "SVProgressHUD.h"

@interface ForgetPwdViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)UIView *footerView;
@property (nonatomic, weak)UIButton *registBtn;
@property (nonatomic, strong)dispatch_source_t timers;
@property (nonatomic, strong)UIButton *codeBtn;

@end

@implementation ForgetPwdViewController
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
#pragma mark - Action
- (void)closeAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//按钮可点判断
- (void)enabled{
    for (LoginRegistCommondModel  *model in self.dataArray) {
        if ([model.key isEqualToString:@"inviteUsers"]) {
            continue;
        }
        if (!model.text.length) {
            self.registBtn.layer.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0].CGColor;
            self.registBtn.enabled = NO;
            return;
        }
    }
    self.registBtn.layer.backgroundColor = [UIColor colorWithRed:239/255.0 green:180/255.0 blue:0/255.0 alpha:1.0].CGColor;
    self.registBtn.enabled = YES;
}
//发送验证码
- (void)getCode:(NSString *)mobile btn:(UIButton *)codeBtn{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:mobile forKey:@"mobile"];
    [RequestHandle requestVerificationCode:params success:^(id  _Nullable response) {
        NSString *msg = [NSString stringWithFormat:@"%@",[response valueForKey:@"msg"] ];
        if (msg.length) {
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:msg];
        }
        if ([[response valueForKey:@"code"] intValue] != 0) {//手机号已注册
            return ;
        }
        
        self.codeBtn = codeBtn;
        [self verificationCode];

    } fail:^(NSError * _Nonnull error) {
        
    }];

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


- (void)forgetPwd{
    //修改密码
//    + (void)upPassword:(NSDictionary *)param success:(SuccessBlock)success
//fail:(FailBlock)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (LoginRegistCommondModel  * model in self.dataArray) {
        if ([model.key isEqualToString:@"password"]) {
            if (![LoginRegistCommondModel judgePassWordLegal:model.text]) {
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"密码格式不正确"];
                return ;
            }
        }
        [params setValue:model.text forKey:model.key];
    }
    [RequestHandle upPassword:params success:^(id  _Nullable response) {
        if ([[response valueForKey:@"code"] intValue] == 0) {
            [self closeAction];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"修改成功"];
            return ;
        }
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[response valueForKey:@"msg"]];
    } fail:^(NSError * _Nonnull error) {
        
    }];
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
    
    UILabel *logoLable = [UILabel new];
    logoLable.text = @"找回密码";
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
            NSLog(@"请输入手机号");
            return ;
        }
        [self getCode:mobile btn:codeBtn];
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
        _dataArray = [LoginRegistCommondModel getForgetPwdArray];
    }
    return _dataArray;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-100, 300)];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 25, SCREENWIDTH-100, 46)];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        btn.layer.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0].CGColor;
        btn.enabled = NO;
        btn.layer.cornerRadius = 8;
        [btn addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        self.registBtn = btn;
        
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

@end
