//
//  AdressCityVC.m
//  
//
//  Created by luojiao  on 16/3/23.
//
//

#import "AdressCityVC.h"
#import "FRUtils.h"
#import "CityTableViewCell.h"

@interface AdressCityVC ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation AdressCityVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self.searchButton setBackgroundImage:[FRUtils resizeImageWithImageName:@"ic_search_a"] forState:UIControlStateNormal];
    self.tableView.sectionIndexColor = [UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1];
//    self.tableView.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 27;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string = @"cityCell";
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CityTableViewCell" owner:self options:nil][0];
    }
    UILabel * cityLabel = (UILabel *)[cell viewWithTag:2];
    cityLabel.text = @"111";
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
    NSArray *array = @[@"热门城市", @"A", @"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    label.text = array[section];
    [view addSubview:label];
    return view;
}


//返回标题索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[ @"热门",@"A", @"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
