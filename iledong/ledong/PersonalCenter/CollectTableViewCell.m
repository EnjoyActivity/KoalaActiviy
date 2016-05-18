//
//  CollectTableViewCell.m
//  ledong
//
//  Created by luojiao  on 16/4/29.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "CollectTableViewCell.h"
#import "FRUtils.h"


@implementation CollectTableViewCell

- (void)awakeFromNib {
    self.headerImage.image = [FRUtils resizeImageWithImageName:@"hd002_72"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
