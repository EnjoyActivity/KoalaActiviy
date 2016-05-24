//
//  SessionInfoViewController.m
//  ledong
//
//  Created by liuxu on 16/5/24.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "SessionInfoViewController.h"
#import "CHDatePickerView.h"

#define kCell1      @"cell1"

@interface SessionInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy)completeBlock block;
@property (nonatomic, strong)UITableView* tableView;

@end

@implementation SessionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupTableView];
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, APP_WIDTH, APP_HEIGHT-64)];
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F3F4);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell1];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"场次信息";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIView* view = [[UIView alloc]init];
    self.tableView.tableFooterView = view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0)
        return 10;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCell1 forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-200-15, 5, 200, 40)];
    textField.font = [UIFont systemFontOfSize:14.0];
    [cell.contentView addSubview:textField];
    textField.hidden = YES;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.textAlignment = NSTextAlignmentRight;
    
    UIButton* btn = [[UIButton alloc]initWithFrame:cell.contentView.bounds];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn];
    btn.hidden = YES;
    
    UILabel* timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    timeLabel.font = [UIFont systemFontOfSize:14.0];
    [cell.contentView addSubview:timeLabel];
    timeLabel.tag = 100;
    timeLabel.hidden = YES;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"活动场馆";
        textField.hidden = NO;
        textField.placeholder = @"请输入活动场馆";
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = @"活动地点";
        textField.hidden = NO;
        textField.placeholder = @"请输入活动地点";
    }
    else if (indexPath.section == 2) {
        cell.textLabel.text = @"报名开始时间";
        timeLabel.hidden = NO;
    }
    else if (indexPath.section == 3) {
        cell.textLabel.text = @"报名结束时间";
        timeLabel.hidden = NO;
    }
    else if (indexPath.section == 4) {
        cell.textLabel.text = @"组织者";
    }
    else if (indexPath.section == 5) {
        cell.textLabel.text = @"活动费用";
        textField.hidden = NO;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"请输入活动费用";
    }
    else if (indexPath.section == 6) {
        btn.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 || indexPath.section == 3) {
        CHDatePickerView* datePickView = [[CHDatePickerView alloc]initWithSuperView:self.tableView completeDateInt:nil completeDateStr:^(NSString *str) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            NSDate *date = [formatter dateFromString:str];
            [formatter setDateFormat:@"yyyy-MM-dd  HH:mm"];
            NSString *dateStr = [formatter stringFromDate:date];
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            UILabel* label = (UILabel*)[cell.contentView viewWithTag:100];
            label.text = dateStr;
            [label sizeToFit];
            label.frame = CGRectMake(APP_WIDTH-label.frame.size.width-15, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
            label.center = CGPointMake(label.center.x, cell.contentView.bounds.size.height/2);
        }];
        [self.tableView addSubview:datePickView];
    }
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCompleteBlock:(completeBlock)block {
    self.block = block;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)btnClicked {
    if (self.block) {
        self.block(@{});
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
