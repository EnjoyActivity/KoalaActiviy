//
//  TeamManagerTableViewController.m
//  ledong
//
//  Created by liuxu on 16/5/20.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "TeamManagerTableViewController.h"
#import "ActiveViewController.h"
#import "MyWalletViewController.h"

#define kCell      @"cell"

@interface TeamManagerTableViewController ()

@end

@implementation TeamManagerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"团队管理";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F3F4);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = 1;
            break;
        case 2:
            count = 3;
            break;
        case 3:
            count = 1;
            break;
        default:
            break;
    }
    return count;
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = UIColorFromRGB(0x585858);
    
    UILabel* lineLabel = (UILabel*)[cell.contentView viewWithTag:100];
    if (!lineLabel) {
        lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, cell.contentView.bounds.size.height-0.5, APP_WIDTH-15, 0.5)];
        lineLabel.tag = 100;
        lineLabel.backgroundColor = UIColorFromRGB(0xE7E7E7);
        [cell.contentView addSubview:lineLabel];
    }
    lineLabel.hidden = YES;

    if (indexPath.section == 2) {
        lineLabel.hidden = NO;
        if (indexPath.row == 0)
            cell.textLabel.text = @"公告管理";
        else if (indexPath.row == 1)
            cell.textLabel.text = @"成员管理";
        else if (indexPath.row == 2)
            cell.textLabel.text = @"团队钱包";
    }
    else if (indexPath.section == 0)
        cell.textLabel.text = @"团队足迹";
    else if (indexPath.section == 1)
        cell.textLabel.text = @"活动管理";
    else if (indexPath.section == 3)
        cell.textLabel.text = @"管理权转让";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        //活动管理
        ActiveViewController* VC = [[ActiveViewController alloc]init];
        VC.teamId = self.teamId;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 2) {
            MyWalletViewController *vc = [[MyWalletViewController alloc]init];
            vc.navTitle = @"团队钱包";
            vc.teamId = self.teamId.intValue;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
    }

}

@end
