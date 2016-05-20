//
//  ActivityReleaseViewController.m
//  ledong
//
//  Created by liuxu on 16/5/20.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ActivityReleaseViewController.h"

@interface ActivityReleaseViewController ()

@property (nonatomic, strong)UITableView* leagueTableView;
@property (nonatomic, strong)UITableView* nonleagueTableView;

@end

@implementation ActivityReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - drawUI 
- (void)setupNavigationBar {
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor redColor]];
    [customLab setText:@"发布活动"];
    customLab.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = customLab;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark - btn clicked 
- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
