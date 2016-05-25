//
//  ActivityMessageViewController.h
//  ledong
//
//  Created by TDD on 16/3/2.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"

@interface ActivityMessageViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;// 消息列表
@property (strong, nonatomic) IBOutlet UIButton *myJoinBtn;
@property (strong, nonatomic) IBOutlet UIButton *myHostBtn;

@end
