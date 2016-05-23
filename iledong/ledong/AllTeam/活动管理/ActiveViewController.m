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
#import "ActivityReleaseViewController.h"

@interface ActiveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray* datas;
@property (assign,nonatomic)NSInteger currentPageIndex;

@end

@implementation ActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPageIndex = 1;
    self.datas = [NSMutableArray array];
    self.navigationItem.title = @"活动管理";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_new"] style:UIBarButtonItemStylePlain target:self action:@selector(startActivityBtnClicked)];
    rightButton.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT);
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F3F4);
    
    //[self queryDatas:self.currentPageIndex++];
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
    __weak typeof(self) weakSelf = self;
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
        ActivityReleaseViewController* VC = [[ActivityReleaseViewController alloc]init];
        VC.teamId = self.teamId;
        [weakSelf.navigationController pushViewController:VC animated:YES];
    }];

    return cell;
}

- (void)startActivityBtnClicked {
    ActivityReleaseViewController* VC = [[ActivityReleaseViewController alloc]init];
    VC.teamId = self.teamId;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)queryDatas:(NSInteger)pageIndex {
    NSString* strToken = [HttpClient getTokenStr];
    NSDictionary* parameter = @{@"token":strToken,@"page":[NSNumber numberWithInteger:pageIndex],@"PageSize":@10,@"ActivityType":@1,
                                @"TeamId":self.teamId};
    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_QUERY_ACTIVITY_URL];
    [HttpClient postJSONWithUrl:urlStr parameters:parameter success:^(id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSNumber* codeNum = [dict objectForKey:@"code"];
        if (codeNum.intValue == 0) {
            self.datas = [dict objectForKey:@"result"];
            [self.tableView reloadData];
        }
    } fail:^{
        [Dialog simpleToast:@"查询活动列表失败！" withDuration:1.5];
    }];
}

@end
