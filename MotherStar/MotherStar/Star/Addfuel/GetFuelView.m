//
//  GetFuelView.m
//  MotherStar
//  加油
//  Created by yanming niu on 2020/1/20.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "GetFuelView.h"
#import "OilingViewController.h"


@interface GetFuelView () <UIGestureRecognizerDelegate> {
    UILabel *title;
    UIView *fuelView;
    UIButton *minusButton;
    UIButton *plusButton;
    UILabel *fuelValueL;
    UILabel *currentFuelValueL;
    UIButton *getFuelButton;
    UILabel *myFuelValue;
    UIButton *getMoreFuelButton;
    UIButton *closeButton;
    
    UIView *getFuelArea;
    
    NSInteger fuel;  //已加燃料
    NSInteger myFuelNum;  //用户获得的燃料

}

@end

@implementation GetFuelView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        getFuelArea = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240)];
        [self addSubview:getFuelArea];
        getFuelArea.backgroundColor = UICOLOR(@"#FFFFFF");
        
        UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];

        title = [[UILabel alloc] init];
        [getFuelArea addSubview:title];

        title.text = @"为Ta加油";
        title.font = PingFangSC_Medium(14);
        
        fuelView = [[UIView alloc] initWithFrame:CGRectZero];
        [getFuelArea addSubview:fuelView];
        
        fuelView.layer.cornerRadius = 4;
        fuelView.clipsToBounds = YES;

        fuelView.layer.borderWidth = 1;
        fuelView.layer.borderColor = [UICOLOR(@"#868686") CGColor];

        minusButton = [[UIButton alloc] init];
        [fuelView addSubview:minusButton];
        
        minusButton.tag = 10;
        minusButton.layer.borderWidth = 1;
        minusButton.layer.borderColor = [UICOLOR(@"#868686") CGColor];
        [minusButton setTitle:@"-" forState:UIControlStateNormal];
        [minusButton setTitleColor:UICOLOR(@"#868686") forState:UIControlStateNormal];
        [minusButton addTarget:self action:@selector(fuelAction:) forControlEvents:UIControlEventTouchUpInside];

        
        plusButton = [[UIButton alloc] init];
        [fuelView addSubview:plusButton];
        
        plusButton.tag = 11;
        plusButton.layer.borderWidth = 1;
        plusButton.layer.borderColor = [UICOLOR(@"#868686") CGColor];
        [plusButton setTitle:@"+" forState:UIControlStateNormal];
        [plusButton setTitleColor:UICOLOR(@"#868686") forState:UIControlStateNormal];
        [plusButton addTarget:self action:@selector(fuelAction:) forControlEvents:UIControlEventTouchUpInside];

        fuelValueL = [[UILabel alloc] init];
        [fuelView addSubview:fuelValueL];
        fuelValueL.textAlignment = NSTextAlignmentCenter;
        fuelValueL.font = PingFangSC_Regular(12);
        fuelValueL.text = @"5";  //default
        
        currentFuelValueL = [[UILabel alloc] init];
        [getFuelArea addSubview:currentFuelValueL];
        
        fuel = 5;  //默认燃料值 5
        currentFuelValueL.font = PingFangSC_Regular(10);
        currentFuelValueL.textColor = UICOLOR(@"#868686");
        currentFuelValueL.text = [NSString stringWithFormat:@"当前已加 %li L", (long)fuel];
        
        getFuelButton = [[UIButton alloc] init];
        [getFuelArea addSubview:getFuelButton];
        
        [getFuelButton setTitle:@"加油" forState:UIControlStateNormal];
        [getFuelButton setTitleColor:UICOLOR(@"#343338") forState:UIControlStateNormal];
        
        getFuelButton.backgroundColor = UICOLOR(@"#EFB400");
        getFuelButton.titleLabel.font = PingFangSC_Regular(14);
        [getFuelButton addTarget:self action:@selector(getFuelAction) forControlEvents:UIControlEventTouchUpInside];
        
        myFuelValue = [[UILabel alloc] init];
        [getFuelArea addSubview:myFuelValue];
        
        NSInteger myFuel = 0;
        myFuelValue.text = [NSString stringWithFormat:@"我的燃料： %li L", (long)myFuel];
        myFuelValue.font = PingFangSC_Regular(14);

        getMoreFuelButton = [[UIButton alloc] init];
        [getFuelArea addSubview:getMoreFuelButton];
        
        getMoreFuelButton.titleLabel.font = PingFangSC_Regular(10);
        [getMoreFuelButton setTitle:@"获取更多" forState:UIControlStateNormal];
        [getMoreFuelButton setTitleColor:UICOLOR(@"#6692EE") forState:UIControlStateNormal];
        [getMoreFuelButton addTarget:self action:@selector(getMoreFuelAction) forControlEvents:UIControlEventTouchUpInside];
        
        closeButton = [[UIButton alloc] init];
        [getFuelArea addSubview:closeButton];
        
        [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        

    }
    return self;
}

- (void)hiddenView {
    [self removeFromSuperview];
}

- (void)showAction {
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
         [UIView animateWithDuration:0.3 animations:^{
             self->getFuelArea.frame = CGRectMake(0, 0, SCREENWIDTH, 240);
    }];
}

- (void)closeAction {
    [UIView animateWithDuration:0.3 animations:^{
      self->getFuelArea.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/* 加油 + - */
- (void)fuelAction:(UIButton *)sender {
    if (sender.tag == 10) {
        if (fuel >= 5 ) {
            [self updateView:NO];
            fuel = fuel - 5;
        }
    } else {
        if (myFuelNum <= fuel) {
            [self updateView:YES];
            [SVProgressHUD showErrorWithStatus:@"燃料不足"];
            [SVProgressHUD dismissWithDelay:1.2 completion:^{
                [self updateView:NO];
            }];
            return;
        }
       fuel = fuel + 5;
    }
    fuelValueL.text = [NSString stringWithFormat:@"%li",(long)fuel];
    currentFuelValueL.text = [NSString stringWithFormat:@"当前已加 %li L", (long)fuel];
}

/* 燃料补足提示 */
- (void)updateView:(BOOL)is {
    if (is) {
        fuelView.layer.borderColor = [UICOLOR(@"#FF2518") CGColor];
        minusButton.layer.borderColor = [UICOLOR(@"#FF2518") CGColor];
        plusButton.layer.borderColor = [UICOLOR(@"#FF2518") CGColor];
        fuelValueL.textColor = UICOLOR(@"#FF2518");
    } else {
        fuelView.layer.borderColor = [UICOLOR(@"#868686") CGColor];
        minusButton.layer.borderColor = [UICOLOR(@"#868686") CGColor];
        plusButton.layer.borderColor = [UICOLOR(@"#868686") CGColor];
        fuelValueL.textColor = UICOLOR(@"#868686");
    }
}

/* 加油接口 */
- (void)getFuelAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addFuelActionNotification" object:@(fuel)];
}

/* 加油站 */
- (void)getMoreFuelAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterAddFuelViewNotification" object:@(fuel)];
}

/* 我的燃料 */
- (void)setMyFuel:(NSInteger)myFuel {
    myFuelValue.text = [NSString stringWithFormat:@"我的燃料： %li L", (long)myFuel];
    myFuelNum = myFuel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [getFuelArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(SCREENHEIGHT - 240);
        make.width.mas_equalTo(SCREENWIDTH);
        make.bottom.mas_offset(20);
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(30);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(60.5);
        make.height.mas_equalTo(14);
    }];
    
    [fuelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).mas_offset(10);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
    
    [minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(0);
        make.width.height.mas_equalTo(30);
    }];
    
    [plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.mas_offset(0);
        make.width.height.mas_equalTo(30);
    }];
    
    [fuelValueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(minusButton.mas_right).mas_offset(0);
        make.right.equalTo(plusButton.mas_left).mas_offset(0);
        make.height.mas_equalTo(30);
    }];
    
    [currentFuelValueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fuelView.mas_bottom).mas_offset(8);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    [getFuelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(currentFuelValueL.mas_bottom).mas_offset(14);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(89);
        make.height.mas_equalTo(25);
    }];
    
    [myFuelValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getFuelButton.mas_bottom).mas_offset(20);
        make.left.mas_offset(107.5);
        make.height.mas_equalTo(14);
        //宽度自适应
    }];
    
    [getMoreFuelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getFuelButton.mas_bottom).mas_offset(22);
        make.left.equalTo(myFuelValue.mas_right).mas_offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(10);
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getMoreFuelButton.mas_bottom).mas_offset(22);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(22);
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:getFuelArea]) {
        return NO;
    }
    return YES;
}


@end
