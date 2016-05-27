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

    NSMutableArray * searchResultArray;
    
    NSMutableArray * provinceIndex;
    NSDictionary * provinceDic;
    
    NSDictionary * currentProvinceDic;


}
@property (strong, nonatomic) IBOutlet UIButton *currentCityButton;
@property (nonatomic, strong) UITableView * searchResultTable;
@end

@implementation AdressCityVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.searchResultTable];
    
    if (_locationDic) {
        NSString * provinceName = [self.locationDic objectForKey:@"province"];
        NSString * cityName =[self.locationDic objectForKey:@"city"];
        NSString * str = [NSString stringWithFormat:@"%@ %@",provinceName,cityName];
        [self.currentCityButton setTitle:str forState:UIControlStateNormal];
    }
    else
    {
        NSDictionary * dic = [FRUtils getAddressInfo];
        if (dic != nil) {
            self.locationDic = dic;
            NSString * provinceName = [self.locationDic objectForKey:@"province"];
            NSString * cityName =[self.locationDic objectForKey:@"city"];
            NSString * str = [NSString stringWithFormat:@"%@ %@",provinceName,cityName];
            [self.currentCityButton setTitle:str forState:UIControlStateNormal];
        }
        
    }
    self.currentCityButton.enabled = NO;
    
    [self.searchButton setBackgroundImage:[FRUtils resizeImageWithImageName:@"ic_search_a"] forState:UIControlStateNormal];
    self.tableView.sectionIndexColor = [UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cityCell"];
    self.searchTextfile.delegate = self;
    searchResultArray = [NSMutableArray array];
    
    NSArray * cityIndex = @[@"A", @"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    provinceIndex = [NSMutableArray arrayWithArray:cityIndex];
    [self requestCityData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (NSMutableDictionary *)cityData {
    NSMutableDictionary * cityDicTemp = [NSMutableDictionary dictionary];
    int a = 65;
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

        self.currentCityButton.enabled = YES;
        [self dealProvinceData:[dic objectForKey:@"result"]];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取城市信息失败"];
    }];
}



- (void)searchProvince:(NSString *)keyWord{
    NSMutableArray * tempArray = [NSMutableArray array];
    [provinceDic enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSMutableArray * obj, BOOL * _Nonnull stop) {
        for (NSDictionary * dic in obj) {
            NSString * name = [dic objectForKey:@"Name"];
            if ([name containsString:keyWord]) {
                [tempArray addObject:dic];
            }
        }
        
    }];
    searchResultArray = [tempArray copy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchResultTable reloadData];
    });
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.tableView reloadData];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getCurrentProvince];
    });

}

- (void)getCurrentProvince {
    if (self.locationDic == nil) {
        return;
    }
    NSString * provinceName = [self.locationDic objectForKey:@"province"];
    
    [provinceDic enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSMutableArray * obj, BOOL * _Nonnull stop) {
        for (NSDictionary * dic in obj) {
            NSString * name = [dic objectForKey:@"Name"];
            if ([name isEqualToString:provinceName]) {
                currentProvinceDic = dic;
               *stop = YES;
            }
        }
    }];

    
}

#pragma mark - ButtonClick
- (IBAction)gobackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchCity:(UIButton *)sender {
    
}

- (IBAction)currentCity:(id)sender {
    if (currentProvinceDic == nil) {
        return;
    }
    
    LDCityViewController * cityVc = [[LDCityViewController alloc] init];
    cityVc.provinceCode = [currentProvinceDic objectForKey:@"Code"];
    cityVc.provinceName = [currentProvinceDic objectForKey:@"Name"];
    
    cityVc.city = self.locationResult;
    cityVc.searchLocation = self.isSearch;
    cityVc.destinationVc = self.destinationVc;
    
    [self.navigationController pushViewController:cityVc animated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.searchResultTable]) {
        return 1;
    }
    return provinceIndex.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    if ([tableView isEqual:self.searchResultTable]) {
        return searchResultArray.count;
    }
    NSString * index = provinceIndex[section];
    NSMutableArray * arr = [provinceDic objectForKey:index];
    return arr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    UILabel * cityLabel = (UILabel *)[cell viewWithTag:2];
    if ([tableView isEqual:self.searchResultTable]) {
        NSDictionary * dic = searchResultArray[indexPath.row];
        cityLabel.text = [dic objectForKey:@"Name"];
    }
    else
    {
        NSString * index = provinceIndex[indexPath.section];
        NSMutableArray * arr = [provinceDic objectForKey:index];
        NSDictionary * dic = arr[indexPath.row];
        cityLabel.text = [dic objectForKey:@"Name"];

    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchResultTable]) {
        return 0;
    }
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
    label.text = provinceIndex[section];

    [view addSubview:label];
    return view;
}


//返回标题索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.searchResultTable]) {
        return @[];
    }
     return provinceIndex;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic;
    if ([tableView isEqual:self.tableView]) {
        NSString * index = provinceIndex[indexPath.section];
        NSMutableArray * arr = [provinceDic objectForKey:index];
        dic = arr[indexPath.row];
     
    }
    else
    {
        dic = searchResultArray[indexPath.row];
        
    }
    
    LDCityViewController * cityVc = [[LDCityViewController alloc] init];
    cityVc.provinceCode = [dic objectForKey:@"Code"];
    cityVc.provinceName = [dic objectForKey:@"Name"];
    cityVc.city = self.locationResult;
    cityVc.searchLocation = self.isSearch;
    cityVc.destinationVc = self.destinationVc;
    
    [self.navigationController pushViewController:cityVc animated:YES];
    
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
    [self searchProvince:textField.text];

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
