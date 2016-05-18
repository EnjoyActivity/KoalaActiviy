//
//  MyWalletViewController.m
//  ledong
//
//  Created by TDD on 16/3/9.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletDetailTableViewCell.h"

@interface MyWalletViewController ()

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    self.titleName = @"钱包";
    [super viewDidLoad];
    self.rightButton.hidden = NO;
    [self.rightButton setTitle:@"设置" forState:UIControlStateNormal];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyWalletDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyWalletDetailCellIdentifier"];
    if (!cell)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyWalletDetailTableViewCell" owner:self options:nil][0];
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
