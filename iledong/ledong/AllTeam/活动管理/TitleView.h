//
//  TitleView.h
//  ledong
//
//  Created by dengjc on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView
@property (strong, nonatomic) IBOutlet UILabel *activeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *activeTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeRemainLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainPersonLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainTeamLabel;
@property (strong, nonatomic) IBOutlet UILabel *personLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamLabel;
@property (strong, nonatomic) IBOutlet UILabel *personMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamMoneyLabel;

@end
