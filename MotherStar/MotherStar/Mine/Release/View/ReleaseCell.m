//
//  ReleaseCell.m
//  MotherStar
//
//  Created by 王文杰 on 2020/1/12.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "ReleaseCell.h"
#import "ReleaseModel.h"
@interface ReleaseCell ()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *studyBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiuldBtn;

@end

@implementation ReleaseCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ReleaseModel *)model{
    _model = model;
//    self.lab.text =  [NSString stringWithFormat:@"%@%@", model.hotPost.title,model.hotPost.content];
//    NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[model.post.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];

//    self.lab.attributedText = [self setAttributedString:model.post.content];
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    NSString * content =[[dic valueForKey:@"hotPost"]valueForKey:@"content"];
    NSString * title =[[dic valueForKey:@"hotPost"]valueForKey:@"title"];
//
    self.lab.text = [NSString stringWithFormat:@"%@%@", title,content];
    self.titleLab.text = [[dic valueForKey:@"hotPost"]valueForKey:@"nickName"];
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString: [[dic valueForKey:@"hotPost"]valueForKey:@"headImage"]]];
    NSString *starTag =[NSString stringWithFormat:@" %@" ,[[dic valueForKey:@"hotPost"]valueForKey:@"starTag"]];
    NSString *likeNum = [NSString stringWithFormat:@" %@"  ,[[dic valueForKey:@"hotPost"]valueForKey:@"likeNum"]];
    [self.likeBtn setTitle:likeNum forState:UIControlStateNormal];
    [self.studyBtn setTitle:starTag forState:UIControlStateNormal];
    
    NSString *shareNum =[NSString stringWithFormat:@" %@" ,[[dic valueForKey:@"hotPost"]valueForKey:@"shareNum"]];
    [self.shareBtn setTitle:shareNum forState:UIControlStateNormal];

    self.fiuldBtn.layer.borderColor = [UIColor colorWithHex:@"FF861A"].CGColor;
    
    NSString *oilNum =[NSString stringWithFormat:@" %@" ,[[dic valueForKey:@"hotPost"]valueForKey:@"oilNum"]];
//
    [self.fiuldBtn setTitle:oilNum forState:UIControlStateNormal];
//    NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//    self.lab.attributedText = attStr;

}


+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font { CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
    
}

//-(NSMutableAttributedString *)setAttributedString:(NSString *)str
//{
////如果有换行，把\n替换成<br/>
////如果有需要把换行加上
// str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
////设置HTML图片的宽度
// str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",[UIScreen mainScreen].bounds.size.width,str];
// NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
////设置富文本字的大小
// [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, htmlString.length)];
////设置行间距
// NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:5];
// [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [htmlString length])];
//
//    return htmlString;
//}
+ (ReleaseCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"ReleaseCell";
    ReleaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return cell;
}

@end
