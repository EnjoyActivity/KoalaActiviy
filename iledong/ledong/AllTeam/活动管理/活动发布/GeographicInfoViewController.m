//
//  GeographicInfoViewController.m
//  ledong
//
//  Created by liuxu on 16/5/26.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "GeographicInfoViewController.h"

#define kCell @"cell"

@interface GeographicInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableArray* datas;
@property (nonatomic, copy)completeSelect block;

@end

@implementation GeographicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];
    self.datas = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, APP_WIDTH, APP_HEIGHT-64)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell];
    [self.view addSubview:self.tableView];
    
    [self queryData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupNavigationBar {
    if (self.type == GeographicTypeProvinces)
        self.navigationItem.title = @"请选择省";
    else if (self.type == GeographicTypeCity)
        self.navigationItem.title = @"请选择市";
    else
        self.navigationItem.title = @"请选择区";
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];
    
    NSDictionary* dict = self.datas[indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"Name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.block) {
        NSDictionary* dict = self.datas[indexPath.row];
        self.block(self.type, dict);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setSelectBlock:(completeSelect)block {
    self.block = block;
}

- (void)queryData {
    NSString *urlStr = nil;
    if (self.type == GeographicTypeProvinces)
        urlStr = [API_BASE_URL stringByAppendingString:API_QUERY_PROVINCES_URL];
    else if (self.type == GeographicTypeCity)
        urlStr = [NSString stringWithFormat:@"%@%@%ld",API_BASE_URL, API_QUERY_CITY_URL, self.preCode];
    else if (self.type == GeographicTypeAreas)
        urlStr = [NSString stringWithFormat:@"%@%@%ld",API_BASE_URL, API_QUERY_AREAS_URL, self.preCode];

    [HttpClient JSONDataWithUrl:urlStr parameters:nil success:^(id json) {
        NSDictionary* dict = (NSDictionary*)json;
        NSNumber* codeNum = [dict objectForKey:@"code"];
        if (codeNum.intValue == 0) {
            self.datas = [dict objectForKey:@"result"];
            [self.tableView reloadData];
        }
    } fail:^{
        [Dialog simpleToast:@"获取地理信息失败！" withDuration:1.5];
    }];
}

@end
