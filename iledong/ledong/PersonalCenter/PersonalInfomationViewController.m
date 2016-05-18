//
//  PersonalInfomationViewController.m
//  ledong
//
//  Created by TDD on 16/3/1.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "PersonalInfomationViewController.h"
#import "SexViewController.h"
#import "ModificationPhoneVC.h"
#import "UserInfoTableViewCell.h"
#import "FRUtils.h"

@interface PersonalInfomationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *headerImage;
    NSMutableArray *nameArrSection1;
    NSMutableArray *nameArrSection2;
}

@end

@implementation PersonalInfomationViewController

- (void)viewDidLoad {
    self.titleName = @"用户信息";
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
    nameArrSection1 = [[NSMutableArray alloc] initWithObjects:@"昵称",@"性别",@"生日",@"常住地", nil];
    nameArrSection2 = [[NSMutableArray alloc] initWithObjects:@"手机号",@"密码",nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - buttonClick

- (IBAction)exitButtonClick:(id)sender {
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 4;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userIdentifier = @"userCell";
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UserInfoTableViewCell" owner:self options:nil][0];
    }
    if (indexPath.section == 0)
    {
        cell.nameLabel.text = nameArrSection1[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        cell.nameLabel.text = nameArrSection2[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 72.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 72)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 100, 72)];
        nameLabel.text = @"头像";
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        
        headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 14, 44, 44)];
        headerImage.image = [FRUtils circleImage:[UIImage imageNamed:@"user02_44"] withParam:1];
        UIButton *headButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 72)];
        [headButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
        [headButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.view.frame.size.width - 40, 0, 0)];
        
        UIImageView *lineImage = [[UIImageView alloc]
                                  initWithFrame:CGRectMake(18, 71, self.view.frame.size.width - 18, 1)];
        lineImage.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1];
        [headerView addSubview:nameLabel];
        [headerView addSubview:headerImage];
        [headerView addSubview:headButton];
        [headerView addSubview:lineImage];

        return headerView;
    }
    else
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 72)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *safetyLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 36, 100, 36)];
        safetyLabel.text = @"账号安全";
        safetyLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        safetyLabel.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:safetyLabel];
        UIImageView *lineImage = [[UIImageView alloc]
                                  initWithFrame:CGRectMake(18, 71, self.view.frame.size.width - 18, 1)];
        lineImage.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1];
        [headerView addSubview:lineImage];

        return headerView;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
