//
//  FooterTableViewCell.h
//  ledong
//
//  Created by luojiao  on 16/5/4.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIImageView *leftLineImage;

+ (CGFloat)calculateRowsHight :(NSString *)titleStr :(NSArray *)imageTotal;
- (void)updateUIWithData :(NSString *)titleStr :(NSArray *)imageTotal :(NSInteger)index :(NSInteger)rowsNum;

@end
