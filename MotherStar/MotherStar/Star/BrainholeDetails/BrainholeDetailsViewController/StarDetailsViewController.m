//
//  StarDetailsViewController.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/30.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "StarDetailsViewController.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"

static NSString *commentCellID = @"commentCellReuseIdentifier";


@interface StarDetailsViewController () <UITableViewDelegate, UITableViewDataSource>  {
    UITableViewHeaderFooterView *tableHeaderView;
    UIView *headerView;  //顶部视图

    UILabel *item;  //项目
    UILabel *itemValue;  //帖子总数
    
    UILabel *hotIndex;  //热度指数
    UILabel *hotIndexValue;
    
    UIImageView *hotImageView;  //角标
    
    UIView *starSummaryView;
    UILabel *starSummary;  //星球简介
    
    UITableView *commentTableView;  //评论

}

@property (nonatomic, strong) NSMutableArray *commentsArray;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImage *backgroundImage;


@end

@implementation StarDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
        
    
    self.gk_navigationItem.title = @"星球";  //修改为  具体的星球名称
    
//    [self.navigationController.navigationBar setTranslucent:YES];
    
//    [self.navigationController.navigationBar setTranslucent:YES];

    self.gk_navigationBar.translucent = NO;
    
//    self.extendedLayoutIncludesOpaqueBars = YES;

//    self.gk_navigationBar.shadowImage = [UIImage new];

    self.backgroundImage = [UIImage imageNamed:@"starDetailsBG.jpg"];
    self.backgroundImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];

    [self.gk_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_background_transparent"] forBarMetrics:UIBarMetricsDefault];  //透明图片
    
    self.gk_navigationBar.layer.masksToBounds = YES;
    
    [self testCommentModel];
    
    [self initStarDetailsView];
    
}

- (void)testCommentModel {
    
    CommentModel *model1 = [[CommentModel alloc] init];
    model1.title = @"孩童时代的友情只是愉快的嘻戏，成年人靠着回忆追加给它的东西很不真实。友情的真正意义产生于成年之后，它不可能在尚未获得意义之时便抵达最佳状态。 ";
    
    
    CommentModel *model2 = [[CommentModel alloc] init];
    model2.title = @"我想，艰难的远不止我。近年来参加了几位前辈的追悼会，注意到一个细节：悬挂在灵堂中间的挽联常常笔涉高山流水，但我知道，死者对于挽联撰写者的感觉并非如此。然而这又有什么用呢？在死者失去辩驳能力仅仅几天之后，在他唯一的人生总结仪式里，这一友情话语乌黑鲜亮，强硬得无法修正，让一切参加仪式的人都低头领受。";
    
    CommentModel *model3 = [[CommentModel alloc] init];
    model3.title = @"真正的友情不依靠什么。";


    self.commentsArray = @[model1, model2, model3].mutableCopy;
    
    
}

- (void)initStarDetailsView {
    
    tableHeaderView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectZero];
    tableHeaderView.backgroundColor = [UIColor clearColor];

    
    [tableHeaderView insertSubview:self.backgroundImageView atIndex:0];
    
   
    //顶部视图
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [tableHeaderView addSubview:headerView];
    

    //项目
    item = [[UILabel alloc] initWithFrame:CGRectZero];
    item.text = @"项目";
    item.font = PingFangSC_Regular(12);
//    item.textColor = UICOLOR(@"#FFFFFF");
    item.textColor = [UIColor redColor];
    [headerView addSubview:item];

    
    itemValue = [[UILabel alloc] initWithFrame:CGRectZero];
    itemValue.text = @"1234";
    itemValue.font = PingFangSC_Regular(18);
//    itemValue.textColor = UICOLOR(@"#FFFFFF");
    itemValue.textColor = [UIColor redColor];

    [headerView addSubview:itemValue];

    hotIndex = [[UILabel alloc] initWithFrame:CGRectZero];
    hotIndex.text = @"热度指数";
    hotIndex.font = PingFangSC_Regular(12);
//    hotIndex.textColor = UICOLOR(@"#FFFFFF");
    hotIndex.textColor = [UIColor redColor];

    [headerView addSubview:hotIndex];


    hotIndexValue = [[UILabel alloc] initWithFrame:CGRectZero];
    hotIndexValue.text = @"2345";
    hotIndexValue.font = PingFangSC_Regular(18);
//    hotIndexValue.textColor = UICOLOR(@"#FFFFFF");
    hotIndexValue.textColor = [UIColor redColor];

    [headerView addSubview:hotIndexValue];

    hotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11.5, 5.5)];  //隐藏  一定数值显示
    hotImageView.image = [UIImage imageNamed:@"hot.png"];
    [headerView addSubview:hotImageView];

    starSummaryView = [[UIView alloc] initWithFrame:CGRectZero];
    [tableHeaderView addSubview:starSummaryView];

    //星球简介
    starSummary = [[UILabel alloc] initWithFrame:CGRectZero];
    starSummary.font = PingFangSC_Regular(10);
//    starSummary.textColor = UICOLOR(@"#FFFFFF");
    starSummary.textColor = [UIColor redColor];

    starSummary.text = @"银河系是一个旋涡星系，具有旋涡结构，也有自转。 它的主要组成部分是：旋臂的银盘，中央突起的银心和晕轮三部分。 即有一个银心和两个旋臂，旋臂主要由星际物质构成，旋臂相距4500光年。 太阳位于银河一个支臂猎户臂上，至银河中心的距离大约是26,000光年。";
    starSummary.numberOfLines = 0;
    [starSummary sizeToFit];
    [starSummaryView addSubview:starSummary];
    
    //评论
      commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
      commentTableView.delegate = self;
      commentTableView.dataSource = self;
      commentTableView.estimatedRowHeight = 200;
      commentTableView.rowHeight = UITableViewAutomaticDimension;
      commentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;  //分割线
      commentTableView.separatorColor = UICOLOR(@"#F6F6F6");
      commentTableView.separatorInset = UIEdgeInsetsMake(0, 36, 0, 0); //top left bottom right

      commentTableView.tableHeaderView = tableHeaderView;
      [self.view addSubview:commentTableView];


    //脑洞列表
//    [commentTableView layoutIfNeeded];
    
    [self.view setNeedsUpdateConstraints];  //更新布局

   
}

- (void)updateViewConstraints {
    
    [commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(NavigationBarHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [tableHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.equalTo(starSummaryView.mas_bottom).offset(10);  //test
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(tableHeaderView).offset(0);  //test

    }];
    
    [headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(18);
    }];
    
    [item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_offset(0);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(12);
    }];
    
    [itemValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_offset(36);
        make.width.mas_equalTo(51.5);  //自适应宽度
        make.height.mas_equalTo(18);
    }];
    
    [hotIndex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_offset(107);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(12);
    }];
    
    [hotIndexValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_offset(165);
        make.width.mas_equalTo(45.5);
        make.height.mas_equalTo(18);
    }];
   
    [hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_offset(212);  //test
        make.width.mas_equalTo(11.5);
        make.height.mas_equalTo(5.5);
    }];
   
    [starSummaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 32);
    }];
    
    [starSummary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(starSummaryView);
    }];
    
    [commentTableView.tableHeaderView layoutIfNeeded];  //重点
    
    [super updateViewConstraints];

}

#pragma mark -- 评论列表 delegate dataSource --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentsArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellID];
//        cell.backgroundColor = [UIColor colorWithHex:@"#F8F8FB"];
    }
    
    CommentModel *model = self.commentsArray[indexPath.row];
    cell.commentModel = model;

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

#pragma mark  -- 约束 --

//- (void)updateViewConstraints {
//    [super updateViewConstraints];
//}



@end
