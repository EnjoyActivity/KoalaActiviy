//
//  SignTitleView.m
//  ledong
//
//  Created by dengjc on 16/5/25.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "SignTitleView.h"

@implementation SignTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    self.activeTitleLabel.textColor = RGB(51, 51, 51, 1);
    self.addressAndTimeLabel.textColor = RGB(153, 153, 153, 1);
    self.signTypeLabel.textColor = RGB(51, 51, 51, 1);
    self.moneyLabel.textColor = RGB(227, 26, 26, 1);
    self.moneyUnitLabel.textColor = RGB(227, 26, 26, 1);
}
@end
