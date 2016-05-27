//
//  LDSearchMoreViewController.m
//  ledong
//
//  Created by 郑红 on 5/26/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import "LDSearchMoreViewController.h"
#import "HistoryTableViewCell.h"

static NSString * const teamCell = @"ActivityCell";

@interface LDSearchMoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    NSMutableArray * activityArray;
    
}

@property (strong, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation LDSearchMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.titleLabel setText:self.keyWord];
   [self.resultTableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:teamCell];
    
    [self requestActivityData:self.keyWord];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - netWork

- (void)requestActivityData:(NSString *)keyWord {
    NSString * token = [HttpClient getTokenStr];
    if (token.length == 0) {
        return;
    }
    
    NSDictionary * dic = @{
                           @"token":token,
                           @"page":[NSNumber numberWithInt:1],
                           @"PageSize":[NSNumber numberWithInt:100],
                           @"tag":keyWord
                           };
    
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager POST:@"Activity/GetActivityItemsByActivityId" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * resultDic = (NSDictionary *)responseObject;
        NSInteger code = [resultDic[@"code"] integerValue];
        if (code != 0) {
            [SVProgressHUD showErrorWithStatus:@"error"];
            return ;
        }
        NSArray * result = [resultDic objectForKey:@"result"];
        self.activityArray = [result copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.resultTableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"搜索失败"];
    }];
}

#pragma mark - uitableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell * cell = (HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:teamCell forIndexPath:indexPath];
    NSDictionary * dic =self.activityArray[indexPath.row];
    NSString * teamImage = [dic objectForKey:@"AvatarUrl"];
    NSURL * teamUrl = [NSURL URLWithString:teamImage];
    
    NSString * name = [dic objectForKey:@"Name"];
    NSString * member = [dic objectForKey:@"PersonNum"];
    cell.keyWords = self.keyWord;
    [cell.sImageView sd_setImageWithURL:teamUrl placeholderImage:[UIImage imageNamed:@"img_avatar_100"]];
    [cell updateName:name detail:[NSString stringWithFormat:@"%@人",member]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
