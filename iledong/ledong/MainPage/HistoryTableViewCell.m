//
//  HistoryTableViewCell.m
//  ledong
//
//  Created by luojiao  on 16/4/19.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.sImageView.image = [FRUtils circleImage:[UIImage imageNamed:@"img_avatar_100"] withParam:1];
    NSString *lenghtStr = @"皇家贝里斯足球联赛";
    NSMutableAttributedString *Str = [[NSMutableAttributedString alloc] initWithString:lenghtStr];
    NSRange redRange = [lenghtStr rangeOfString:@"足球"];
    [Str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    self.sNameLabel.attributedText = Str;

}

- (void)updateName:(NSString *)name detail:(NSString *)detail {
    self.sDetailLabel.text = detail;
    NSRange keyRange = [name rangeOfString:self.keyWords];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:name];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:keyRange];
    self.sNameLabel.attributedText = attr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
