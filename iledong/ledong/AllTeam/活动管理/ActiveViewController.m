//
//  ActiveViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/8.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "ActiveViewController.h"
#import "ActiveTableViewCell.h"
#import "ActivityReleaseViewController.h"

@interface ActiveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor redColor]];
    [customLab setText:@"活动管理"];
    customLab.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    customLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = customLab;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_new"] style:UIBarButtonItemStylePlain target:self action:@selector(startActivityBtnClicked)];
    rightButton.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT);
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F3F4);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 140;
    }
    else {
        return 100;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idnetifier = @"activeCell";
    ActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idnetifier];
    if (!cell)
        cell = [[NSBundle mainBundle] loadNibNamed:@"ActiveTableViewCell" owner:self options:nil][0];

    cell.activityImageView.image = [UIImage imageNamed:@"img_1"];
    if (indexPath.section == 0) {
        cell.activityName.text = @"朝阳区乐动杯足球联赛";
        cell.activityDesc.text = @"足球|北京，多个赛场|04-09(周六)";
        cell.activityState.text = @"进行中";
        cell.state = activityStateOnGoing;
    }
    else {
        cell.activityName.text = @"朝阳区乐动杯足球联赛";
        cell.activityDesc.text = @"足球|北京，多个赛场|04-09(周六)";
        cell.activityState.text = @"已结束";
        cell.state = activityStateEnd;
    }
    [cell.activityName sizeToFit];
    [cell.activityDesc sizeToFit];
    [cell.activityState sizeToFit];
    
    [cell setSelectManagerBtnClicked:^() {
        
    }];

    return cell;
}

- (void)startActivityBtnClicked {
    ActivityReleaseViewController* VC = [[ActivityReleaseViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
