//
//  FootprintViewController.m
//  ledong
//
//  Created by TDD on 16/3/2.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "FootprintViewController.h"
#import "FooterTableViewCell.h"

@interface FootprintViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *imageArr ;
}
@end

@implementation FootprintViewController

- (void)viewDidLoad {
    self.titleName = @"我的足迹";
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    imageArr = [[NSArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FooterTableViewCell calculateRowsHight:@"加大法师法师法撒打发士大夫是打发发顺丰是打发士大夫撒旦撒旦法飞洒的发" :imageArr];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Idnetifier = @"footerCell";
    FooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Idnetifier];
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FooterTableViewCell" owner:self options:nil][0];
    }
    [cell updateUIWithData:@"加大法师法师法撒打发士大夫是打发发顺丰是打发士大夫撒旦撒旦法飞洒的发" :imageArr :indexPath.row :5];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


@end
