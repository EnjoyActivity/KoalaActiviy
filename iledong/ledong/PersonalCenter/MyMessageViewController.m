//
//  MyMessageViewController.m
//  ledong
//
//  Created by TDD on 16/3/2.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "MyMessageViewController.h"
#import "PlayerTableViewCell.h"
#import "ActivityMessageViewController.h"

@interface MyMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    self.titleName = @"我的消息";
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
    
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerMessageCellIdentifier"];
    if (!cell)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:@"PlayerMessageTableViewCell" owner:self options:nil][0];
    }
    
    return cell;
}

#pragma mark - button click
- (IBAction)activityMessageButtonClick:(id)sender
{
    // 加载活动消息列表
    ActivityMessageViewController *activityMessageViewController = [[ActivityMessageViewController alloc] init];
    [self.navigationController pushViewController:activityMessageViewController animated:YES];
}

- (IBAction)playerMessageButtonClick:(id)sender
{
    // 加载玩家消息列表
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
