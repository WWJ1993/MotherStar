//
//  HotBrainholeVideoTableViewCell.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/30.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "HotBrainholeVideoTableViewCell.h"
#import "HotBrainholeVideoCollectionViewCell.h"
#import "HotBrainholeVideoModel.h"
#import "HotBrainholeModel.h"
#import "TagModel.h"

NSInteger const SJMediasCollectionViewTag = 111;   //播放器定位

NSInteger const SJMediaCoverTag = 101;



static NSString *cellId = @"HotBrainholeVideoCollectionViewCellId";

@interface HotBrainholeVideoTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    UIView *hotView;  //文本视图
    
    UIView *headerView;  //顶部视图
    
    UIView *contentView;  //脑洞内容

    UIView *thinSeparationLine;  //分割线
    
    UIView *fuelView;  //燃料
    UIImageView *fuelImageView;
    
    UIView *tagView;  //标签视图

    UIView *footerView;  //底部视图
    
    UIView *starView;  //星球
    UIButton *starButton;
    
    UIView *likeView;  //点赞
    UIButton *likeButton;
    
    UIView *shareView;  //分享
    UIButton *shareButton;
    
    UIView *thickSeparationLine;

}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger likeNumChanged;
@property (nonatomic, assign) NSInteger likeStatusChanged;



@end

@implementation HotBrainholeVideoTableViewCell

//- (NSMutableArray *)videoListArray {
//    if (_videoListArray == nil) {
//        _videoListArray = @[].mutableCopy;
//    }
//    return _videoListArray;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initHotBrainholeVideoView];
        
        [self layoutIfNeeded];
    }
    return self;
}

- (void)initHotBrainholeVideoView {
    //添加子控件
    hotView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:hotView];

    //顶部视图
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [hotView addSubview:headerView];

    //头像
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView .frame.size.width /2;  //圆形
    self.avatarImageView.clipsToBounds = YES;
    [headerView addSubview:self.avatarImageView];

    //昵称
    self.nickname = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nickname.font = PingFangSC_Regular(14);
    self.nickname.textColor = UICOLOR(@"#343338");
    [headerView addSubview:self.nickname];

    //燃料数
    fuelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 48, 20)];
    fuelView.layer.cornerRadius = 4;
    fuelView.layer.borderWidth = 1;
    fuelView.layer.borderColor = UICOLOR(@"#FF861A").CGColor;
    [headerView addSubview:fuelView];

    fuelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 8, 10)];
    fuelImageView.image = [UIImage imageNamed:@"fuel"];
    [fuelView addSubview:fuelImageView];

    self.fuel = [[UILabel alloc] initWithFrame:CGRectMake(19, 5, 22, 10)];
    self.fuel.textAlignment = NSTextAlignmentCenter;
    self.fuel.font = PingFangSC_Regular(10);
    self.fuel.textColor = UICOLOR(@"#FF861A");
    [fuelView addSubview:self.fuel];

    //脑洞内容
    contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [hotView addSubview:contentView];
    
    //进入脑洞详情
    UITapGestureRecognizer *tapGestureEdit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterToBrainholeDetailsTapGesture)];
    [contentView addGestureRecognizer:tapGestureEdit];
    
    // -  -  - -  -  - -  -  - -  -  - -  -  - -  -  - -  -  - -  -  -

        self.content = [[UITextView alloc] initWithFrame:CGRectZero];
        self.content.showsVerticalScrollIndicator = NO;
        self.content.scrollEnabled = NO;
        self.content.userInteractionEnabled = NO;
        self.content.editable = NO;

        [contentView addSubview:self.content];

        // -  -  - -  -  - -  -  - -  -  - -  -  - -  -  - -  -  - -  -  -

    //标签
    tagView = [[UIView alloc] initWithFrame:CGRectZero];
    [hotView addSubview:tagView];

    self.tagL = [[IXAttributeTapLabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 32, 14)];
    self.tagL.textAlignment = NSTextAlignmentLeft;
    self.tagL.font = PingFangSC_Regular(14);
    self.tagL.textColor = UICOLOR(@"#6692EE");
    self.tagL.numberOfLines = 1;
    [tagView addSubview:self.tagL];


    //---------------------------------------------------------------------------------
    [self initCollectionView];  //视频第一帧
    //---------------------------------------------------------------------------------

    //分割线
    thinSeparationLine = [[UIView alloc] initWithFrame:CGRectZero];
    thinSeparationLine.backgroundColor = UICOLOR(@"#F1F1F1");
    [hotView addSubview:thinSeparationLine];

    //底部视图
    footerView = [[UIView alloc] initWithFrame:CGRectZero];
    [hotView addSubview:footerView];

    //星球
    starView = [[UIView alloc] initWithFrame:CGRectZero];
    [footerView addSubview:starView];

    starButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    starButton.tag = 11;
    [starButton setImage:[UIImage imageNamed:@"footer_star"] forState:UIControlStateNormal];
    [starView addSubview:starButton];
    [starButton setEnlargeEdgeWithTop:5 right:30 bottom:5 left:5];

    self.starName = [[UILabel alloc] initWithFrame:CGRectMake(26, 4, 28, 14)];
    self.starName.font = PingFangSC_Regular(14);
    self.starName.textColor = UICOLOR(@"#343338");
    [starView addSubview:self.starName];

    //点赞
    likeView = [[UIView alloc] initWithFrame:CGRectZero];
    [footerView addSubview:likeView];

    likeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    likeButton.tag = 12;

    [likeButton setImage:[UIImage imageNamed:@"footer_like_default"] forState:UIControlStateNormal];
    [likeView addSubview:likeButton];

    self.likeSum = [[UILabel alloc] initWithFrame:CGRectMake(26, 4, 28, 14)];

    self.likeSum.font = PingFangSC_Regular(14);
    self.likeSum.textColor = UICOLOR(@"#343338");
    [likeView addSubview:self.likeSum];

    //分享
    shareView = [[UIView alloc] initWithFrame:CGRectZero];
    [footerView addSubview:shareView];

    shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    shareButton.tag = 13;
    [shareButton setImage:[UIImage imageNamed:@"footer_share"] forState:UIControlStateNormal];
    [shareView addSubview:shareButton];

    self.shareSum = [[UILabel alloc] initWithFrame:CGRectMake(26, 4, 28, 14)];
    self.shareSum.font = PingFangSC_Regular(14);
    self.shareSum.textColor = UICOLOR(@"#343338");
    [shareView addSubview:self.shareSum];

    //分割线 - 粗
//    thickSeparationLine = [[UIView alloc] initWithFrame:CGRectZero];
//    thickSeparationLine.backgroundColor = UICOLOR(@"#F6F6F6");
//    [hotView addSubview:thickSeparationLine];
    
    NSArray *itemArray = @[starButton, likeButton, shareButton];
    SEL action = @selector(targetAction:);
    for (UIButton *button in itemArray) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -- 通知 --

/* 进入脑洞详情 */
- (void)enterToBrainholeDetailsTapGesture {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnterToBrainholeDetailsNotification" object:self.brainholeModel];
}

/* 星球 - 点赞 - 分享 */
- (void)targetAction:(UIButton *)sender {
    if (sender.tag == 12) {
//       //是否点过赞 0：否 1：是
       NSInteger likenStatues = self.brainholeModel.isStatus;
        NSInteger likeNum = self.brainholeModel.likeNum;

        sender.selected = !sender.selected;
        
        if (likenStatues == 0 && _likeStatusChanged == 0) {
            _likeStatusChanged = 0;
        }
        else if (likenStatues == 0 && likenStatues != _likeStatusChanged) {
            _likeStatusChanged = 0;
        }
        
        else if (likenStatues == 1 && likenStatues != _likeStatusChanged) {
            _likeStatusChanged = 1;
        }
        
        if (_likeStatusChanged == 0) {
            if (sender.selected) {
                likeNum++;
                sender.selected = NO;
                _likeStatusChanged = 1;
                _likeNumChanged = likeNum;
                [likeButton setImage:[UIImage imageNamed:@"footer_like"] forState:UIControlStateNormal];
            }
        } else {
            if (sender.selected) {
                if (likeNum != _likeNumChanged && _likeNumChanged > 0) {
                    likeNum = _likeNumChanged;
                }
                
                if (likeNum > 0) {
                    likeNum--;
                }

                _likeNumChanged = likeNum;
                 _likeStatusChanged = 0;
                sender.selected = NO;
                [likeButton setImage:[UIImage imageNamed:@"footer_like_default"] forState:UIControlStateNormal];
            }
        }
        self.likeSum.text = [@(likeNum) stringValue];
      
        self.brainholeModel.isStatus = _likeStatusChanged;
        self.brainholeModel.likeNum = _likeNumChanged;
        
    }
    
    NSDictionary *object = @{
                              @"tag":@(sender.tag),
                              @"brainholeModel":self.brainholeModel
                            };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BrainholeCellFooterNotification" object:object];
}


- (void)initCollectionView {
    if (self.collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        layout.itemSize = CGSizeMake(SCREENWIDTH - 68, 173);

        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(18, 0, SCREENWIDTH - 36, 173) collectionViewLayout:layout];
        self.collectionView.contentInset = UIEdgeInsetsMake(5, 10, 5, 10);
        self.collectionView.showsHorizontalScrollIndicator = NO;

        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[HotBrainholeVideoCollectionViewCell class] forCellWithReuseIdentifier:cellId];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [hotView addSubview:self.collectionView];
    }
}

#pragma mark -- 更新数据 --

- (void)updateModel {
    // - 顶栏 -
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.brainholeModel.picUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.nickname.text = self.brainholeModel.nickName;
    self.fuel.text = self.brainholeModel.oilNum;

    // - 脑洞内容 - 富文本
    [self initTextView:self.brainholeModel.contentAttribute url:self.brainholeModel.firstPictureUrl];

    //标签
    [self setTagStringAndClickAction:self.brainholeModel.tagArray];
    
    // - 底栏 -
    self.starName.text = self.brainholeModel.starTag;

    //点赞状态
    if (self.brainholeModel.isStatus != 0) {
        [likeButton setImage:[UIImage imageNamed:@"footer_like"] forState:UIControlStateNormal];  //点赞状态
    } else {
        [likeButton setImage:[UIImage imageNamed:@"footer_like_default"] forState:UIControlStateNormal];
    }
    self.likeSum.text = [@(self.brainholeModel.likeNum) stringValue];
    self.shareSum.text = [@(self.brainholeModel.shareNum) stringValue];
}

#pragma mark -- 数据处理 --

/* 组装标签并实现点击选中标签事件 */
- (void)setTagStringAndClickAction:(NSArray *)tagModelArray {
    if (!tagModelArray) {
        return;
    }

    NSString *tagAllString = @"";  //标签普通字符串
    NSString *spaceString = @" ";
    NSMutableArray *modelArray = @[].mutableCopy;
    for (NSInteger i = 0; i < tagModelArray.count; i++) {
        TagModel *tagModel = tagModelArray[i];
        tagAllString = [tagAllString stringByAppendingString:tagModel.tagTitle];

        //TagModel转IXAttributeModel 实现点击选中字符串事件
        IXAttributeModel *IXModel = [[IXAttributeModel alloc] init];
        IXModel.id = tagModel.id;
        IXModel.range = [tagAllString rangeOfString:tagModel.tagTitle];
        IXModel.string = tagModel.tagTitle;
        IXModel.attributeDic = @{ NSForegroundColorAttributeName : UICOLOR(@"#6692EE") };

        [modelArray addObject:IXModel];
        tagAllString = [tagAllString stringByAppendingString:spaceString];
    }
       
    //标签内容-富文本
    [self.tagL setText:tagAllString attributes:@{NSForegroundColorAttributeName:UICOLOR(@"#6692EE"), NSFontAttributeName:PingFangSC_Regular(14)} tapStringArray:modelArray];
    
    self.tagL.tapBlock = ^(NSString *string) {
         for (NSInteger i = 0; i < modelArray.count; i++) {
             IXAttributeModel *IXModel = modelArray[i];
             if ([string isEqualToString:IXModel.string]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"TagDetailsNotification" object:IXModel];
                 return;
             }
         }
    };
}

- (void)initTextView:(NSAttributedString *)attributedString url:(NSString *)url {
//    [self.content layoutIfNeeded];
//    [contentView layoutIfNeeded];

    //图片frame 贝塞尔曲线 路径 待修改
    if (url && url.length > 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 32 - 115, 10, 115, 65)];
        imageView.userInteractionEnabled = YES;
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;  //图片不变形
        imageView.clipsToBounds = YES;  //裁剪
        [self.content addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        UIBezierPath *path = [self translatedBezierPath:imageView];
        self.content.textContainer.exclusionPaths = @[path];
    }
    self.content.attributedText = attributedString;
}

- (UIBezierPath *)translatedBezierPath:(UIImageView *)imageView {
    CGRect imageRect = [self.content convertRect:imageView.frame fromView:self.content];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(imageRect.origin.x+5, imageRect.origin.y, imageRect.size.width-5, imageRect.size.height-5)];
    return bezierPath;
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


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateModel];  //真实赋值
    
    [self.collectionView reloadData];

    [hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hotView).offset(0);  //最上面一个控件
        make.left.right.equalTo(hotView).offset(0);
        make.height.mas_equalTo(28);
    }];

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.height.mas_equalTo(28);
        make.bottom.equalTo(headerView).offset(0);
    }];

    [self.nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(8);
        make.right.mas_equalTo(fuelView.mas_left).mas_offset(8);
        make.centerY.mas_equalTo(self.avatarImageView.mas_centerY);
        make.bottom.equalTo(headerView).offset(0);
    }];
    
    [fuelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(4);
        make.right.equalTo(headerView).offset(-16);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(headerView).offset(0);
    }];
     
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).mas_offset(14);
//        make.left.right.mas_equalTo(0);
        make.left.mas_offset(0);
        make.right.mas_offset(-16);
        make.height.equalTo(@110);  //test
    }];

    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).mas_offset(10);
        make.left.right.offset(0);
        make.height.mas_equalTo(16);
    }];
    
    [self.tagL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
        make.height.mas_equalTo(14);
    }];
    
    //-----------------------视图第一帧----------------------------------------

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagView.mas_bottom).offset(10);
        make.left.offset(18);
        make.right.offset(0);
        make.height.mas_equalTo(173);
    }];
    
    //---------------------------------------------------------------

    [thinSeparationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).mas_offset(16);
        make.left.right.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thinSeparationLine).mas_offset(12);  //test
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(22);
        make.bottom.equalTo(hotView).offset(0);  //最下面一个控件
    }];

    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_offset(0);
        make.left.mas_offset(0);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(22);
    }];

    [likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(((SCREENWIDTH - 32) / 2) - 11);
    }];

    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(22);
        make.right.mas_equalTo(0);
    }];

//    [thickSeparationLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(footerView.mas_bottom).mas_offset(0);
//        make.width.mas_equalTo(SCREENWIDTH);
//        make.height.mas_equalTo(10);
//    }];
}


#pragma mark -- UICollectionViewDelegate --

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.brainholeModel.videoArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotBrainholeVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    HotBrainholeVideoModel *videoModel = self.brainholeModel.videoArray[indexPath.row];
    
    videoModel.collectionViewCellIndexPath = indexPath;
    videoModel.playerSuperViewTag = SJMediaCoverTag;
    videoModel.collectionViewTag = SJMediasCollectionViewTag;
    videoModel.tableViewCellIndex = self.brainholeModel.tableViewCellIndex;
    
    cell.hotBrainholeVideoModel = videoModel;
    [cell setNeedsLayout];


    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    cell.layer.mask = shape;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HotBrainholeVideoModel *model = self.brainholeModel.videoArray[indexPath.row];
    NSInteger index = indexPath.item;
    NSDictionary *videoDic = @{ @"videoId":@(model.id),
                                @"index":@(index),
                                @"videoModelArray":self.brainholeModel.videoArray
                              };
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"BrainholeVideoNotification" object:videoDic];   //视频id
      [[NSNotificationCenter defaultCenter] postNotificationName:@"BrainholeVideoNotification" object:videoDic];
}

@end
