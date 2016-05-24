//
//  ActivityMessageTableViewCell.m
//  ledong
//
//  Created by TDD on 16/3/2.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "ActivityMessageTableViewCell.h"

@implementation ActivityMessageTableViewCell

- (void)awakeFromNib {
    self.activeTitleLabel.textColor = RGB(51, 51, 51, 1);
    self.joinFormLabel.textColor = RGB(153, 153, 153, 1);
    self.payLabel.textColor = RGB(227, 26, 26, 1);
    self.moneyLabel.textColor = RGB(51, 51, 51, 1);
    
    [self.cancelBtn setBackgroundImage:[FRUtils resizeImageWithImage:[UIImage imageNamed:@"btn_redline"]] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
