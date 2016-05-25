//
//  ContactInfoView.m
//  ledong
//
//  Created by dengjc on 16/5/25.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ContactInfoView.h"

@implementation ContactInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    self.tipLabel.textColor = RGB(51, 51, 51, 1);
    self.tipLabel.backgroundColor = RGB(242, 243, 244, 1);

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_tipLabel.text];
    
    //设置字体颜色
    [text addAttribute:NSForegroundColorAttributeName value:RGB(51, 51, 51, 1) range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, text.length)];
    //设置缩进、行距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 20;//缩进
    style.firstLineHeadIndent = 20;
    //    style.lineSpacing = 10;//行距
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    _tipLabel.attributedText = text;

    UILabel *sepLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 86, APP_WIDTH, 0.5)];
    sepLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:sepLabel];
    
    self.nameLabel.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.nameLabel.leftViewMode = UITextFieldViewModeAlways;
    self.phoneLabel.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.phoneLabel.leftViewMode = UITextFieldViewModeAlways;

}
@end
