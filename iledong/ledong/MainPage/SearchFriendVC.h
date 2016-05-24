//
//  SearchFriendVC.h
//  ledong
//
//  Created by luojiao  on 16/4/20.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchFriendVC : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *gobackButton;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIImageView *footerImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (nonatomic,strong) UITableView * resultTableView;
@property (strong, nonatomic) IBOutlet UILabel *resultCountLabel;

@end
