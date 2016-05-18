//
//  HotCollectionViewCell.m
//  ledong
//
//  Created by luojiao  on 16/4/19.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "HotCollectionViewCell.h"
#import "FRUtils.h"

@implementation HotCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.bgImage.image = [FRUtils resizeImageWithImageName:@"btn_white"];
}

@end
