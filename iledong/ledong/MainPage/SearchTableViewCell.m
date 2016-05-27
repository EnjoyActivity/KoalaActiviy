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

- (void)updateName:(NSString *)name
             detail:(NSString *)detail
              price:(NSString *)price {
    self.activityDetail.text = detail;
    
    if (self.keyWord) {
        NSRange keyRange = [name rangeOfString:self.keyWord];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:name];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:keyRange];
        self.activityName.attributedText = attr;
    }
    else
    {
          self.activityName.text = name;  
    }
    NSRange yuanRange = [price rangeOfString:@"元"];
    
    NSMutableAttributedString * attrYuan = [[NSMutableAttributedString alloc] initWithString:price];
    [attrYuan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:yuanRange];
    self.activityPrice.attributedText = attrYuan;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
