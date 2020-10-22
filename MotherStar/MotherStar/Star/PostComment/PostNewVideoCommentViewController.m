//
//  PostNewVideoCommentViewController.h.m
//  MotherStar
//
//  Created by 胡志军 on 2020/2/15.
//  Copyright © 2020年 yanming niu. All rights reserved.
//

#import "PostNewVideoCommentViewController.h"
#import "CommentImportView.h"
@interface PostNewVideoCommentViewController () {
    UIView *scoreArea;  //评分视图
    UIView *pentagramView;  //五角星列表
    UIView *scoreTypeView;
    UIButton *plusButton;
    UIButton *minusButton;
    UILabel *scoreL;
}
@property (nonatomic, strong) UIBarButtonItem *postButton;
//评论输入框
@property (nonatomic, strong) CommentImportView *commentImportview;
@property (nonatomic, assign) double score;  //评分
@property (nonatomic, assign) NSInteger scoreType;  //正分  负分
@property (nonatomic, strong) NSMutableArray *scoreArray;  //视频评分值
@end

@implementation PostNewVideoCommentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.gk_navigationItem.title = @"评论";
    self.gk_navRightBarButtonItem = self.postButton;

    [self setupUI];
    [self setupLayout];
}
- (void)setupUI{
    [self initScoreArea];
    [self.view addSubview:self.commentImportview];
}

- (void)setupLayout{
    [self layoutScoreArea];
    [self.commentImportview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scoreArea.mas_bottom).offset = 30;
        make.left.right.offset = 0;
        make.bottom.mas_offset(0);
    }];
}

- (void)layoutScoreArea {
    
    [scoreArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(StatusAndNaviHeight);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(pentagramView).mas_offset(0);
    }];
    
    [scoreTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15.5);
        make.centerX.equalTo(scoreArea);
        make.width.mas_equalTo(118);
        make.height.mas_equalTo(14);
    }];
        
    [plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(14);
    }];
    
    [minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(14);
    }];
    
    [scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scoreTypeView.mas_bottom).mas_offset(10);
        make.centerX.equalTo(scoreArea);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(12);
    }];
    
    [pentagramView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scoreL.mas_bottom).mas_offset(10);
        make.centerX.equalTo(scoreArea);
        make.width.mas_equalTo(191);
        make.height.mas_equalTo(29);
//        make.bottom.mas_offset(0);
    }];
}

#pragma mark -- 评分部分 --

- (void)initScoreArea {
    //评分
    scoreArea = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:scoreArea];

    //正负分
    scoreTypeView = [[UIView alloc] initWithFrame:CGRectZero];
    [scoreArea addSubview:scoreTypeView];

    //正分
    self.scoreType = 0;

    plusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 14)];
    [scoreTypeView addSubview:plusButton];
    plusButton.tag = 10;

    plusButton.titleLabel.font = PingFangSC_Regular(14);
    [plusButton setTitleColor:UICOLOR(@"#868686") forState:UIControlStateNormal];
    [plusButton setTitleColor:UICOLOR(@"#EFB400") forState:UIControlStateSelected];
    [plusButton setTitle:@"正分" forState:UIControlStateNormal];
    [plusButton setTitle:@"正分" forState:UIControlStateSelected];

    //默认正分
    plusButton.selected = YES;
    SEL aciton = @selector(updateScoreTypeStatus:);
    [plusButton setImage:[UIImage imageNamed:@"unSelected_scoreType"] forState:UIControlStateNormal];
    [plusButton setImage:[UIImage imageNamed:@"selected_score_plus"] forState:UIControlStateSelected];
    [plusButton SG_imagePositionStyle:SGImagePositionStyleLeft spacing:4.0];
    [plusButton addTarget:self action:aciton forControlEvents:UIControlEventTouchUpInside];

    //    [self updateScoreTypeStatus:plusButton];


     //负分
    minusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 14)];
    [scoreTypeView addSubview:minusButton];

    minusButton.tag = 20;
    minusButton.selected = NO;
    minusButton.titleLabel.font = PingFangSC_Regular(14);

    [minusButton setTitleColor:UICOLOR(@"#343338") forState:UIControlStateNormal];
    [minusButton setTitleColor:UICOLOR(@"#343338") forState:UIControlStateSelected];

    [minusButton setTitle:@"负分" forState:UIControlStateNormal];
    [minusButton setTitle:@"负分" forState:UIControlStateSelected];

    [minusButton setImage:[UIImage imageNamed:@"unSelected_scoreType"] forState:UIControlStateNormal];
    [minusButton setImage:[UIImage imageNamed:@"selected_score_minus"] forState:UIControlStateSelected];
    [minusButton SG_imagePositionStyle:SGImagePositionStyleLeft spacing:4.0];
    [minusButton addTarget:self action:aciton forControlEvents:UIControlEventTouchUpInside];
    //    [self updateScoreTypeStatus:minusButton];

    //分值
    scoreL = [[UILabel alloc] initWithFrame:CGRectZero];
    self.score = 0;  //默认
    scoreL.text = @"0";
    scoreL.textAlignment = NSTextAlignmentCenter;
    scoreL.font = PingFangSC_Regular(12);
    scoreL.textColor = UICOLOR(@"#868686");
    [scoreArea addSubview:scoreL];

    //星星列表
    pentagramView = [[UIView alloc] initWithFrame:CGRectZero];
    [self test_masonry_horizontal_fixSpace];
    [scoreArea addSubview:pentagramView];
}

- (void)updateScoreTypeStatus:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 10) {
        if (sender.selected) {
            plusButton.selected = YES;
            minusButton.selected = NO;
            self.scoreType = 0;  //正分
        }
    } else {
        if (sender.selected) {
            self.scoreType = 1;  //负分
            minusButton.selected = YES;
            plusButton.selected = NO;
        }
    }
    
    if (plusButton.selected) {
        minusButton.selected = NO;

        for (NSInteger i = 0; i < _scoreArray.count; i++) {
            UIImageView *pentagramImage = self.scoreArray[i];
            if (i < (NSInteger)self.score) {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_plus"];
            }
            [_scoreArray replaceObjectAtIndex:i withObject:pentagramImage];
        }
    } else {
        plusButton.selected = NO;

        for (NSInteger i = 0; i < _scoreArray.count; i++) {
            UIImageView *pentagramImage = self.scoreArray[i];
            if (i < (NSInteger)self.score) {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_minus"];
            }
            [_scoreArray replaceObjectAtIndex:i withObject:pentagramImage];
        }
    }
    
    [self updateScoreValue];
}

/* 更改分值 */
- (void)updateScoreValue {
      if (self.scoreType == 0) {
          scoreL.text = [NSString stringWithFormat:@"+%@",[@(self.score) stringValue]];
      } else {
          scoreL.text = [NSString stringWithFormat:@"-%@",[@(self.score) stringValue]];
      }
}

- (BOOL)isPlusScoreType {
    BOOL is = NO;
    if (plusButton.selected) {
        is = YES;
    }
    return is;
}

/* 更改星星颜色 */
- (void)changeScore:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    
    for (int i = 0; i < self.scoreArray.count; i ++) {
        UIImageView *pentagramImage = self.scoreArray[i];

        if ([self isPlusScoreType]) {
             if (i <= imageView.tag - 10) {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_plus"];
             } else {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_default"];
             }
            [_scoreArray replaceObjectAtIndex:i withObject:pentagramImage];
            self.score = (double)imageView.tag + 1 - 10;  //分数
            [self updateScoreValue];

        } else {
            if (i <= imageView.tag - 10) {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_minus"];
            } else {
                pentagramImage.image = [UIImage imageNamed:@"pentagram_default"];
            }
            [_scoreArray replaceObjectAtIndex:i withObject:pentagramImage];
            self.score = (double)imageView.tag + 1 - 10;  //分数
            [self updateScoreValue];
        }

    }
}

/* 初始化星星 */
- (NSMutableArray *)scoreArray {
    if (!_scoreArray) {
        _scoreArray = [NSMutableArray array];
        for (int i = 0; i < 5; i ++) {
            UIImageView *pentagramImage = [[UIImageView alloc] initWithFrame:CGRectZero];
            pentagramImage.tag = i + 10;
            pentagramImage.userInteractionEnabled = YES;
            pentagramImage.image = [UIImage imageNamed:@"pentagram_default"];  //默认
            [pentagramView addSubview:pentagramImage];  //放入五角星
            [_scoreArray addObject:pentagramImage];
            UITapGestureRecognizer *select = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeScore:)];
            [pentagramImage addGestureRecognizer:select];
        }
    }
    return _scoreArray;
}

/* 评分五角星排列 */
- (void)test_masonry_horizontal_fixSpace {
    // 实现masonry水平固定间隔方法
    [self.scoreArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:11.5 leadSpacing:0 tailSpacing:0];

    // 设置array的垂直方向的约束
    [self.scoreArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pentagramView).offset(0);
        make.height.mas_equalTo(29);
    }];
}


#pragma mark --Event
//点击屏幕 结束编辑
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)backAction {
    if (self.commentImportview.brainholeCommentText.length == 0) {
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
    //准备更新上传的内容
    [self.commentImportview reloadUpdateConten];
    [self.view endEditing:YES];
    [self upDateContent];

}

/* 发布 */
- (void)upDateContent {
    //禁止连续点击
    self.postButton.enabled = NO;
       
    if (self.commentImportview.brainholeCommentText.length == 0) {
        if (self.score == 0) {
            self.postButton.enabled = YES;
            [SVProgressHUD showInfoWithStatus:@"还什么都没有写呢"];
            [SVProgressHUD dismissWithDelay:1.2];
            return;
        }
    }
    NSDictionary *param = @{
                             @"aType": @(self.scoreType),
                             @"picUrl": self.commentImportview.imageUrl,
                             @"videoId": @(self.brainholeVideoId),
                             @"score": @(self.score),
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
