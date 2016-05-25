//
//  SelectTeamViewController.m
//  ledong
//
//  Created by liuxu on 16/5/25.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "SelectTeamViewController.h"
#import "AllTeamCell.h"
#import "JoinTeamViewController.h"

#define kCell       @"cell"

@interface SelectTeamViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableArray* datas;

@end

@implementation SelectTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavigationBar];
    [self setupTableView];
    
    [self queryTeamsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)setupNavigationBar {
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.title = @"选择团队";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, APP_WIDTH, APP_HEIGHT-64)];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F3F4);
    [self.tableView registerClass:[AllTeamCell class] forCellReuseIdentifier:kCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllTeamCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];

    NSDictionary* dict = self.datas[indexPath.row];
    NSString* path = [[NSBundle mainBundle]pathForResource:@"img_teamavatar_120@2x" ofType:@"png"];
    cell.teamImageView.image = [UIImage imageWithContentsOfFile:path];
    cell.teamNameLabel.text = [dict objectForKey:@"Name"];
    [cell.teamNameLabel sizeToFit];
    NSNumber* maxPersonNum = [dict objectForKey:@"MaxPersonNum"];
    cell.personCountLabel.text = [NSString stringWithFormat:@"%d人",maxPersonNum.intValue];
    [cell.personCountLabel sizeToFit];
    
    NSNumber* livenessNum = [dict objectForKey:@"Liveness"];
    cell.teamActiveCountLabel.text = [NSString stringWithFormat:@"团队活跃度 %d", livenessNum.intValue];
    NSNumber* concernNum  = [dict objectForKey:@"Concern"];
    cell.payAttentionCountLabel.text = [NSString stringWithFormat:@"%d人关注", concernNum.intValue];
    [cell.teamActiveCountLabel sizeToFit];
    [cell.payAttentionCountLabel sizeToFit];
    
    NSString* avatarUrl = [dict objectForKey:@"AvatarUrl"];
    if (avatarUrl.length > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:avatarUrl]];
            [request setHTTPMethod:@"GET"];
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            if (data == nil)
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.teamImageView.image = [UIImage imageWithData:data];
                [cell setNeedsLayout];
            });
        });
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JoinTeamViewController* Vc = [[JoinTeamViewController alloc]init];
    NSDictionary* dict = self.datas[indexPath.row];
    Vc.teamId = [dict objectForKey:@"Id"];
    [self.navigationController pushViewController:Vc animated:YES];
}

- (void)queryTeamsData {
    NSDictionary* dict = @{@"Page":@1, @"PageSize":@1000,@"IsHot":@0};
    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_QUERY_TEAMS_URL];
    [HttpClient postJSONWithUrl:urlStr parameters:dict success:^(id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSNumber* codeNum = [dict objectForKey:@"code"];
        if (codeNum.intValue == 0) {
            NSDictionary* tempDict = [dict objectForKey:@"result"];
            self.datas = [tempDict objectForKey:@"Data"];
            [self.tableView reloadData];
        }
    } fail:^{
        [Dialog simpleToast:@"查询团队失败！" withDuration:1.5];
    }];
}

@end
