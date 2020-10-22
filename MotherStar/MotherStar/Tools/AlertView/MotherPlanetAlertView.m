//
//  MotherPlanetAlertView.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/24.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "MotherPlanetAlertView.h"

@interface MotherPlanetAlertView ()
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) EdgeInsetsLabel *titleL;
@property (nonatomic, strong) EdgeInsetsLabel *messageL;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *okButton;
@end

@implementation MotherPlanetAlertView

static MotherPlanetAlertView *alertView;

+ (MotherPlanetAlertView *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertView = [MotherPlanetAlertView new];

    });
    
    
    return alertView;
}
-(instancetype)initDeviceToken:(NSString *)deviceToken{
    self = [super init];
    if (self) {
        [[UIApplication sharedApplication].delegate.window addSubview:self];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        [self addGestureRecognizer:tapGes];
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(77, 200, SCREENWIDTH-150, 160)];
        self.backgroundView.backgroundColor = UICOLOR(@"#343338");
        self.backgroundView.layer.cornerRadius = 7;
        self.backgroundView.clipsToBounds = YES;
        [self addSubview:self.backgroundView];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 200, 20)];
        lab.text = @"deviceToken";
        lab.textColor = [UIColor whiteColor];
        [self.backgroundView addSubview:lab];

        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 50, SCREENWIDTH-180, 90)];
        textView.font = [UIFont systemFontOfSize:14];
        textView.backgroundColor = [UIColor whiteColor];
        textView.text = deviceToken;
        [self.backgroundView addSubview:textView];
    }
    return self;
}

+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message
                        ok:(NSString *)ok
                    cancel:(NSString *)cancel
                   okBlock:(void(^)(void))okBlock
                   cancelBlock:(void(^)(void))cancelBlock

{
    if (!alertView.superview) {
        alertView = [self sharedInstance];
        alertView.canRemove = YES;
        alertView.okBlock = okBlock;
        alertView.cancelBlock = cancelBlock;
        [[UIApplication sharedApplication].delegate.window addSubview:alertView];
        alertView.frame = [UIScreen mainScreen].bounds;
        alertView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:alertView action:@selector(tapGesRemove)];
        [alertView addGestureRecognizer:tapGes];
        
        alertView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        alertView.backgroundView.backgroundColor = UICOLOR(@"#343338");
        
        alertView.backgroundView.layer.cornerRadius = 7;
        alertView.backgroundView.clipsToBounds = YES;
        [alertView addSubview:alertView.backgroundView];
        
        alertView.titleL = [[EdgeInsetsLabel alloc] initWithFrame:CGRectZero];
        alertView.titleL.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);  //top,left,bottom,right 设置左内边距
        alertView.titleL.font = PingFangSC_Regular(12);
        alertView.titleL.textColor = UICOLOR(@"#FFFFFF");
        alertView.titleL.text = title;
        alertView.titleL.textAlignment = NSTextAlignmentCenter;
        alertView.titleL.numberOfLines = 0;
        [alertView.titleL sizeToFit];
        [alertView.backgroundView addSubview:alertView.titleL];
        
        alertView.messageL = [[EdgeInsetsLabel alloc] initWithFrame:CGRectZero];
        alertView.messageL.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);  //top,left,bottom,right 设置左内边距
        alertView.messageL.font = PingFangSC_Regular(12);
        alertView.messageL.textColor = UICOLOR(@"#FFFFFF");
        alertView.messageL.text = message;
        alertView.messageL.textAlignment = NSTextAlignmentCenter;
        alertView.messageL.numberOfLines = 0;
        [alertView.messageL sizeToFit];
        [alertView.backgroundView addSubview:alertView.messageL];
        
        if (cancel.length) {
            alertView.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            alertView.cancelButton.frame = CGRectZero;
            [alertView.cancelButton setTitle:cancel forState:UIControlStateNormal];
            alertView.cancelButton.titleLabel.font = PingFangSC_Regular(12);
            [alertView.cancelButton setTitleColor:UICOLOR(@"#FFFFFF") forState:UIControlStateNormal];
            [alertView.cancelButton addTarget:alertView action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
            [alertView.backgroundView addSubview:alertView.cancelButton];
        }
        
        alertView.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        alertView.okButton.frame = CGRectZero;
        [alertView.okButton setTitle:ok forState:UIControlStateNormal];
        alertView.okButton.titleLabel.font = PingFangSC_Regular(12);
        [alertView.okButton setTitleColor:UICOLOR(@"#FFFFFF") forState:UIControlStateNormal];
        [alertView.okButton addTarget:alertView action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
        [alertView.backgroundView addSubview:alertView.okButton];
        
        //            [self layoutIfNeeded];
        [alertView layout];
    }
    
}

-(instancetype)init:(NSString *)title message:(NSString *)message
                                           ok:(NSString *)ok
                                       cancel:(NSString *)cancel {
    self = [super init];
        if (self) {
            [[UIApplication sharedApplication].delegate.window addSubview:self];
            self.frame = [UIScreen mainScreen].bounds;
            self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
            
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesRemove)];
            [self addGestureRecognizer:tapGes];
            
            self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            self.backgroundView.backgroundColor = UICOLOR(@"#343338");

            self.backgroundView.layer.cornerRadius = 7;
            self.backgroundView.clipsToBounds = YES;
            [self addSubview:self.backgroundView];
            
            self.titleL = [[EdgeInsetsLabel alloc] initWithFrame:CGRectZero];
            self.titleL.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);  //top,left,bottom,right 设置左内边距
            self.titleL.font = PingFangSC_Regular(12);
            self.titleL.textColor = UICOLOR(@"#FFFFFF");
            self.titleL.text = title;
            self.titleL.textAlignment = NSTextAlignmentCenter;
            self.titleL.numberOfLines = 0;
            [self.titleL sizeToFit];
            [self.backgroundView addSubview:self.titleL];

            self.messageL = [[EdgeInsetsLabel alloc] initWithFrame:CGRectZero];
            self.messageL.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);  //top,left,bottom,right 设置左内边距
            self.messageL.font = PingFangSC_Regular(12);
            self.messageL.textColor = UICOLOR(@"#FFFFFF");
            self.messageL.text = message;
            self.messageL.textAlignment = NSTextAlignmentCenter;
            self.messageL.numberOfLines = 0;
            [self.messageL sizeToFit];
            [self.backgroundView addSubview:self.messageL];

            if (cancel.length) {
                self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.cancelButton.frame = CGRectZero;
                [self.cancelButton setTitle:cancel forState:UIControlStateNormal];
                self.cancelButton.titleLabel.font = PingFangSC_Regular(12);
                [self.cancelButton setTitleColor:UICOLOR(@"#FFFFFF") forState:UIControlStateNormal];
                [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
                [self.backgroundView addSubview:self.cancelButton];
            }
            
            self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.okButton.frame = CGRectZero;
            [self.okButton setTitle:ok forState:UIControlStateNormal];
            self.okButton.titleLabel.font = PingFangSC_Regular(12);
            [self.okButton setTitleColor:UICOLOR(@"#FFFFFF") forState:UIControlStateNormal];
            [self.okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
            [self.backgroundView addSubview:self.okButton];
            
//            [self layoutIfNeeded];
            [self layout];
        }
        return self;
    
}



//- (void)layoutSubviews {
//    [super layoutSubviews];
////    [self layout];
//}

- (void)layout {
    CGFloat height = [self getStringHeightWithText:self.titleL.text font:[UIFont systemFontOfSize:10] viewWidth:SCREENWIDTH-180];

    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backgroundView).offset = 20;
        make.centerX.mas_equalTo(self.backgroundView.mas_centerX);
        make.height.offset = 12;
    }];
    
    [self.messageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backgroundView).offset = 48;
//        make.centerX.mas_equalTo(self.backgroundView.mas_centerX);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.offset = height+80;
    }];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(77.5);
        make.right.mas_equalTo(-77.5);
        make.height.mas_greaterThanOrEqualTo(168+height);
    }];
    
    if (self.cancelButton) {
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -50;
            make.width.offset = 44;
            make.height.offset = 24;
            make.bottom.offset = -12.5;
        }];
        [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 50;
            make.width.offset = 44;
            make.height.offset = 24;
            make.bottom.offset = -12.5;
        }];
    }else{
        [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.right.offset = -15;
            make.height.offset = 24;
            make.bottom.offset = -12.5;
        }];
    }


    

}
- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;

   // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}
-(void)cancelAction{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self remove];
}

-(void)okAction{
    if (self.okBlock) {
        self.okBlock();
    }
    if (self.canRemove) {
        [self remove];
    }
}
- (void)tapGesRemove{
    if (self.canRemove) {
        [self remove];
    }
}
-(void)remove {
    [self removeFromSuperview];
}



@end
