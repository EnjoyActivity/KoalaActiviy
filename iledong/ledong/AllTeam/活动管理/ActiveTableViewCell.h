//
//  ActiveTableViewCell.h
//  ledong
//
//  Created by luojiao  on 16/4/8.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum activityState {
    activityStateOnGoing = 0,
    activityStateEnd
}activityState;

typedef void (^managerBtnClickedBlock)();

@interface ActiveTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UILabel *activityDesc;
@property (weak, nonatomic) IBOutlet UILabel *activityState;
@property (assign, nonatomic)BOOL isManager;

@property (assign, nonatomic)activityState state;
- (void)setSelectManagerBtnClicked:(managerBtnClickedBlock)block;

@end
