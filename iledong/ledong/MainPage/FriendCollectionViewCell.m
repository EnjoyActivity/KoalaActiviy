//
//  FriendCollectionViewCell.m
//  ledong
//
//  Created by luojiao  on 16/4/20.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "FriendCollectionViewCell.h"

@implementation FriendCollectionViewCell

- (void)awakeFromNib
{
    self.btnImage.image = [FRUtils resizeImageWithImageName:@"btn_white"];
}

@end
