//
//  AllTeamController.m
//  ledong
//
//  Created by dongguoju on 16/2/29.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "AllTeamController.h"
#import "AllTeamCell.h"
#import "HttpClient.h"
#import "LoginAndRegistViewController.h"
#import "FRUtils.h"
#import "CreateTeamVController.h"
#import "JoinTeamViewController.h"
#import "TeamHomeViewController.h"


@interface AllTeamController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArr;
}

@end

@implementation AllTeamController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *myBar = [[UITabBarItem alloc]initWithTitle:@"团队" image:[UIImage imageNamed:@"ic_team_on"] tag:1];
           myBar.selectedImage = [UIImage imageNamed:@"ic_team"];
        self.tabBarItem = myBar;
        dataArr = [[NSMutableArray alloc] initWithObjects:@"1",@"2", nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [_tableView registerNib:[UINib nibWithNibName:@"AllTeamCell" bundle:nil] forCellReuseIdentifier:@"AllTeamCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self getTeamList];
}

#pragma mark -- API
- (void)getTeamList
{
    if ([HttpClient isLogin])
    {
        NSString *urlStr = [API_BASE_URL stringByAppendingString:API_JOINTEAMS_URL];
        NSDictionary *dic = @{@"token":[HttpClient getTokenStr]};
        [HttpClient postJSONWithUrl:urlStr parameters:dic success:^(id responseObject)
         {
             NSLog(@"%@",responseObject);
         } fail:^{
             [Dialog simpleToast:@"获取我的团队失败！" withDuration:1.5];
         }];
        
    }
    else
    {
                return;
//        [FRUtils presentToLoginViewControllerWithRootViewController:self];
    }
}

#pragma mark -- UIButtonClick
- (IBAction)myTeamButton:(id)sender
{
    [self.myTeam setBackgroundColor:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1]];
    [self.myTeam setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.teamAgree setBackgroundColor:[UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1]];
    [self.teamAgree setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
//    self.footerView.hidden = NO;

}
- (IBAction)TeamAgree:(id)sender
{
    [self.myTeam setBackgroundColor:[UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1]];
    [self.myTeam setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    [self.teamAgree setBackgroundColor:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1]];
    [self.teamAgree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.footerView.hidden = YES;
}

//创建团队
- (IBAction)createTeamButtonClick:(id)sender
{
    if ([HttpClient isLogin])
    {
        CreateTeamVController *createViewController = [[CreateTeamVController alloc] init];
        [self.navigationController pushViewController:createViewController animated:YES];
    }
    else
    {
        [FRUtils presentToLoginViewControllerWithRootViewController:self];
    }
}

//加入团队
- (IBAction)joinTeamButtonClick:(id)sender
{
    if ([HttpClient isLogin])
    {
        JoinTeamViewController *joinTeamViewController = [[JoinTeamViewController alloc] init];
        [self.navigationController pushViewController:joinTeamViewController animated:YES];
    }
    else
    {
        [FRUtils presentToLoginViewControllerWithRootViewController:self];
    }
}

#pragma mark -- tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *string = @"AllTeamCell";
    AllTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AllTeamCell" owner:self options:nil][0];
    }
    return cell;
}

//删除某一行
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if ([tableView isEqual:_tableView])
    {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[dataArr count]) {
            [dataArr removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
//            [_tableView reloadData];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamHomeViewController *teamHomeVC = [[TeamHomeViewController alloc] init];
    [self.navigationController pushViewController:teamHomeVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
