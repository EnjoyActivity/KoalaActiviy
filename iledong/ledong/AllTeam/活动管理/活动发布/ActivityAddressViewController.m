//
//  ActivityAddressViewController.m
//  ledong
//
//  Created by liuxu on 16/5/24.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ActivityAddressViewController.h"

#define kCell           @"cell"

@interface ActivityAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableDictionary* dataDict;
@property (nonatomic, copy)completeActivityAddressInfo block;

@end

@implementation ActivityAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.dataDict = [NSMutableDictionary dictionary];
    [self setupNavigationBar];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"活动地点";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, APP_WIDTH, APP_HEIGHT-64)];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F3F4);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell];

    UIView* view = [[UIView alloc]init];
    self.tableView.tableFooterView = view;
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    
    UILabel* infoLabel = (UILabel*)[cell.contentView viewWithTag:100];
    if (!infoLabel) {
        infoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        infoLabel.font = [UIFont systemFontOfSize:14.0];
        infoLabel.tag = 100;
        infoLabel.textColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:infoLabel];
    }
    infoLabel.text = @"未设置";
    [infoLabel sizeToFit];
    infoLabel.frame = CGRectMake(APP_WIDTH-infoLabel.frame.size.width-30, 0, infoLabel.frame.size.width, infoLabel.frame.size.height);
    infoLabel.center = CGPointMake(infoLabel.center.x, cell.contentView.bounds.size.height/2);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"省";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"市";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"区";
    }
    else if (indexPath.row == 3) {
        UIButton* btn = [[UIButton alloc]initWithFrame:cell.contentView.bounds];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        infoLabel.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
    }
    else if (indexPath.row == 1) {
        
    }
    else if (indexPath.row == 2) {
        
    }
}

- (void)btnClicked {
    if (self.block) {
        self.block(self.dataDict);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setCompleteActivityAddressInfo:(completeActivityAddressInfo)block {
    self.block = block;
}

@end
