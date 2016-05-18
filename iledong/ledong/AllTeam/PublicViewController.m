//
//  PublicViewController.m
//  ledong
//
//  Created by luojiao  on 16/3/30.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "PublicViewController.h"
#import "PublicTableViewCell.h"
#import "PublicDetailViewController.h"

@interface PublicViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PublicViewController

- (void)viewDidLoad {
    self.titleName = @"公告列表";
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"publicCell";
    PublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PublicTableViewCell" owner:self options:nil][0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublicDetailViewController *publicDetailViewController = [[PublicDetailViewController alloc] init];
    [self.navigationController pushViewController:publicDetailViewController animated:YES];
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
