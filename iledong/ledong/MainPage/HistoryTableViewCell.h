//
//  HistoryTableViewCell.h
//  ledong
//
//  Created by luojiao  on 16/4/19.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentName;
@property (weak, nonatomic) IBOutlet UILabel *resultName;
@property (weak, nonatomic) IBOutlet UILabel *resultNum;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;

@end
