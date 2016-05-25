//
//  TeamsCell.h
//  ledong
//
//  Created by luojiao  on 16/3/22.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamsCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *teamImageView;
@property (strong, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamMemberLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamAreaLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamAttentionLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamCaptainLabel;
@property (strong, nonatomic) IBOutlet UIImageView *teamCaptainImage;

@end
