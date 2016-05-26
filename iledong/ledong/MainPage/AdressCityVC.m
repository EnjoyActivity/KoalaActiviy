//
//  AdressCityVC.m
//  
//
//  Created by luojiao  on 16/3/23.
//
//

#import "AdressCityVC.h"
#import "FRUtils.h"
#import "LDLocationManager.h"
#import "LDChineseToPinyin.h"
#import "LDCityViewController.h"


@interface AdressCityVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    NSArray * cityArray;
    NSArray * cityIndex;
    NSArray * provinceArray;
    NSMutableArray * searchResultArray;
    
    NSMutableArray * provinceIndex;
    NSDictionary * provinceDic;
    BOOL isProvince;

}
@property (nonatomic, strong) UITableView * searchResultTable;
@end

@implementation AdressCityVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    isProvince = YES;
    [self.view addSubview:self.searchResultTable];
    
    if (_locationDic) {
        NSString * cityName =[self.locationDic objectForKey:@"city"];
        self.adressCity.text = cityName;
    }
    
    [self.searchButton setBackgroundImage:[FRUtils resizeImageWithImageName:@"ic_search_a"] forState:UIControlStateNormal];
    self.tableView.sectionIndexColor = [UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cityCell"];
    self.searchTextfile.delegate = self;
    searchResultArray = [NSMutableArray array];
    
    cityIndex = @[@"A", @"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    provinceIndex = [NSMutableArray arrayWithArray:cityIndex];
    [self requestCityData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
}

- (NSMutableDictionary *)cityData {
    NSMutableDictionary * cityDicTemp = [NSMutableDictionary dictionary];
    int a = 65;
    
//    NSArray * hotCity = @[@"北京",@"上海",@"广州",@"成都"];
//    [cityDicTemp setObject:hotCity forKey:@"热门城市"];
    
    for (int i = 0; i<26; i++) {
        NSString * title = [NSString stringWithFormat:@"%c",a];
        NSMutableArray * cityArrTemp = [NSMutableArray array];
        [cityDicTemp setObject:cityArrTemp forKey:title];
        a++;
    }
    return [cityDicTemp copy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NetWork

- (void)requestCityData {
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager GET:@"other/getprovinces" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code != 0) {
            [SVProgressHUD showErrorWithStatus:@"获取城市信息失败"];
            return ;
        }
//        NSArray * cityArray = [dic objectForKey:@"result"];
//        provinceArray = [cityArray copy];
//        [
        [self dealProvinceData:[dic objectForKey:@"result"]];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取城市信息失败"];
    }];
}


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
            return ;
        }
        
        NSArray * result = [resultDic objectForKey:@"result"];
//        locationArray = [result copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)dealProvinceData:(NSArray *)provinceArr {
    NSMutableDictionary * dicTemp = [self cityData];
    for (NSDictionary * dic in provinceArr) {
        NSString * name = dic[@"Name"];
        NSString * title = [LDChineseToPinyin getSectionTitle:name];
        NSMutableArray * arrTemp = [dicTemp objectForKey:title];
        [arrTemp addObject:dic];
    }
    provinceDic = [dicTemp copy];
    
    [provinceDic enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSMutableArray * obj, BOOL * _Nonnull stop) {
        if (obj.count == 0) {
            [provinceIndex removeObject:key];
        }
        
    }];
    
    [self.tableView reloadData];
}

#pragma mark - ButtonClick
- (IBAction)gobackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchCity:(UIButton *)sender {
    
}


#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.searchResultTable]) {
        return 1;
    }
    if (isProvince) {
        return provinceIndex.count;
    }
    return cityIndex.count;//[cityDic allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    if ([tableView isEqual:self.searchResultTable]) {
        return searchResultArray.count;
    }
    if (isProvince) {
        NSString * index = provinceIndex[section];
        NSMutableArray * arr = [provinceDic objectForKey:index];
        return arr.count;
    }
    
//    NSString * index = cityIndex[section];
//
//    int sectionValu = (int)section;
//    NSString * str = [NSString stringWithFormat:@"%c",sectionValu+64];
//    NSArray * arr = [cityDic objectForKey:index];
    return cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    UILabel * cityLabel = (UILabel *)[cell viewWithTag:2];
    if ([tableView isEqual:self.searchResultTable]) {
        cityLabel.text = searchResultArray[indexPath.row];
    }
    else
    {
//        NSString * index = cityIndex[indexPath.section];
//        NSArray * arr =  [cityArray objectForKey:index];
//        cityLabel.text = arr[indexPath.row];
        if (isProvince) {
            NSString * index = provinceIndex[indexPath.section];
            NSMutableArray * arr = [provinceDic objectForKey:index];
            NSDictionary * dic = arr[indexPath.row];
            cityLabel.text = [dic objectForKey:@"Name"];
        }
        else
        {
//            NSDictionary 
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

//返回头部的值
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 0, APP_WIDTH, 30)];
    view.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 100, 30)];
    label.textColor = [UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:15];
    if (isProvince) {
        label.text = provinceIndex[section];
    }
    else
    {
        label.text = cityIndex[section];
    }
    [view addSubview:label];
    return view;
}


//返回标题索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.searchResultTable]) {
        return @[];
    }
    if (isProvince) {
        return provinceIndex;
    }
    return cityIndex;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        NSString * index = provinceIndex[indexPath.section];
        NSMutableArray * arr = [provinceDic objectForKey:index];
        NSDictionary * dic = arr[indexPath.row];
        
        LDCityViewController * cityVc = [[LDCityViewController alloc] init];
        cityVc.provinceCode = [dic objectForKey:@"Code"];
        cityVc.cityName = [dic objectForKey:@"Name"];
        cityVc.city = ^(NSDictionary * cityDic) {
            if (self.locationResult) {
                self.locationResult(cityDic);
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
        [self.navigationController pushViewController:cityVc animated:YES];
    }
//    NSString * str = cityIndex[indexPath.section];
////    NSArray * arr = [cityArray objectForKey:str];
//    if (_locationResult != nil) {
//        _locationResult(arr[indexPath.row]);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    BOOL isTrue = textField.text.length == 0;
    self.tableView.hidden = !isTrue;
    self.searchResultTable.hidden = isTrue;
}

- (IBAction)editingChanged:(id)sender {
    UITextField * textField = (UITextField *)sender;
    BOOL isTrue = textField.text.length == 0;
    self.searchResultTable.hidden = isTrue;
    self.tableView.hidden = !isTrue;
    
    [searchResultArray addObject:textField.text];
    [self.searchResultTable reloadData];
}

- (UITableView *)searchResultTable {
    if (!_searchResultTable) {
        _searchResultTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APP_WIDTH, APP_HEIGHT-64) style:UITableViewStylePlain];
        _searchResultTable.delegate = self;
        _searchResultTable.dataSource = self;
        _searchResultTable.backgroundColor = [UIColor whiteColor];
        [_searchResultTable registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cityCell"];
        _searchResultTable.hidden = YES;
        _searchResultTable.sectionIndexColor = [UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    }
    return _searchResultTable;
}


@end
