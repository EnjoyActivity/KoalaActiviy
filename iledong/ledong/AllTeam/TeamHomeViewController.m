//
//  TeamHomeViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/28.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "TeamHomeViewController.h"
#import "FRUtils.h"
#import "TeamManagerTableViewController.h"
#import "TeamHomeTableViewCell.h"

@interface TeamHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TeamHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.headerImage.image = [FRUtils circleImage:[UIImage imageNamed:@"user02_44"] withParam:1];
    [self setButton];
    
    CGFloat hight = self.headerImage.frame.size.height + self.middleView.frame.size.height + self.ActiveView.frame.size.height + self.footerView.frame.size.height + 90;
    self.scrollView.contentSize = CGSizeMake(APP_WIDTH, hight);
}


- (void)setButton
{
    //关注、积分、足迹、粉丝button设置
    [self.footButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.fansButton setTitle:@"积分" forState:UIControlStateNormal];
    [self.membersButton setTitle:@"足迹" forState:UIControlStateNormal];
    [self.publicButton setTitle:@"粉丝" forState:UIControlStateNormal];
    [self.footButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.fansButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.membersButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.publicButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    
    if (self.teamType == teamTypeCreate) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_manage"] style:UIBarButtonItemStylePlain target:self action:@selector(manageBtnClicked)];
        rightButton.tintColor = [UIColor redColor];
        self.navigationItem.rightBarButtonItem = rightButton;
    }

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - buttonClick
- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)memberButton:(id)sender {
    
}
- (IBAction)fansButton:(id)sender {
    
}

- (IBAction)publicButton:(id)sender {
    
}
- (IBAction)footButton:(id)sender {
    
}

- (void)manageBtnClicked {
    TeamManagerTableViewController* VC = [[TeamManagerTableViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"teamHCell";
    TeamHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TeamHomeTableViewCell" owner:self options:nil][0];
    }
    return cell;
}

@end
