//
//  TitleView.m
//  ledong
//
//  Created by dengjc on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    self.activeTitleLabel.textColor = RGB(51, 51, 51, 1);
    self.activeTimeLabel.textColor = RGB(51, 51, 51, 1);
    self.personLabel.textColor = RGB(153, 153, 153, 1);
    self.teamLabel.textColor = RGB(153, 153, 153, 1);
    self.timeRemainLabel.textColor = RGB(153, 153, 153, 1);
    self.remainPersonLabel.textColor = RGB(153, 153, 153, 1);
    self.remainTeamLabel.textColor = RGB(153, 153, 153, 1);
}

@end
