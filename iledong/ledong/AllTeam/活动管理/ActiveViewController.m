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
#import "ActiveDetailViewController.h"

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
    
    [self queryDatas:self.currentPageIndex++];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshDatas) name:@"activeRefreshNotification" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshDatas {
    [self queryDatas:self.currentPageIndex++];
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //if (indexPath.section == 0) {
    //    return 140;
    //}
    //else {
        return 100;
   // }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idnetifier = @"activeCell";
    __weak typeof(self) weakSelf = self;
    ActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idnetifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell)
        cell = [[NSBundle mainBundle] loadNibNamed:@"ActiveTableViewCell" owner:self options:nil][0];

    NSInteger row = indexPath.section;  //每个section一个cell
    NSDictionary* dict = self.datas[row];
    //NSString* constitutorId = [dict objectForKey:@"ConstitutorId"];
    NSString* cover = [dict objectForKey:@"Cover"];
    NSString* title = [dict objectForKey:@"Title"];
    NSString* endTime = [dict objectForKey:@"EndTime"];
    NSString* className = [dict objectForKey:@"ClassName"];
    NSString* demand = [dict objectForKey:@"Demand"];
    NSString* cityName = [dict objectForKey:@"cityName"];
    NSNumber* isLeague = [dict objectForKey:@"IsLeague"];
    
    //判断活动状态
    cell.state = activityStateOnGoing;
    if ([endTime isKindOfClass:[NSString class]] && endTime.length > 0) {
        NSDate* currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
        NSDate *endDate = [formatter dateFromString:endTime];
        if ([endDate compare:currentDate] == NSOrderedAscending)
            cell.state = activityStateEnd;
    }
    
    NSString* path = [[NSBundle mainBundle]pathForResource:@"img_teamavatar_120@2x" ofType:@"png"];
    cell.activityImageView.image = [UIImage imageWithContentsOfFile:path];
    if (cover.length > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:cover]];
            [request setHTTPMethod:@"GET"];
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            if (data == nil)
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.activityImageView.image = [UIImage imageWithData:data];
                [cell setNeedsLayout];
            });
        });
    }
    
    cell.activityName.text = title;
    if (isLeague.intValue == 1)
        cell.activityDesc.text = demand;
    else
        cell.activityDesc.text = [NSString stringWithFormat:@"%@|%@", className, cityName];
    [cell.activityName sizeToFit];
    [cell.activityDesc sizeToFit];
    [cell.activityState sizeToFit];
    
    NSString* teamId = self.teamId;
    [cell setSelectManagerBtnClicked:^() {
        ActivityReleaseViewController* VC = [[ActivityReleaseViewController alloc]init];
        VC.teamId = teamId;
        [weakSelf.navigationController pushViewController:VC animated:YES];
    }];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ActiveDetailViewController* Vc = [[ActiveDetailViewController alloc]init];
    NSDictionary* dict = self.datas[indexPath.row];
    NSNumber* activeId = [dict objectForKey:@"Id"];
    Vc.Id = activeId.intValue;
    
    [self.navigationController pushViewController:Vc animated:YES];
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
    //暂不使用分页,设置第一页获取1000个数据
    NSInteger pageSize = 1000;
    //
    
    NSString* strToken = [HttpClient getTokenStr];
    NSDictionary* parameter = @{@"token":strToken,@"page":[NSNumber numberWithInteger:1/*pageIndex*/],@"PageSize":[NSNumber numberWithInteger:pageSize],@"ActivityType":@1,
                                @"TeamId":self.teamId};
    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_QUERY_ACTIVITY_URL];
    
    __weak typeof(self)weakSelf = self;
    [HttpClient postJSONWithUrl:urlStr parameters:parameter success:^(id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSNumber* codeNum = [dict objectForKey:@"code"];
        if (codeNum.intValue == 0) {
            weakSelf.datas = [dict objectForKey:@"result"];
            [weakSelf.tableView reloadData];
        }
    } fail:^{
        [Dialog simpleToast:@"查询活动列表失败！" withDuration:1.5];
    }];
}

@end
