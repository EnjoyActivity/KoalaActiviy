//
//  TeamTableViewCell.m
//  ledong
//
//  Created by luojiao  on 16/4/20.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "TeamTableViewCell.h"

@implementation TeamTableViewCell

- (void)awakeFromNib {
    self.headImageView.image = [FRUtils circleImage:[UIImage imageNamed:@"img_avatar_100"] withParam:1];
    NSString *lenghtStr = @"皇家贝里斯足球联赛";
    NSMutableAttributedString *Str = [[NSMutableAttributedString alloc] initWithString:lenghtStr];
    NSRange redRange = [lenghtStr rangeOfString:@"足球"];
    [Str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    self.teamName.attributedText = Str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
