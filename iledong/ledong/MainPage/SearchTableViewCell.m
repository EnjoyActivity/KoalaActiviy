//
//  SearchTableViewCell.m
//  ledong
//
//  Created by luojiao  on 16/3/28.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "FRUtils.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.image = [FRUtils resizeImageWithImageName:@"img_avatar_100"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
