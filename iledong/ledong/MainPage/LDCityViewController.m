//
//  LDCityViewController.m
//  ledong
//
//  Created by 郑红 on 5/26/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import "LDCityViewController.h"

static NSString * const cityCell = @"cityCell";

@interface LDCityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * cityArray;
}

@property (strong, nonatomic) IBOutlet UITableView *cityTableView;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;

@end

@interface LDCityViewController ()

@end

@implementation LDCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityLabel.text = self.cityName;
    [self.cityTableView registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cityCell"];
    self.cityTableView.tableFooterView = [UIView new];
    
    [self getCityByProvinceCode:self.provinceCode];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - NetWork

- (void)getCityByProvinceCode:(NSString *)code {
    NSDictionary * dic = @{
                           @"ProvinceCode":code
                           };
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager GET:@"other/GetCitys" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * resultDic = (NSDictionary *)responseObject;
        NSInteger code = [resultDic[@"code"] integerValue];
        if (code != 0) {
            [SVProgressHUD showErrorWithStatus:@"获取城市信息失败"];
            return ;
        }
        NSArray * result = [resultDic objectForKey:@"result"];
        cityArray = [result copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cityTableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取城市信息失败"];
    }];
}

#pragma mark - UItableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cityCell forIndexPath:indexPath];
    UILabel * label = (UILabel *)[cell viewWithTag:2];
    NSDictionary * dic = cityArray[indexPath.row];
    label.text = [dic objectForKey:@"Name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = cityArray[indexPath.row];
    if (self.city) {
        self.city(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
