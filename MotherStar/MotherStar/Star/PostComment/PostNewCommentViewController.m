//
//  PostNewCommentViewController.m
//  MotherStar
//
//  Created by 胡志军 on 2020/2/15.
//  Copyright © 2020年 yanming niu. All rights reserved.
//

#import "PostNewCommentViewController.h"
#import "CommentImportView.h"
@interface PostNewCommentViewController ()
@property (nonatomic, strong) UIBarButtonItem *postButton;
//评论输入框
@property (nonatomic, strong) CommentImportView * commentImportview;
//@property (nonatomic, strong) UILabel * label;
@end

@implementation PostNewCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.gk_navigationItem.title = @"评论";
    self.gk_navRightBarButtonItem = self.postButton;

    [self setupUI];
}
- (void)setupUI {
    [self.view addSubview:self.commentImportview];
    [self.commentImportview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 16 + StatusAndNaviHeight;
        make.left.right.offset = 0;
        make.bottom.mas_offset(0);
    }];
}

#pragma mark --Event
//点击屏幕 结束编辑
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#warning --返回方法没用，
- (void)backAction {
    if (self.commentImportview.textView.text.length > 0) {
        MotherPlanetAlertView *alertView = [[MotherPlanetAlertView alloc] init:@"退出编辑" message:@"已填写内容将被删除" ok:@"退出" cancel:@"留下"];
        alertView.canRemove = YES;
        alertView.okBlock = ^(){
            [self.navigationController popViewControllerAnimated:YES];
        };
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//保存
- (void)postBrainholeComment{
#warning --上传之前 这个方法一定要实现
    //准备更新上传的内容
    [self.commentImportview reloadUpdateConten];
   
    
    [self.view endEditing:YES];
    [self upDateContent];

}
- (void)upDateContent{
    //开始上传
    self.postButton.enabled = NO;
    
    if (self.commentImportview.brainholeCommentText.length == 0) {
        self.postButton.enabled = YES;
        [SVProgressHUD showInfoWithStatus:@"还什么都没有写呢"];
        [SVProgressHUD dismissWithDelay:1.2];
        self.postButton.enabled = YES;
        return;
    }
    
    NSInteger commentType = 0;
    NSDictionary *param = @{
                             @"commentType": @(commentType),
                             @"picUrl": self.commentImportview.imageUrl,
                             @"postId": @(self.brainholeId),
                             @"title": self.commentImportview.brainholeCommentText
                           };
    
    NSString *token = [AppCacheManager sharedSession].token;
    [SVProgressHUD showWithStatus:@"正在发布..."];
    [RequestHandle postBrainholeComment:param authorization:token uploadProgress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nullable response) {
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [SVProgressHUD dismissWithDelay:2.0 completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } fail:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        self.postButton.enabled = YES;  //发布失败允许点击
        
    }];
    
}
#pragma mark --Get

- (CommentImportView *)commentImportview{
    if (!_commentImportview) {
        _commentImportview = [[CommentImportView alloc] init];
//        设置最大字数  图片算一个字符， 表情2个字符 默认500
//        _commentImportview.maxLenght = 500;
        //配置添加按钮 背景图片
//        _commentImportview.addImageBackGroundImageStr = @"";
        _commentImportview.placeholderText = @"写几句评价吧";
    }
    return _commentImportview;
}
- (UIBarButtonItem *)postButton {
    if (!_postButton) {
        UIButton *save = [UIButton new];
        save.frame = CGRectMake(0, 0, 36, 18);
        save.titleLabel.font = PingFangSC_Medium(18);
        [save setTitle:@"发布" forState:UIControlStateNormal];
        [save setTitleColor:UICOLOR(@"#EFB400") forState:UIControlStateNormal];
        [save addTarget:self action:@selector(postBrainholeComment) forControlEvents:UIControlEventTouchUpInside];
        _postButton = [[UIBarButtonItem alloc] initWithCustomView:save];
    }
    return _postButton;
}


@end
