//
//  ChooseForm.h
//  ledong
//
//  Created by dengjc on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseForm : UIView
@property (strong, nonatomic) IBOutlet UILabel *inPersonLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyPerPeronLabel;
@property (strong, nonatomic) IBOutlet UILabel *inTeamLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyPerTeamLabel;

@property (strong, nonatomic) IBOutlet UIButton *inPersonBtn;
@property (strong, nonatomic) IBOutlet UIButton *inTeamBtn;
@property (strong, nonatomic) IBOutlet UIButton *chooseFormBtn;
@property (strong, nonatomic) IBOutlet UIButton *signUpBtn;
@property (strong, nonatomic) IBOutlet UIView *toolbar;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *okBtn;

@end
