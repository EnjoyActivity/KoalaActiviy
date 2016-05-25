//
//  ChooseTeamView.m
//  ledong
//
//  Created by dengjc on 16/5/25.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ChooseTeamView.h"

@implementation ChooseTeamView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    self.chooseTeamLabel.textColor = RGB(51, 51, 51, 1);
    self.numLabel.textColor = RGB(153, 153, 153, 1);
    UILabel *sepLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, APP_WIDTH, 0.5)];
    sepLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:sepLabel];
    _stepperView = [[StepperView alloc]initWithFrame:CGRectMake(APP_WIDTH - 90, _numLabel.frame.origin.y, 70, 30)];
    _stepperView.center = CGPointMake(APP_WIDTH - 55, _numLabel.center.y);
    [self addSubview:_stepperView];
}

@end
