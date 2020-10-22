//
//  ReleaseImgCell.m
//  MotherStar
//
//  Created by 王文杰 on 2020/1/13.
//  Copyright © 2020 yanming niu. All rights reserved.
//

#import "ReleaseImgCell.h"
@interface ReleaseImgCell ()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *fiuldBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *studyBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end

@implementation ReleaseImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

//    self.imgV.backgroundColor = [UIColor redColor];
    self.imgV.layer.cornerRadius = 10;
    self.imgV.layer.masksToBounds = YES;
    self.imgV.contentMode = UIViewContentModeScaleAspectFill;
    NSString *imgList =[NSString stringWithFormat:@" %@" ,[[dic valueForKey:@"hotPost"]valueForKey:@"imgList"]];
    [self.imgV sd_setImageWithURL:
     [NSURL URLWithString:imgList]];
}


+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font { CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
    
}


+ (ReleaseImgCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"ReleaseImgCell";
    ReleaseImgCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return cell;
}


@end
