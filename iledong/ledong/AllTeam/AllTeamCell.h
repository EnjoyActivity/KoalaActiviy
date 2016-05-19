//
//  AllTeamCell.h
//  ledong
//
//  Created by dongguoju on 16/3/2.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllTeamCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *personCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionCountLabel;

@end
