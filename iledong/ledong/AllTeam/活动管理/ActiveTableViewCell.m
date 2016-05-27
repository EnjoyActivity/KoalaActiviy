//
//  ActiveTableViewCell.m
//  ledong
//
//  Created by luojiao  on 16/4/8.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "ActiveTableViewCell.h"

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
    CGFloat x = self.activityImageView.frame.origin.x + self.activityImageView.frame.size.width + 10;
    self.activityName.frame = CGRectMake(x, 12, self.activityName.frame.size.width, self.activityName.frame.size.height);
    self.activityDesc.frame = CGRectMake(x, self.activityName.frame.origin.y+self.activityName.frame.size.height+5, self.activityDesc.frame.size.width, self.activityDesc.frame.size.height);
    self.activityState.frame = CGRectMake(x, self.activityDesc.frame.origin.y+self.activityDesc.frame.size.height+10, self.activityState.frame.size.width, self.activityState.frame.size.height);
    
    self.mgrBtn.hidden = YES;
    self.lineLabel.hidden = YES;
    //if (self.state == activityStateOnGoing) {
        //self.lineLabel.hidden = NO;
        //self.mgrBtn.hidden = NO;
        
        self.lineLabel.frame = CGRectMake(15, self.activityImageView.frame.origin.y+self.activityImageView.frame.size.height+10, APP_WIDTH-15, 0.5);
        self.mgrBtn.frame = CGRectMake(APP_WIDTH-15-70, self.lineLabel.frame.origin.y+self.lineLabel.frame.size.height+10, 70, self.mgrBtn.frame.size.height);
   // }
   // else {
        
        
   // }
}

- (void)setSelectManagerBtnClicked:(managerBtnClickedBlock)block {
    self.block = block;
}

- (void)mgrBtnClicked {
    if (self.block) 
        self.block();
}

@end
