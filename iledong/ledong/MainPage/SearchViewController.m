//
//  SearchViewController.m
//  ledong
//
//  Created by luojiao  on 16/3/28.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "FRUtils.h"
#import "SearchActiveVC.h"
#import "SearchTeamVC.h"
#import "SearchFriendVC.h"


@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *sctionArr;
}

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.tableView.tableFooterView = _footerView;
    
    [self.searchActive setImage:[FRUtils resizeImageWithImageName:@"ic_search_activity"] forState:UIControlStateNormal];
    [self.searchTeam setImage:[FRUtils resizeImageWithImageName:@"ic_search_team"] forState:UIControlStateNormal];
    [self.searchFriend setImage:[FRUtils resizeImageWithImageName:@"ic_search_friend"] forState:UIControlStateNormal];
    self.clearSarchImage.image = [FRUtils resizeImageWithImageName:@"btn_white"];
    self.resultTableView.hidden = YES;
    self.textFiled.delegate = self;
    self.textFiled.clearButtonMode = UITextFieldViewModeAlways;
    self.textFiled.returnKeyType = UIReturnKeySearch;
    self.resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    sctionArr = [[NSMutableArray alloc] initWithObjects:@"活动",@"团队",@"好友", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ButtonClick
- (IBAction)searchTeamButtonClick:(id)sender
{
    SearchTeamVC *teamController = [[SearchTeamVC alloc] init];
    [self.navigationController pushViewController:teamController animated:YES];
}

- (IBAction)searchActivButtonClick:(id)sender
{
    SearchActiveVC *activeController = [[SearchActiveVC alloc] init];
    [self.navigationController pushViewController:activeController animated:YES];
}

- (IBAction)searchFrindsButtonClick:(id)sender
{
    SearchFriendVC *friendController = [[SearchFriendVC alloc] init];
    [self.navigationController pushViewController:friendController animated:YES];
}

- (IBAction)gobackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearSearchButtonClick:(id)sender
{
    
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.contentView.hidden = YES;
    self.resultTableView.hidden = NO;
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        return 44.0;
    }
    else
    {
        return 100.0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.resultTableView)
    {
        return 3;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        static NSString *dentifier = @"searchCell";
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dentifier];
        if (!cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil][0];
        }
        return cell;
    }
    else
    {
        static NSString *identifier = @"reslutCell";
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil][1];
        }
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.resultTableView)
    {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.resultTableView)
    {
        return 49;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(18, 10, 40, 20)];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    title.text = sctionArr[section];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 39, self.view.frame.size.width, 1)];
    lineImageView.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1];
    nameView.backgroundColor = [UIColor whiteColor];
    [nameView addSubview:lineImageView];
    [nameView addSubview:title];
    return nameView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 200, 40)];
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 9)];
    bgImage.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1];
    nameLabel.text = [NSString stringWithFormat:@"查看更多相关%@",sctionArr[section]];
    nameLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    nameLabel.font = [UIFont systemFontOfSize:15];
    
    [button setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0,  self.view.frame.size.width - 35, 0,0)];
//    [button setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    [footerView addSubview:nameLabel];
    [footerView addSubview:bgImage];
    [footerView addSubview:button];
    
    return footerView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
