//
//  SearchHotViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/12.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "SearchHotViewController.h"
#import "HotTeamTableViewCell.h"

@interface SearchHotViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SearchHotViewController

- (void)viewDidLoad {
    self.titleName = @"热门团队";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"searchHotCell";
    HotTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HotTeamTableViewCell" owner:self options:nil][0];
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
