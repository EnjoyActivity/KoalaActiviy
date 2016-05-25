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


@interface AdressCityVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    LDLocationManager * location;
    NSMutableDictionary * cityDic;
    NSArray * cityIndex;
    
    NSMutableArray * searchResultArray;

}
@property (nonatomic, strong) UITableView * searchResultTable;
@end

@implementation AdressCityVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    cityDic = [NSMutableDictionary dictionaryWithDictionary:[self cityData]];
    
    [self.view addSubview:self.searchResultTable];
    
    
    
    [self.searchButton setBackgroundImage:[FRUtils resizeImageWithImageName:@"ic_search_a"] forState:UIControlStateNormal];
    self.tableView.sectionIndexColor = [UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cityCell"];
    self.searchTextfile.delegate = self;
    [self getLocationInfo];
    searchResultArray = [NSMutableArray array];
    cityIndex = @[@"热门城市", @"A", @"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
}

- (NSDictionary *)cityData {
    NSMutableDictionary * cityDicTemp = [NSMutableDictionary dictionary];
    int a = 65;
    
    NSArray * hotCity = @[@"北京",@"上海",@"广州",@"成都"];
    [cityDicTemp setObject:hotCity forKey:@"热门城市"];
    
    for (int i = 0; i<26; i++) {
        NSString * title = [NSString stringWithFormat:@"%c",a];
        NSMutableArray * cityArrTemp = [NSMutableArray array];
        int random = arc4random()%10;
        for (int j= 0; j<random+1; j++) {
            NSString * strTemp = [NSString stringWithFormat:@"%@City%d",title,j];
            [cityArrTemp addObject:strTemp];
        }
        
        [cityDicTemp setObject:cityArrTemp forKey:title];
        a++;
    }
    return [cityDicTemp copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - location

- (void)getLocationInfo {
//    @WeakObj(self);
    location = [[LDLocationManager alloc] init];
    [location getLocationSuccess:^(NSDictionary * locationInfo) {
//        [selfWeak loadUserLocationInfo:locationInfo];
        NSString * city = locationInfo[@"city"];
        if ([city isEqualToString:@"NULL"]) {
            return ;
        }
        self.adressCity.text = city;
    } fail:^(NSError * error) {
        
    }];
}

//- (void)loadUserLocationInfo:(NSDictionary *)dic {
//    NSString * city = dic[@"city"];
//    double  longitude = [dic[@"longitude"] doubleValue];
//    double latitude = [dic[@"latitude"] doubleValue];
//    NSString * areaCode = dic[@"areaCode"];
//    
//}

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
    return cityIndex.count;//[cityDic allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    if ([tableView isEqual:self.searchResultTable]) {
        return searchResultArray.count;
    }
    NSString * index = cityIndex[section];
// 
//    int sectionValu = (int)section;
//    NSString * str = [NSString stringWithFormat:@"%c",sectionValu+64];
    NSArray * arr = [cityDic objectForKey:index];
    return arr.count;
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
        NSString * index = cityIndex[indexPath.section];
        NSArray * arr = [cityDic objectForKey:index];
        cityLabel.text = arr[indexPath.row];
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
    label.text = cityIndex[section];
    [view addSubview:label];
    return view;
}


//返回标题索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.searchResultTable]) {
        return @[];
    }
    return cityIndex;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * str = cityIndex[indexPath.section];
    NSArray * arr = [cityDic objectForKey:str];
    if (_locationResult != nil) {
        _locationResult(arr[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
