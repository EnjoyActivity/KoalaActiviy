//
//  MyCollectionViewController.m
//  ledong
//
//  Created by TDD on 16/3/3.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "CollectTableViewCell.h"

@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    self.titleName = @"我的收藏";
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Idnetifier = @"collectionCell";
    CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Idnetifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CollectTableViewCell" owner:self options:nil][0];
    }
    return cell;
}

@end
