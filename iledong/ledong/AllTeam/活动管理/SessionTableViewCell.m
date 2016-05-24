//
//  SessionTableViewCell.m
//  ledong
//
//  Created by dengjc on 16/5/24.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "SessionTableViewCell.h"

@implementation SessionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.placeNameLabel.textColor = RGB(51, 51, 51, 1);
    self.addressLabel.textColor = RGB(153, 153, 153, 1);
    self.distanceLabel.textColor = RGB(153, 153, 153, 1);
    self.beginTimeLabel.textColor = RGB(51, 51, 51, 1);
    self.endTimeLabel.textColor = RGB(153, 153, 153, 1);
    self.remainNumLabel.textColor = RGB(153, 153, 153, 1);
    self.constitutorNameLabel.textColor = RGB(153, 153, 153, 1);
    self.moneyLabel.textColor = RGB(227, 26, 26, 1);
    self.moneyUnitLabel.textColor = RGB(227, 26, 26, 1);
    self.spaceLabel.backgroundColor = RGB(242, 243, 244, 1);
//    self.sepLabel.backgroundColor = RGB(235, 235, 235, 1);
    
    UILabel *sepLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 54, APP_WIDTH - 20, 0.5)];
    sepLabel.backgroundColor = [UIColor lightGrayColor];//RGB(235, 235, 235, 1);
    [self addSubview:sepLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
