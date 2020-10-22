//
//  ShareViewController.m
//  MotherStar
//
//  Created by 王文杰 on 2020/1/13.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "ShareViewController.h"
#import <UShareUI/UShareUI.h>
@interface ShareViewController ()
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (nonatomic ,copy) NSString *codeStr;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [shareBtn setImage:[UIImage imageNamed:@"icon／share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    [self setGk_navRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:shareBtn]];
//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        //        backBtn.backgroundColor = [UIColor redColor];
//        //        backBtn.titleLabel.font = FONT(14);
//        //        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//        //        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [backBtn setImage:[UIImage imageNamed:@"icon_arrow_back"] forState:UIControlStateNormal];
//        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
    [self loadData];
        
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];

}


//弹出友盟
-(void)shareAction{
    
    //设置可分享的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@( UMSocialPlatformType_WechatTimeLine ),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_Sina)]];
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
//        //创建分享消息对象
//        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//        messageObject.text = @"分享的文案";
//        NSString *Url = [BaseUrl stringByAppendingFormat:@"/swagger-ui.html#/share-controller/getConfigUsingGET"];
//
//        [[RequestManager sharedInstance] GET:Url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        }];
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

        //创建网页内容对象
//        NSString* thumbURL =  @"http://h5.share.motherplanet.cn/image/logo_h5.png";


//        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
//
//        NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
//
//        UIImage* image = [UIImage imageNamed:icon];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"好友分享" descr:@"下载母星系" thumImage:[UIImage imageNamed:@"appicon"]];
        //设置网页地址
        shareObject.webpageUrl = [[BaseUrl substringToIndex:[BaseUrl rangeOfString:@"api"].location] stringByAppendingFormat:@"code.html?inviteCode=%@",self.codeStr];

        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{

                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"分享成功"];

                
            }
        }];
    }];
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[error.userInfo valueForKey:@"message"]];
            return ;
        }
        
        if ([data isKindOfClass:[UMSocialShareResponse class]]) {
            UMSocialShareResponse *resp = data;
            //分享结果消息
            UMSocialLogInfo(@"response message is %@",resp.message);
            //第三方原始返回的数据
            UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            
        }else{
            UMSocialLogInfo(@"response data is %@",data);
        }
    }];
}


- (void)loadData{
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/user/getUserInviteCode"];

    [[RequestManager sharedInstance] GET:Url parameters:@{} authorization:@"" progress:^(NSProgress * _Nonnull progress) {
    
    } success:^(id  _Nullable response) {
        if ([[response valueForKey:@"code"] intValue]==0) {
            self.codeStr = [response valueForKey:@"data"];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.codeStr.length];
            for (int i = 0; i<self.codeStr.length; i++) {
                [array addObject:[NSString stringWithFormat:@"%C",[self.codeStr characterAtIndex:i]]];
            }
            self.code.text = [array componentsJoinedByString:@" "];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
