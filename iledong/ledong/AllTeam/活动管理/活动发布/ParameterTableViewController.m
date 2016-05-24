//
//  ParameterTableViewController.m
//  ledong
//
//  Created by liuxu on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ParameterTableViewController.h"

#define kCell       @"cell"

@interface ParameterTableViewController ()

@property (nonatomic, copy)selectCellBlock block;
@property (nonatomic, strong)NSMutableArray* datas;

@end

@implementation ParameterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = [NSMutableArray array];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell];
    self.navigationItem.title = self.vcTitle;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    [self requestActivityData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];
    
    NSDictionary* dict = self.datas[indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"ClassName"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.block) {
        NSDictionary* dict = self.datas[indexPath.row];
        self.block(dict);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setSelectCellBlock:(selectCellBlock)block {
    self.block = block;
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestActivityData {
    NSString * token =[HttpClient getTokenStr];
    NSDictionary * dic = @{@"token":token};
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [requestManager GET:@"ActivityClass/GetActivityClass" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * resultDic = (NSDictionary *)responseObject;
        NSInteger code = [resultDic[@"code"] integerValue];
        if (code != 0) {
            [Dialog alert:@"查询失败！"];
            return;
        }
        self.datas = [resultDic[@"result"] copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [Dialog alert:@"查询失败！"];
    }];
}

@end
