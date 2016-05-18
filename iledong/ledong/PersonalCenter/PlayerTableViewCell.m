//
//  PlayerTableViewCell.m
//  ledong
//
//  Created by TDD on 16/3/2.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "PlayerTableViewCell.h"
#import "FRUtils.h"

@implementation PlayerTableViewCell

- (void)awakeFromNib {
    self.headerImage.image = [FRUtils circleImage:[UIImage imageNamed:@"user02_44"] withParam:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
