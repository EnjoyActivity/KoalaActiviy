//
//  HistoryTableViewCell.h
//  ledong
//
//  Created by luojiao  on 16/4/19.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString * keyWords;

@property (strong, nonatomic) IBOutlet UIImageView *sImageView;
@property (strong, nonatomic) IBOutlet UILabel *sNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sDetailLabel;

- (void)updateName:(NSString *)name detail:(NSString *)detail;

@end
