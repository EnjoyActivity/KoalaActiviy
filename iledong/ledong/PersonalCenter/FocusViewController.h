//
//  FocusViewController.h
//  ledong
//
//  Created by TDD on 16/3/2.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"

@interface FocusViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;// 玩家和空间列表
@property (weak, nonatomic) IBOutlet UIButton *playerBtn;// 玩家
@property (weak, nonatomic) IBOutlet UIButton *friendSpaceBtn;// 空间



@end
