//
//  LocationView.m
//  ledong
//
//  Created by dengjc on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "LocationView.h"

@implementation LocationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    self.locationLabel.textColor = RGB(51, 51, 51, 1);
    self.detailLocationLabel.textColor = RGB(153, 153, 153, 1);
    self.distanceLabel.textColor = RGB(153, 153, 153, 1);
}
@end
