//
//  LDTeamTableViewCell.h
//  ledong
//
//  Created by 郑红 on 5/20/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDTeamTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *teamImageView;
@property (strong, nonatomic) IBOutlet UILabel *teamName;
@property (strong, nonatomic) IBOutlet UILabel *teamMember;
@property (strong, nonatomic) IBOutlet UILabel *teamActivity;
@property (strong, nonatomic) IBOutlet UILabel *teamFocus;

@end
