//
//  MineLikeViewController.m
//  MotherStar
//
//  Created by yanming niu on 2020/1/20.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "MineLikeViewController.h"

static NSString *hotTextCellID = @"hotCellTextReuseIdentifier";
static NSString *hotVideoCellID = @"hotCellVideoReuseIdentifier";

@interface MineLikeViewController () <UITableViewDelegate, UITableViewDataSource> {
    int loadDataCount;  //上拉加载
    NSString *firstPictureUrl;  //脑洞第一张图片地址


}
@property (nonatomic, strong) UITableView *hotBrainholeTableView;
@property (nonatomic, strong) NSMutableArray *braninholesArray;

@end

@implementation MineLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    loadDataCount = 0;
    self.braninholesArray = @[].mutableCopy;

    
    [self requestMineLikeList];

    //热门脑洞
    self.hotBrainholeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.hotBrainholeTableView.frame = CGRectMake(0, StatusAndNaviHeight, SCREENWIDTH, SCREENHEIGHT);
    self.hotBrainholeTableView.delegate = self;
    self.hotBrainholeTableView.dataSource = self;
    self.hotBrainholeTableView.estimatedRowHeight = 300;
    self.hotBrainholeTableView.rowHeight = UITableViewAutomaticDimension;
    self.hotBrainholeTableView.showsVerticalScrollIndicator = NO;
    self.hotBrainholeTableView.tableFooterView = [UIView new];  //不显示多余的分割线
    self.hotBrainholeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.hotBrainholeTableView];

    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.hotBrainholeTableView.mj_header = header;

    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(pull)];
    footer.stateLabel.hidden = YES;

    self.hotBrainholeTableView.mj_footer = footer;
}

#pragma mark -- 数据请求 --

//下拉刷新
- (void)refresh {
    loadDataCount = 0;
    [self requestMineLikeList];
}

//上拉加载
- (void)pull {
    [self requestMineLikeList];
}

- (void)requestMineLikeList {
    //考虑 返回失败不删除数据的情况
    loadDataCount++;
    if (loadDataCount == 1) {
        if (self.braninholesArray && self.braninholesArray.count > 0) {
            [self.braninholesArray removeAllObjects];  //清空
        }
    }
    
    NSDictionary *param = @{
                             @"pageNum":@(loadDataCount),
                             @"pageSize":@(10)
                           };
    NSString *token = [AppCacheManager sharedSession].token;
    [RequestHandle requestMineLikeList:param authorization:token
        uploadProgress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            [self endRefreshing];
            return;
        }
                NSArray *list = response[@"data"][@"list"];
                if (list.count == 0) {
                    self->loadDataCount--;
                }
                
                for (NSInteger i = 0; i < list.count; i++) {
                    @autoreleasepool {
                        NSDictionary *brainholeDic = list[i][@"hotPost"][@"post"];  //脑洞

                        HotBrainholeModel *brainholeModel = [HotBrainholeModel mj_objectWithKeyValues:brainholeDic];
                        
                        NSArray *tagArray = list[i][@"tagDto"][@"tags"];  //脑洞标签
                        NSMutableArray *tagModelAraay = @[].mutableCopy;
                        for (NSInteger i = 0; i < tagArray.count; i++) {
                            NSDictionary *tagDic = tagArray[i];
                            TagModel *tagModel = [TagModel mj_objectWithKeyValues:tagDic];
                            [tagModelAraay addObject:tagModel];
                        }
                        
                        brainholeModel.tagArray = [tagModelAraay copy];
                        
                        if (brainholeModel == nil) {
                            continue;
                        }
                        
                        NSInteger orgial = brainholeModel.original;  //原创标记
                        BOOL orgialBool = NO;
                        if (orgial == 0) {
                            orgialBool = YES;
                        }
                        //转换为富文本
                        NSAttributedString *contentAttribute = [self handleBrainholeContent:orgialBool   title:brainholeModel.title content:brainholeModel.content];
                        brainholeModel.firstPictureUrl = self->firstPictureUrl;  //脑洞第一张图片
                        brainholeModel.contentAttribute = contentAttribute;
                        
                        //获取视频
                        brainholeModel.videoArray = @[].mutableCopy;

                        NSDictionary *userDic = list[i][@"hotPost"][@"user"];
                        if (![userDic isKindOfClass:[NSNull class]]) {
                            brainholeModel.nickName = userDic[@"nickName"];  //增加用户头像和昵称
                            brainholeModel.picUrl = userDic[@"picUrl"];
                        }

                        NSArray *videoArray = list[i][@"hotPost"][@"videoList"];  //视频
                        if (videoArray.count > 0) {
                            brainholeModel.brainholeType = 1;  //含视频
                            for (NSInteger j = 0; j < videoArray.count; j++) {
                                 NSDictionary *videoDic = videoArray[j];
                                 HotBrainholeVideoModel *vModel = [HotBrainholeVideoModel mj_objectWithKeyValues:videoDic];
                                [brainholeModel.videoArray addObject:vModel];
                            }
                        } else if (videoArray.count == 0){
                            brainholeModel.brainholeType = 0;
                        }
                      
                        [self.braninholesArray addObject:brainholeModel];
                     }
                }
                if (list.count > 0) {
                    [self.hotBrainholeTableView reloadData];
                    [self.hotBrainholeTableView setNeedsLayout];

                    [self.view setNeedsUpdateConstraints];  //更新布局
                }
            
               [self endRefreshing];
    } fail:^(NSError * _Nonnull error) {
        [self endRefreshing];
        self->loadDataCount--;
    }];
}

#pragma mark -- 请求数据处理 -  --

- (NSAttributedString *)handleBrainholeContent:(BOOL)isOriginal title:(NSString *)title content:(NSString *)content {
    //解析<img>标签
    firstPictureUrl = @"";
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
    
    return contentResultAttString;  //富文本
 }

/* 设置富文本样式 */
- (NSMutableAttributedString *)setContentToAttributedTextStyle:(BOOL)isOriginal title:(NSString *)title content:(NSString *)content {
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

- (NSAttributedString *)setAttactToAttributeSting:(UIImage *)image {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, -2, 28, 16);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    return attachmentString;
}

#pragma mark -- 解析HTML  --

/* 获取<img src = > */
- (NSArray *)filterImageUrlFromHTML:(NSString *)html {
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
- (NSArray *)filterTextFromHTML:(NSString *)html {
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


- (void)endRefreshing {
    [self.hotBrainholeTableView.mj_header endRefreshing];
    [self.hotBrainholeTableView.mj_footer endRefreshing];
}

#pragma mark -- 脑洞列表代理方法 --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.braninholesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotBrainholeModel *model = [[HotBrainholeModel alloc] init];
    if (self.braninholesArray && self.braninholesArray.count > 0 ) {
        model = self.braninholesArray[indexPath.row];
    }
    
    if (model.brainholeType == 0) {
        HotBrainholeTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotTextCellID];
        if (!cell) {
            cell = [[HotBrainholeTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotTextCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.brainholeModel = model;
        return cell;
        
    } else {
        HotBrainholeVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotVideoCellID];
           if (!cell) {
               cell = [[HotBrainholeVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotVideoCellID];
           }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.brainholeModel = model;
        cell.brainholeModel.tableViewCellIndex = indexPath;
        return cell;
    }
    return nil;
}


@end
