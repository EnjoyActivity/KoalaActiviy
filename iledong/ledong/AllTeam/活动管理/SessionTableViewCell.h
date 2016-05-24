//
//  SessionTableViewCell.h
//  ledong
//
//  Created by dengjc on 16/5/24.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyUnitLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *constitutorNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *spaceLabel;
//@property (strong, nonatomic) IBOutlet UILabel *sepLabel;

@end
