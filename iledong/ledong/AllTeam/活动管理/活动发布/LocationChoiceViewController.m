//
//  LocationChoiceViewController.m
//  ledong
//
//  Created by liuxu on 16/5/26.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "LocationChoiceViewController.h"

#define kCell   @"cell"

@interface LocationChoiceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableArray* datas;
@property (nonatomic, strong)UIView* searchView;
@property (nonatomic, strong)UITextField* textField;
@property (nonatomic, copy)completeLocationChoice block;

@end

@implementation LocationChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.datas = [NSMutableArray array];
    NSDictionary* dict = [FRUtils getAddressInfo];
    if (dict)
        [self.datas addObject:dict];

    [self setupNavigationBar];
    [self setupSearchView];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)setupNavigationBar {
    self.navigationItem.title = @"选择位置";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)setupSearchView {
    self.searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, APP_WIDTH, 40)];
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, APP_WIDTH-30-60, self.searchView.bounds.size.height)];
    self.textField.placeholder = @"搜索地区";
    self.textField.font = [UIFont systemFontOfSize:14.0];
    [self.searchView addSubview:self.textField];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(APP_WIDTH-15-50, 0, 65, self.searchView.bounds.size.height)];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.searchView addSubview:btn];
    [btn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchView];
    
    self.searchView.backgroundColor = UIColorFromRGB(0xF2F3F4);
}

- (void)setupTableView {
    CGFloat y = self.searchView.frame.size.height+self.searchView.frame.origin.y+5;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, APP_WIDTH, APP_HEIGHT-y)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell];
    
    UIView* view = [[UIView alloc]init];
    [self.tableView setTableFooterView:view];
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
    cell.textLabel.text = [dict objectForKey:@"name"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dict = self.datas[indexPath.row];
    if (self.block) {
        self.block(dict);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)searchBtnClicked {
    NSString* text = self.textField.text;

    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_SEARCH_ADDRESS_URL];
    NSDictionary *dic = @{@"keyword":text};
    __weak typeof(self)weakSelf = self;
    [HttpClient postJSONWithUrl:urlStr parameters:dic success:^(id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSNumber* codeNum = [dict objectForKey:@"code"];
        if (codeNum.intValue == 0) {
            NSArray* array = [dic objectForKey:@"result"];
            [weakSelf.datas addObjectsFromArray:array];
            [weakSelf.tableView reloadData];
        }
    } fail:^{
        [Dialog simpleToast:@"查询失败！" withDuration:1.5];
    }];
}

- (void)setCompleteBlock:(completeLocationChoice)block {
    self.block = block;
}

@end
