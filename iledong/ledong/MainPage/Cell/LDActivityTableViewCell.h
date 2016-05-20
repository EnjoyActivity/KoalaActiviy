//
//  LDActivityTableViewCell.h
//  ledong
//
//  Created by 郑红 on 5/19/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDActivityTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *adImageView;
@property (strong, nonatomic) IBOutlet UILabel *activityDetail;
@property (strong, nonatomic) IBOutlet UILabel *activityPrice;
@property (strong, nonatomic) IBOutlet UILabel *activityOwer;
@property (strong, nonatomic) IBOutlet UILabel *activityName;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;

@end
