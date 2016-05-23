//
//  MemberView.m
//  ledong
//
//  Created by dengjc on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "MemberView.h"

@implementation MemberView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    self.backgroundColor = RGB(242, 243, 244, 1);
    self.signUpLabel.textColor = RGB(153, 153, 153, 1);
}
@end
