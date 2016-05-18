//
//  TeamCollectionViewCell.m
//  ledong
//
//  Created by luojiao  on 16/4/20.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "TeamCollectionViewCell.h"

@implementation TeamCollectionViewCell

- (void)awakeFromNib {
    self.image.image = [FRUtils resizeImageWithImageName:@"btn_white"];
}

@end
