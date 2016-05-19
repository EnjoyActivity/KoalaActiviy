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
#import "ChangeAvatarViewController.h"
#import "ChangeNickNameViewController.h"
#import "ChangeGenderViewController.h"

@interface PersonalInfomationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImage *_image;
    UIButton *headerImage;
    NSMutableArray *nameArrSection1;
    NSMutableArray *contentArrSection1;
    NSMutableArray *nameArrSection2;
    NSMutableArray *contentArrSection2;
    
}

@end

@implementation PersonalInfomationViewController

- (void)viewDidLoad {
    self.titleName = @"用户信息";
    _image = [UIImage imageNamed:@"user02_44"];
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
    nameArrSection1 = [[NSMutableArray alloc] initWithObjects:@"昵称",@"性别",@"生日",@"常住地", nil];
    contentArrSection1 = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"", nil];
    nameArrSection2 = [[NSMutableArray alloc] initWithObjects:@"手机号",@"密码",nil];
    contentArrSection2 = [[NSMutableArray alloc] initWithObjects:@"",@"",nil];

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
        cell.contentLabel.text = contentArrSection1[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        cell.nameLabel.text = nameArrSection2[indexPath.row];
        cell.contentLabel.text = contentArrSection2[indexPath.row];
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
        
        headerImage = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 14, 44, 44)];
//        headerImage.image = [FRUtils circleImage:[UIImage imageNamed:@"user02_44"] withParam:1];
        [headerImage setImage:[FRUtils circleImage:_image withParam:1] forState:UIControlStateNormal];
        [headerImage addTarget:self action:@selector(uploadAvatar:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *headButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 72)];
        [headButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
        [headButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.view.frame.size.width - 40, 0, 0)];
        [headButton addTarget:self action:@selector(uploadAvatar:) forControlEvents:UIControlEventTouchUpInside];
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                ChangeNickNameViewController *vc = [[ChangeNickNameViewController alloc]init];
                vc.block = ^(NSString *name){
                    contentArrSection1[0] = name;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                ChangeGenderViewController *vc = [[ChangeGenderViewController alloc]init];
                vc.block = ^(BOOL isFemale){
                    if (isFemale) {
                        contentArrSection1[1] = @"女";
                    } else {
                        contentArrSection1[1] = @"男";
                    }
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
                
            }
                break;
            default:
                break;
        }
    } else {
        
    }
}

#pragma mark - button method
- (void)uploadAvatar:(UIButton*)sender {
    ChangeAvatarViewController *vc = [[ChangeAvatarViewController alloc]init];
    vc.block = ^(UIImage *image){
        _image = image;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
