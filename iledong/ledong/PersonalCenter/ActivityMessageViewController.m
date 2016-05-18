//
//  ActivityMessageViewController.m
//  ledong
//
//  Created by TDD on 16/3/2.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "ActivityMessageViewController.h"
#import "ActivityMessageTableViewCell.h"
#import "MyHostTableViewCell.h"

@interface ActivityMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) BOOL isMyHost; // 是否加载“我举办的”列表，YES:加载举办列表；NO:加载参加列表

@end

@implementation ActivityMessageViewController

- (void)viewDidLoad {
    self.titleName = @"活动消息";
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.isMyHost = NO;
}

#pragma mark - button click
- (IBAction)myJoinButtonClick:(id)sender
{
    // 加载 我参加的 列表
    if (self.isMyHost)
    {
        self.isMyHost = NO;
        [self.tableView reloadData];
    }
}

- (IBAction)myHostButtonClick:(id)sender
{
    // 加载 我举办的 列表
    if (!self.isMyHost)
    {
        self.isMyHost = YES;
        [self.tableView reloadData];
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isMyHost)
    {
        // 我参加的 列表
        return 64.0f;
    }else
    {
        // 我举办的 列表
        return 64.0f;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.isMyHost)
    {
        // 我参加的 列表
        return 2;
    }else
    {
        // 我举办的 列表
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isMyHost)
    {
        // 加载 我参加的 列表
        ActivityMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityMessageCellIdentifier"];
        if (!cell)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"ActivityMessageTableViewCell" owner:self options:nil][0];
        }
        
        return cell;
    }else
    {
       // 加载 我举办的 列表
        MyHostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myHostTableViewCellIdentifier"];
        if (!cell)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"MyHostTableViewCell" owner:self options:nil][0];
        }
        
        return cell;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
