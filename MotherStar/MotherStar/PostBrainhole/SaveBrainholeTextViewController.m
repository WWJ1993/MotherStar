//
//  SaveBrainholeTextViewController.m
//  MotherStar
//
//  Created by yanming niu on 2019/12/14.
//  Copyright © 2019 yanming niu. All rights reserved.
//

#import "SaveBrainholeTextViewController.h"
#import "PhotoAlbumTools.h"
#import "RequestHandle.h"

@interface SaveBrainholeTextViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat cursorPosition;
@property (nonatomic, strong) UIBarButtonItem *saveButton;





@end

@implementation SaveBrainholeTextViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];

    //提示保存内容
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.textView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.gk_navRightBarButtonItem = self.saveButton;
    
    self.textView.keyboardType = UIKeyboardTypeDefault;
    
    [self initTextView];  //脑洞编辑器
    
    
//    [self setupTextView];

}

- (UIBarButtonItem *)saveButton {
    if (!_saveButton) {
        UIButton *save = [UIButton new];
        save.frame = CGRectMake(0, 0, 36, 18);
        save.titleLabel.font = PingFangSC_Medium(18);
        [save setTitle:@"保存" forState:UIControlStateNormal];
        [save setTitleColor:UICOLOR(@"#343338") forState:UIControlStateNormal];
        [save addTarget:self action:@selector(saveBrainholeText) forControlEvents:UIControlEventTouchUpInside];
        _saveButton = [[UIBarButtonItem alloc] initWithCustomView:save];
    }
    return _saveButton;
}

- (void)initTextView {
    CGRect rect = CGRectMake(10, 64, [UIScreen mainScreen].bounds.size.width - 20, 300);
    _textView = [[UITextView alloc] initWithFrame:rect];
    _textView.delegate = (id)self;
//    _textView.layer.borderWidth = 1;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.showsVerticalScrollIndicator = NO;
    //文字设置居右、placeHolder会跟随设置
    //    textView.textAlignment = NSTextAlignmentRight;
    _textView.zw_placeHolder = @"写出你的脑洞~";
    _textView.zw_limitCount = 300;  //不包含图片，图片占一个字符的位置
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _textView.zw_placeHolderColor = [UIColor redColor];
    
    [self.view addSubview:_textView];
    
    UIButton *addPhoto = [[UIButton alloc] init];
    [addPhoto setImage:[UIImage imageNamed:@"brainhole_addPhoto"] forState:UIControlStateNormal];
    addPhoto.frame = CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y + _textView.frame.size.height  + 5,50,25);
    [addPhoto addTarget:self action:@selector(selectFromPhotoAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPhoto];
    
}

- (void)selectFromPhotoAlbum {
    if ([self checkTextviewContainsAttachment]) {
        //提示只能插入一张图片
        
        return;
    }
    NSString *type = @"photo";
    [[[PhotoAlbumTools alloc] init] openPhotoAlbum:YES mediaType:type callback:^(id  _Nonnull data) {
        self.image = data;
        [self insertPhoto];
    }];
}

- (BOOL)checkTextviewContainsAttachment {
    BOOL has = [self.textView.attributedText containsAttachmentsInRange:NSMakeRange(0, self.textView.attributedText.length)];
    return has;

//查找图片在文本的位置
//    [self.textView.attributedText enumerateAttribute:(NSString *) NSFontAttributeName
//       inRange:NSMakeRange(0, self.textView.attributedText.length)
//       options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
//    usingBlock:^(id value, NSRange range, BOOL *stop) {
//        NSLog(@"Attribute: %@, %@", value, NSStringFromRange(range));
//       }];
    
}

- (void)insertPhoto {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
//    NSAttributedString *subText = [[NSAttributedString alloc] initWithString:@"\r\n"];
//    [text appendAttributedString:subText];  //另起一行插入图片
//    _textView.attributedText = text;

    NSTextAttachment *attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    attach.image = self.image;
    attach.bounds = CGRectMake(0, 0, 115, 65);
    
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    
//    [text insertAttributedString:attachString atIndex:_textView.text.length]; //插入图片

    
    [text insertAttributedString:attachString atIndex:_textView.selectedRange.location];  //插入光标处
    _textView.attributedText = text;
    

    
//    _textView.selectedRange = NSMakeRange(self.cursorPosition, 0);
    
}

//- (UIBezierPath *)translatedBezierPath {
//    CGRect imageRect = [textView convertRect:imageView.frame fromView:self.view];
//    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(imageRect.origin.x+5, imageRect.origin.y, imageRect.size.width-5, imageRect.size.height-5)];
//    return bezierPath;
//}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    

}

//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    [self performSelector:@selector(textViewDidChange:) withObject:textView afterDelay:0.1f];
//}
 
//- (void)textViewDidChange:(UITextView *)textView {
//    if (textView.selectedTextRange) {
//        self.cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin.y;
//    } else {
//        self.cursorPosition = 0;
//    }
//    CGRect cursorRowFrame = CGRectMake(0, cursorPosition, kScreenWidth, kMinTextViewHeight);
//    textView.selectedRange = NSMakeRange(self.cursorPosition, 0);
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}




@end
