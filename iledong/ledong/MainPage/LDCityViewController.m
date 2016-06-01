//
//  LDCityViewController.m
//  ledong
//
//  Created by 郑红 on 5/26/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import "LDCityViewController.h"

static NSString * const cityCell = @"cityCell";

@interface LDCityViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSArray * cityArray;
    NSArray * resultArray;
    BOOL isSearching;
    NSDictionary * currentCityDic;
}
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UITableView *cityTableView;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UIButton *currentCity;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentTopLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cityTableTopLayout;


@end

@interface LDCityViewController ()

@end

@implementation LDCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.searchLocation) {
        self.cityTableTopLayout.constant = 64;
    }
    self.cityLabel.text = self.provinceName;
    
    [self.currentCity setImage:[UIImage imageNamed:@"ic_triangle_grey@2x"] forState:UIControlStateNormal];
  
    self.currentCity.transform = CGAffineTransformMakeScale(-1,1);
    self.currentCity.titleLabel.transform = CGAffineTransformMakeScale(-1, 1);
    self.currentCity.imageView.transform = CGAffineTransformMakeScale(-1, 1);
    
    [self.cityTableView registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cityCell"];
    
    self.cityTableView.tableFooterView = [UIView new];
    
    [self getCityByProvinceCode:self.provinceCode];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
        currentCityDic = [cityArray firstObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * name = [currentCityDic objectForKey:@"Name"];
            [self.currentCity setTitle:name forState:UIControlStateNormal];
            [self.cityTableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取城市信息失败"];
    }];
}

- (void)searchCity:(NSString *)keyWord City:(NSString *)city {
    if (keyWord.length == 0) {
        return;
    }
    isSearching = YES;
    [SVProgressHUD showWithStatus:@"搜索中..."];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:keyWord forKey:@"keyword"];
    if (city.length != 0) {
        [dic setObject:city forKey:@"region"];
    }
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager GET:@"Map/SuggestAddress" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code != 0) {
            return ;
        }
        [SVProgressHUD dismiss];
        NSArray * result = [dic objectForKey:@"result"];
        resultArray = [result copy];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cityTableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
         [SVProgressHUD showErrorWithStatus:@"搜索失败"];
    }];
}

#pragma mark - UItableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching) {
        return resultArray.count;
    }
    return cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cityCell forIndexPath:indexPath];
    UILabel * label = (UILabel *)[cell viewWithTag:2];
        if (isSearching) {
            NSDictionary * dic = resultArray[indexPath.row];
            NSString * name = [dic objectForKey:@"name"];
            NSString * city = [dic objectForKey:@"city"];
            NSString * district =[dic objectForKey:@"district"];
            label.text = [NSString stringWithFormat:@"%@--%@--%@",name,city,district];
            
        }
        else
        {
            NSDictionary * dic = cityArray[indexPath.row];
            label.text = [dic objectForKey:@"Name"];
        }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchLocation) {
        if (isSearching) {
            [self backPlaceDic:indexPath.row];
            
        }
        else
        {
            currentCityDic = cityArray[indexPath.row];
            NSString * name = [currentCityDic objectForKey:@"Name"];
            [self.currentCity setTitle:name forState:UIControlStateNormal];
            
        }
      
    }
    else
    {
        NSDictionary * dic = cityArray[indexPath.row];
        if (self.city) {
            self.city(dic);
        }
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popToViewController:self.destinationVc animated:YES];
    }
    
}

- (void)backPlaceDic:(NSInteger)row {
    NSDictionary * dic = resultArray[row];
    NSDictionary * dicTemp = @{
                               @"province":self.provinceName,
                               @"provinceCode":self.provinceCode,
                               @"city":[currentCityDic objectForKey:@"Name"],
                               @"cityCode":[currentCityDic objectForKey:@"Code"],
                               @"district":[dic objectForKey:@"district"],
                               @"districtCode":[dic objectForKey:@"areacode"],//暂未返回
                               @"name":[dic objectForKey:@"name"],
                               @"latlng":[dic objectForKey:@"location"],
                               };
#warning 区域ID暂未返回
    if (self.city) {
        self.city(dicTemp);
    }
//    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToViewController:self.destinationVc animated:YES];
}

#pragma mark - UItextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (isSearching) {
        isSearching = NO;
        [self.cityTableView reloadData];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSString * title = self.currentCity.titleLabel.text;
    if ([title isEqualToString:@"全部城市"]) {
        title = nil;
    }
    [self searchCity:self.searchTextField.text City:title];

    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)changeCurrentCity:(id)sender {

}
- (IBAction)searchButton:(id)sender {
    [self.searchTextField resignFirstResponder];
    NSString * title = self.currentCity.titleLabel.text;
    if ([title isEqualToString:@"全部城市"]) {
        title = nil;
    }
    [self searchCity:self.searchTextField.text City:title];
    
}


@end
