//
//  ContactView.m
//  ledong
//
//  Created by dengjc on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ContactView.h"

@implementation ContactView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    self.infoLabel.textColor = RGB(153, 153, 153, 1);
    self.reportLabel.textColor = RGB(153, 153, 153, 1);
    self.nameLabel.textColor = RGB(153, 153, 153, 1);
    self.organizeLabel.backgroundColor = RGB(227, 26, 26, 1);
    
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.clipsToBounds = YES;
    self.headImageView.backgroundColor = [UIColor purpleColor];
}

@end
