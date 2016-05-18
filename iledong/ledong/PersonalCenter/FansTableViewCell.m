//
//  FansTableViewCell.m
//  ledong
//
//  Created by luojiao  on 16/4/27.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "FansTableViewCell.h"
#import "FRUtils.h"


@implementation FansTableViewCell

- (void)awakeFromNib {
    self.headerImage.image = [FRUtils circleImage:[UIImage imageNamed:@"user02_44"] withParam:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
