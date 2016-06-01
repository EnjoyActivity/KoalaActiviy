//
//  ActiveTableViewCell.m
//  ledong
//
//  Created by luojiao  on 16/4/8.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "ActiveTableViewCell.h"
#import "UIView+CoordinatesView.h"

@interface ActiveTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *mgrBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (copy, nonatomic)managerBtnClickedBlock block;

@end

@implementation ActiveTableViewCell

- (void)awakeFromNib {
    self.mgrBtn.layer.borderColor = UIColorFromRGB(0xE42625).CGColor;
    self.mgrBtn.layer.borderWidth = 1;
    [self.mgrBtn addTarget:self action:@selector(mgrBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    self.activityImageView.frame = CGRectMake(15, 10, 70, 70);
    CGFloat x = self.activityImageView.orighX + self.activityImageView.width + 10;
    self.activityName.frame = CGRectMake(x, 12, self.activityName.width, self.activityName.height);
    self.activityDesc.frame = CGRectMake(x, self.activityName.orighY+self.activityName.height+5, self.activityDesc.width, self.activityDesc.height);
    self.activityState.frame = CGRectMake(x, self.activityDesc.orighY+self.activityDesc.height+10, self.activityState.width, self.activityState.height);
    
    self.mgrBtn.hidden = YES;
    self.lineLabel.hidden = YES;
    self.lineLabel.frame = CGRectMake(15, self.activityImageView.orighY+self.activityImageView.height+10, APP_WIDTH-15, 0.5);
    self.mgrBtn.frame = CGRectMake(APP_WIDTH-15-70, self.lineLabel.orighY+self.lineLabel.height+10, 70, self.mgrBtn.height);
    
    if (self.state == activityStateOnGoing) 
        self.activityState.text = @"进行中";
    else if (self.state == activityStateEnd)
        self.activityState.text = @"已结束";
}

- (void)setSelectManagerBtnClicked:(managerBtnClickedBlock)block {
    self.block = block;
}

- (void)mgrBtnClicked {
    if (self.block) 
        self.block();
}

@end
