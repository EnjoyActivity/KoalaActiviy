//
//  TeamTableViewCell.h
//  ledong
//
//  Created by luojiao  on 16/4/20.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;

@property (strong, nonatomic) IBOutlet UILabel *teamName;
@property (strong, nonatomic) IBOutlet UILabel *teamMember;

@end
