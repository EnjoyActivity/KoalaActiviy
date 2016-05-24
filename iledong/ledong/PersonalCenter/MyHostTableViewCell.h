//
//  MyHostTableViewCell.h
//  ledong
//
//  Created by TDD on 16/3/3.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHostTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *activeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *joinFormLabel;
@property (strong, nonatomic) IBOutlet UIImageView *activeImageView;
@property (strong, nonatomic) IBOutlet UILabel *payLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *okBtn;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

@end
