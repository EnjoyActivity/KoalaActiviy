//
//  LDMainPageTeamTableViewCell.h
//  ledong
//
//  Created by 郑红 on 5/25/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDMainPageTeamTableViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *teamImageView;
@property (strong, nonatomic) IBOutlet UILabel *teamDeatilLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamConcernLabel;
@property (strong, nonatomic) IBOutlet UIImageView *teamCaptainImage;
@property (strong, nonatomic) IBOutlet UILabel *teamCaptain;

@property (strong, nonatomic) IBOutlet UILabel *teamNameLabel;
@end
