//
//  TeamsCell.h
//  ledong
//
//  Created by luojiao  on 16/3/22.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *teamImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UILabel *teamNum;
@property (weak, nonatomic) IBOutlet UILabel *teamAdress;
@property (weak, nonatomic) IBOutlet UILabel *attentionNum;
@property (weak, nonatomic) IBOutlet UILabel *header;

@end
