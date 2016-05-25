//
//  ChooseTeamView.h
//  ledong
//
//  Created by dengjc on 16/5/25.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepperView.h"

@interface ChooseTeamView : UIView
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *chooseTeamLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) StepperView *stepperView;

@end
