//
//  SearchTableViewCell.h
//  ledong
//
//  Created by luojiao  on 16/3/28.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *resultHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *resultName;
@property (weak, nonatomic) IBOutlet UILabel *resultAddress;
@property (weak, nonatomic) IBOutlet UILabel *resultPrice;
@property (weak, nonatomic) IBOutlet UILabel *contentName;

@end
