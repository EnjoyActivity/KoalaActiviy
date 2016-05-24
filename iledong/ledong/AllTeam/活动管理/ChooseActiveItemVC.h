//
//  ChooseActiveItemVC.h
//  ledong
//
//  Created by dengjc on 16/5/24.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseActiveItemVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int Id;
@end
