//
//  PublicManageViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/7.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "PublicManageViewController.h"
#import "ManageTableViewCell.h"

@interface PublicManageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PublicManageViewController

- (void)viewDidLoad {
    self.titleName = @"公告管理";
    [super viewDidLoad];
    // Do any additional setup after loa;ding the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"manageCell";
    ManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ManageTableViewCell" owner:self options:nil][0];
    }
    return cell;
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
