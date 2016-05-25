//
//  IntergralViewController.m
//  ledong
//
//  Created by TDD on 16/3/2.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "IntergralViewController.h"

@interface IntergralViewController ()
{
    NSArray *dataArr;
    NSArray *contentArr;
    UILabel *numLabel;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger inteNum;
@end

@implementation IntergralViewController

- (void)setInteNum:(NSInteger)inteNum {
    _inteNum = inteNum;
    numLabel.text = [NSString stringWithFormat:@"当前积分：%ld",inteNum];
}

- (void)viewDidLoad {
    self.titleName = @"我的积分";
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    dataArr = @[@"签到",@"参加活动",@"登录",@"新用户注册"];
    contentArr = @[@"+10",@"+10",@"+10",@"+10"];
    [self setupTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 36)];
    header.backgroundColor = RGB(222, 222, 222, 1);
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, APP_WIDTH - 15, 36)];
    numLabel.text = @"当前积分：40";
    numLabel.textColor = RGB(153, 153, 153, 1);
    numLabel.font = [UIFont systemFontOfSize:12];
    [header addSubview:numLabel];
    self.tableView.tableHeaderView = header;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}
#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = dataArr[indexPath.row];
    cell.detailTextLabel.text = contentArr[indexPath.row];

    cell.textLabel.textColor = RGB(51, 51, 51, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = RGB(227, 26, 26, 1);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

@end
