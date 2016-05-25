//
//  SignTitleView.h
//  ledong
//
//  Created by dengjc on 16/5/25.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignTitleView : UIView
@property (strong, nonatomic) IBOutlet UILabel *activeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressAndTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *signTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyUnitLabel;

@end
