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
    BOOL isChangeCity;
    NSArray * filterArray;
    
    BOOL isSearching;
}
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UITableView *cityTableView;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UIButton *currentCity;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITableView *changeCityTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentTopLayout;


@end

@interface LDCityViewController ()

@end

@implementation LDCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityLabel.text = self.cityName;
    
    [self.currentCity setImage:[UIImage imageNamed:@"ic_triangle_grey@2x"] forState:UIControlStateNormal];
  
    self.currentCity.transform = CGAffineTransformMakeScale(-1,1);
    self.currentCity.titleLabel.transform = CGAffineTransformMakeScale(-1, 1);
    self.currentCity.imageView.transform = CGAffineTransformMakeScale(-1, 1);
    
    [self.cityTableView registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cityCell"];
    
    [self.changeCityTable registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cityCell"];
    self.changeCityTable.delegate   =self;
    self.changeCityTable.dataSource = self;
    
    
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
        filterArray = [result copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cityTableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取城市信息失败"];
    }];
}

- (void)searchCity:(NSString *)keyWord City:(NSString *)city {
    [SVProgressHUD showWithStatus:@"搜索中..."];
    isSearching = YES;
    if (keyWord.length == 0) {
        return;
    }
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:keyWord forKey:@"keyword"];
    if (city.length != 0) {
        [dic setObject:city forKey:@"region"];
    }
    
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager POST:@"Map/SuggestAddress" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
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
    if ([tableView isEqual:self.changeCityTable]) {
        return filterArray.count;
    }
    if (isSearching) {
        return resultArray.count;
    }
    return cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cityCell forIndexPath:indexPath];
    UILabel * label = (UILabel *)[cell viewWithTag:2];
    if ([tableView isEqual:self.changeCityTable]) {
        NSDictionary * dic = filterArray[indexPath.row];
        label.text = [dic objectForKey:@"Name"];
    }
    else
    {
        if (isSearching) {
            NSDictionary * dic = resultArray[indexPath.row];
            NSString * name = [dic objectForKey:@"name"];
            NSString * city = [dic objectForKey:@"city"];
            NSString * district =[dic objectForKey:@"district"];
            label.text = [NSString stringWithFormat:@"%@--%@--%@",name,city,district];
            
        }
        else
        {
            
        }
        NSDictionary * dic = cityArray[indexPath.row];
        label.text = [dic objectForKey:@"Name"];
    }
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.changeCityTable]) {
        NSDictionary * dic = filterArray[indexPath.row];
        NSString * title = [dic objectForKey:@"Name"];
        [self.currentCity setTitle:title forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.contentTopLayout.constant = 64;
        } completion:^(BOOL finished) {
            filterArray = [cityArray copy];
            isChangeCity = NO;
            [self.changeCityTable setHidden:YES];
            self.searchTextField.text = nil;
            [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        }];
    }
    else
    {
        if (isSearching) {
            NSDictionary * dic = resultArray[indexPath.row];
            if (self.city) {
                self.city(dic);
            }
        }
        else
        {
            NSDictionary * dic = cityArray[indexPath.row];
            if (self.city) {
                self.city(dic);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
  
}

#pragma mark - UItextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (isChangeCity) {
        [self.changeCityTable reloadData];
    }
    if (isSearching) {
        isSearching = NO;
        [self.cityTableView reloadData];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (isChangeCity) {
        [self searchCityLocal:textField.text];
    }
    else
    {
        NSString * title = self.currentCity.titleLabel.text;
        if ([title isEqualToString:@"全部城市"]) {
            title = nil;
        }
        [self searchCity:self.searchTextField.text City:title];
    }
    return YES;
}

- (IBAction)editingChanged:(id)sender {
    if (isSearching) {
        return;
    }
    UITextField * textFiled = (UITextField *)sender;
    if (textFiled.text.length == 0) {
        filterArray = [cityArray mutableCopy];
        [self.changeCityTable reloadData];
        return;
    }
    [self searchCityLocal:textFiled.text];
}

- (void)searchCityLocal:(NSString *)keyWord {
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary * dic in cityArray) {
        NSString * name =[dic objectForKey:@"Name"];
        if ([name containsString:keyWord]) {
            [tempArray addObject:dic];
        }
    }
    filterArray = [tempArray copy];
    [self.changeCityTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)changeCurrentCity:(id)sender {
    self.searchTextField.text = nil;
    isChangeCity  = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentTopLayout.constant = 20;

    } completion:^(BOOL finished) {
        [self.changeCityTable setHidden:NO];
        [self.changeCityTable reloadData];
        [self.searchButton setTitle:@"取消" forState:UIControlStateNormal];
    }];
}
- (IBAction)searchButton:(id)sender {
    if (isChangeCity) {
        [UIView animateWithDuration:0.5 animations:^{
            self.contentTopLayout.constant = 64;
        } completion:^(BOOL finished) {
            isChangeCity = NO;
            filterArray = [cityArray copy];
            [self.changeCityTable setHidden:YES];
            self.searchTextField.text = nil;
            [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        }];
    }
    else
    {
        NSString * title = self.currentCity.titleLabel.text;
        if ([title isEqualToString:@"全部城市"]) {
            title = nil;
        }
        [self searchCity:self.searchTextField.text City:title];
    }
    
}





@end
