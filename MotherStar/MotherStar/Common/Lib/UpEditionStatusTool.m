//
//  UpEditionStatusTool.m
//  MotherStar
//
//  Created by 王文杰 on 2020/2/10.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "UpEditionStatusTool.h"
#import "MotherPlanetAlertView.h"

static NSInteger EditionNum = 100010;

@implementation UpEditionStatusTool

+ (void)taskUpEditation{
    NSString *Url = [BaseUrl stringByAppendingFormat:@"/task/upEditation"];
    
    [[RequestManager sharedInstance] GET:Url parameters:@{@"id":@"1"} authorization:@"" progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        if([[response valueForKey:@"code"] intValue] == 0){
            NSDictionary *data = [response valueForKey:@"data"];
            NSString *editionStatus = [data valueForKey:@"editionStatus"];
            NSString *upDescribe = [data valueForKey:@"upDescribe"];

            NSString *editionNum = [data valueForKey:@"editionNum"];
//            NSString *appCurVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            __block NSString *downloadUrl = [data valueForKey:@"downloadUrl"];
            if (([editionStatus intValue] == 0||[editionStatus intValue] == 1)
                &&(EditionNum < [editionNum intValue])) {//0升级，1强制，2不更新
                MotherPlanetAlertView *alertView = [[MotherPlanetAlertView alloc] init:@"有版本更新" message:upDescribe ok:@"更新" cancel:[editionStatus intValue] == 0?@"稍后":@""];
                alertView.okBlock = ^(){
                    
//                   https://itunes.apple.com/cn/app/id1336325864?mt=8
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:downloadUrl]]) {
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:downloadUrl] ];
                        if ([editionStatus intValue] == 0) {
                            [alertView remove];
                        }
                    }else{
                        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"更新地址失效，请稍后再试"];
                    }
                };
                alertView.cancelBlock = ^{
                    
                };
            }
            
            
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
@end
