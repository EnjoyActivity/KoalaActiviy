//
//  ChooseForm.m
//  ledong
//
//  Created by dengjc on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ChooseForm.h"



@implementation ChooseForm

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    self.inPersonLabel.textColor = RGB(51, 51, 51, 1);
    self.moneyPerPeronLabel.textColor = RGB(227, 26, 26, 1);
    self.inTeamLabel.textColor = RGB(51, 51, 51, 1);
    self.moneyPerTeamLabel.textColor = RGB(227, 26, 26, 1);
    
    self.chooseFormBtn.backgroundColor = [UIColor whiteColor];
    [self.chooseFormBtn setTitleColor:RGB(227, 26, 26, 1) forState:UIControlStateNormal];
    
    self.signUpBtn.backgroundColor = RGB(227, 26, 26, 1);
    [self.signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (IBAction)cancelBtnClick:(id)sender {
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}
- (IBAction)okBtnClick:(id)sender {
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}

@end
