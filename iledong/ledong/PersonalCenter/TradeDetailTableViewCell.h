//
//  TradeDetailTableViewCell.h
//  ledong
//
//  Created by dengjc on 16/5/20.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *weekDayLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *tradeCodeLabel;
@end
