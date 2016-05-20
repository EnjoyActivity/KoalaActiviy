//
//  LDMainSearchTableViewCell.h
//  ledong
//
//  Created by 郑红 on 5/20/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDMainSearchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *activityImage;
@property (strong, nonatomic) IBOutlet UILabel *activityName;
@property (strong, nonatomic) IBOutlet UILabel *activityDetail;

@property (strong, nonatomic) IBOutlet UILabel *activityPrice;

@end
