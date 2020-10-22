//
//  GlobalHandle.m
//  MotherStar
//
//  Created by yanming niu on 2020/2/5.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "GlobalHandle.h"

@implementation GlobalHandle

/* 对热门脑洞的数据解析和处理 */
+ (NSDictionary *)handleBrainholeContent:(BOOL)isOriginal title:(NSString *)title content:(NSString *)content {
    //解析<img>标签
    NSString *firstPictureUrl = @"";
    NSArray *urlArray = [self filterImageUrlFromHTML:content];
     if (urlArray && urlArray.count > 0) {
        firstPictureUrl = urlArray[0];  //准备赋值给model
     }
    
    //解析<p>标签
    NSArray *textArray = [self filterTextFromHTML:content];
    NSMutableString *contentMutableString = [[NSMutableString alloc] initWithString:@""];
    if (!textArray) {
        textArray = @[];
    }
    for (NSInteger i = 0; i < textArray.count; i++) {
        NSString *contentString = textArray[i];
        [contentMutableString appendString:contentString];
    }
    
    NSString *tempContentString = [NSString stringWithString:contentMutableString];
    //截取多余的文本
    if (tempContentString.length > 120) {
        tempContentString = [tempContentString substringToIndex:120];
        tempContentString = tempContentString;
    }
    NSString *contentHandleResultString = tempContentString;  //普通文本拼接而成
    NSString *titleWithSpace = @"";
    NSString *spaceString = @" ";
    if (title && title.length > 0) {
        titleWithSpace = [[spaceString stringByAppendingString:title] stringByAppendingString:spaceString];
    }
    if (title == 0) {
        titleWithSpace = spaceString;
    }
    
    NSMutableAttributedString *contentResultAttString =  [self setContentToAttributedTextStyle:isOriginal title:titleWithSpace content:contentHandleResultString];
    
    NSDictionary *result = @{
                              @"firstPictureUrl":firstPictureUrl,
                              @"contentAttString":contentResultAttString
                            };
    
    return result;  //富文本
 }

/* 设置富文本样式 */
+ (NSMutableAttributedString *)setContentToAttributedTextStyle:(BOOL)isOriginal title:(NSString *)title content:(NSString *)content {
    NSArray *contentArray = @[
                               @{ @"string": title,
                                  @"font": PingFangSC_Medium(16),
                                  @"color":UICOLOR(@"#343338")
                                },
                               @{ @"string": content,
                                  @"font": PingFangSC_Regular(16),
                                  @"color":UICOLOR(@"#343338")
                                }
                             ];
    NSMutableAttributedString *contentResult = [[NSMutableAttributedString alloc] initWithString:@""];
    NSAttributedString *originalAttr = [[NSAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *contentAttr = [@"" setMutliString:contentArray];
    if (isOriginal) {
        originalAttr = [self setAttactToAttributeSting:[UIImage imageNamed:@"original"]];
    }
    
    [contentResult appendAttributedString:originalAttr];
    [contentResult appendAttributedString:contentAttr];
    
    return contentResult;
}

+ (NSAttributedString *)setAttactToAttributeSting:(UIImage *)image {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, -2, 28, 16);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    return attachmentString;
}

#pragma mark -- 解析HTML  --

/* 获取<img src = > */
+ (NSArray *)filterImageUrlFromHTML:(NSString *)html {
    NSMutableArray *srcArray = @[].mutableCopy;
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *htmls = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *dataArray = [htmls searchWithXPathQuery:@"//img"] ;
    for (TFHppleElement * element in dataArray) {
         NSString *srcUrl = [element objectForKey:@"src"];
         [srcArray addObject:srcUrl];
    }
    return srcArray;
}

/* 获取<p /p> */
+ (NSArray *)filterTextFromHTML:(NSString *)html {
    NSMutableArray *textArray = @[].mutableCopy;
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *htmls = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *dataArray = [htmls searchWithXPathQuery:@"//p"] ;
    for (TFHppleElement * element in dataArray) {
        if (element.text && element.text.length > 0) {
            NSString *text = element.text;
            [textArray addObject:text];
        }
    }
    return textArray;
}


/* 获取个人信息 */
+ (void)getUserInfo {
    NSString *token = [AppCacheManager sharedSession].token;
    [RequestHandle getUserInfo:@{} authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            return;
        }
       NSDictionary *dic = response[@"data"];
       NSInteger oil = [dic[@"oil"] integerValue];
        [AppCacheManager sharedSession].myFuel = oil;
    } fail:^(NSError * _Nonnull error) {
    }];
}

/* 验证是否登录 */
+ (BOOL)isLoginUser {
    NSString *token = [AppCacheManager sharedSession].token;
    BOOL is = NO;
    if (token && token.length > 0) {
        is = YES;
    }
    return is;
}

@end
