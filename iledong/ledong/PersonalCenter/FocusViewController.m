//
//  FocusViewController.m
//  ledong
//
//  Created by TDD on 16/3/2.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "FocusViewController.h"
#import "FriendSpaceTableViewCell.h"
#import "PlayerTableViewCell.h"

@interface FocusViewController ()<UITableViewDataSource,UITabBarDelegate>

@property (nonatomic, assign) BOOL isPlayerList;// YES：加载玩家列表；NO：加载空间列表。

@end

@implementation FocusViewController

- (void)viewDidLoad {
    self.titleName = @"关注";
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.isPlayerList = YES;
}

#pragma mark <UITableViewDataSource,UITabBarDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isPlayerList)
    {
        // 玩家列表
        return 3;
    }else
    {
        // 团队列表
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isPlayerList)
    {
        // 玩家列表
        PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerTableViewCellIdentifier"];
        if (!cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PlayerTableViewCell" owner:self options:nil][0];
        }
        return cell;
    }else
    {
        // 团队列表
        FriendSpaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendSpaceTableViewCellIdentifier"];
        if (!cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"FriendSpaceTableViewCell" owner:self options:nil][0];
        }
        return cell;
    }
}

#pragma mark button Click
- (IBAction)playerButtonClick:(id)sender
{
    [self.playerBtn setBackgroundColor:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1]];
    [self.playerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.friendSpaceBtn setBackgroundColor:[UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1]];
    [self.friendSpaceBtn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    
    // 加载玩家列表
    if (!self.isPlayerList)
    {
        self.isPlayerList = YES;
        [self.tableView reloadData];
    }
    
}
- (IBAction)friendSpaceButtonClick:(id)sender
{
    [self.friendSpaceBtn setBackgroundColor:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1]];
    [self.friendSpaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playerBtn setBackgroundColor:[UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1]];
    [self.playerBtn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    
    // 加载团队列表
    if (self.isPlayerList)
    {
        self.isPlayerList = NO;
        [self.tableView reloadData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
