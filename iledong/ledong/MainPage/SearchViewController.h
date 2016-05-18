//
//  SearchViewController.h
//  ledong
//
//  Created by luojiao  on 16/3/28.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *searchFriend;
@property (weak, nonatomic) IBOutlet UIButton *searchTeam;
@property (weak, nonatomic) IBOutlet UIButton *searchActive;
@property (weak, nonatomic) IBOutlet UIImageView *clearSarchImage;

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@end
