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
@property (nonatomic, strong)UITextField* activityVenueTextField;
@property (nonatomic, strong)UITextField* activitySiteTextField;
@property (nonatomic, strong)UITextField* organizersTextField;
@property (nonatomic, strong)UITextField* activityCostTextField;
@property (nonatomic, strong)NSMutableDictionary* dataDict;
@property (nonatomic, strong)NSString* beginTime;
@property (nonatomic, strong)NSString* endTime;
@property (nonatomic, assign)BOOL isModify;

@end

@implementation SessionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.dataDict = [NSMutableDictionary dictionary];
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
        self.activityVenueTextField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-200-15, 5, 200, 40)];
        self.activityVenueTextField.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:self.activityVenueTextField];
        self.activityVenueTextField.hidden = YES;
        self.activityVenueTextField.keyboardType = UIKeyboardTypeDefault;
        self.activityVenueTextField.textAlignment = NSTextAlignmentRight;
        cell.textLabel.text = @"活动场馆";
        self.activityVenueTextField.hidden = NO;
        self.activityVenueTextField.placeholder = @"请输入活动场馆";
        if (self.dataDict)
            self.activityVenueTextField.text = [self.dataDict objectForKey:@"activityVenue"];
    }
    else if (indexPath.section == 1) {
        self.activitySiteTextField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-200-15, 5, 200, 40)];
        self.activitySiteTextField.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:self.activitySiteTextField];
        self.activitySiteTextField.hidden = YES;
        self.activitySiteTextField.keyboardType = UIKeyboardTypeDefault;
        self.activitySiteTextField.textAlignment = NSTextAlignmentRight;
        cell.textLabel.text = @"活动地点";
        self.activitySiteTextField.hidden = NO;
        self.activitySiteTextField.placeholder = @"请输入活动地点";
        if (self.dataDict)
            self.activitySiteTextField.text = [self.dataDict objectForKey:@"activitySite"];
    }
    else if (indexPath.section == 2) {
        cell.textLabel.text = @"报名开始时间";
        timeLabel.hidden = NO;
        if (self.dataDict) {
            timeLabel.text = [self.dataDict objectForKey:@"beginTime"];
            [timeLabel sizeToFit];
            timeLabel.frame = CGRectMake(APP_WIDTH-timeLabel.frame.size.width-15, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height);
            timeLabel.center = CGPointMake(timeLabel.center.x, cell.contentView.bounds.size.height/2);
            self.beginTime = [self.dataDict objectForKey:@"beginTime"];
        }
    }
    else if (indexPath.section == 3) {
        cell.textLabel.text = @"报名结束时间";
        timeLabel.hidden = NO;
        if (self.dataDict) {
            timeLabel.text = [self.dataDict objectForKey:@"endTime"];
            [timeLabel sizeToFit];
            timeLabel.frame = CGRectMake(APP_WIDTH-timeLabel.frame.size.width-15, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height);
            timeLabel.center = CGPointMake(timeLabel.center.x, cell.contentView.bounds.size.height/2);
            self.endTime = [self.dataDict objectForKey:@"endTime"];
        }
    }
    else if (indexPath.section == 4) {
        self.organizersTextField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-200-15, 5, 200, 40)];
        self.organizersTextField.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:self.organizersTextField];
        self.organizersTextField.hidden = YES;
        self.organizersTextField.textAlignment = NSTextAlignmentRight;
        cell.textLabel.text = @"组织者";
        self.organizersTextField.hidden = NO;
        self.organizersTextField.keyboardType = UIKeyboardTypeDefault;
        self.organizersTextField.placeholder = @"请输入活动组织者";
        if (self.dataDict)
            self.organizersTextField.text = [self.dataDict objectForKey:@"organizers"];
    }
    else if (indexPath.section == 5) {
        self.activityCostTextField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-200-15, 5, 200, 40)];
        self.activityCostTextField.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:self.activityCostTextField];
        self.activityCostTextField.hidden = YES;
        self.activityCostTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.activityCostTextField.textAlignment = NSTextAlignmentRight;
        cell.textLabel.text = @"活动费用";
        self.activityCostTextField.hidden = NO;
        self.activityCostTextField.placeholder = @"请输入活动费用";
        if (self.dataDict)
            self.activityCostTextField.text = [self.dataDict objectForKey:@"activityCost"];
    }
    else if (indexPath.section == 6) {
        btn.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 || indexPath.section == 3) {
        [self.view endEditing:YES];
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
            
            if (indexPath.section == 2)
                self.beginTime = dateStr;
            else if (indexPath.section == 3)
                self.endTime = dateStr;
        }];
        [self.tableView addSubview:datePickView];
    }
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCompleteBlock:(completeBlock)block isModify:(BOOL)isModify {
    self.block = block;
    self.isModify = isModify;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)btnClicked {
    [self.view endEditing:YES];
    if (self.block) {
        if (self.activityVenueTextField.text.length == 0 ||
            self.activitySiteTextField.text.length == 0 ||
            self.organizersTextField.text.length == 0 ||
            self.activityCostTextField.text.length == 0 ||
            self.beginTime.length == 0 ||
            self.endTime.length == 0) {
            [Dialog simpleToast:@"请填写相关参数！" withDuration:1.5];
            return;
        }
        
        self.dataDict = [NSMutableDictionary dictionary];
        [self.dataDict setValue:self.beginTime forKey:@"beginTime"];
        [self.dataDict setValue:self.endTime forKey:@"endTime"];
        [self.dataDict setValue:self.activityVenueTextField.text forKey:@"activityVenue"];
        [self.dataDict setValue:self.activitySiteTextField.text forKey:@"activitySite"];
        [self.dataDict setValue:self.organizersTextField.text forKey:@"organizers"];
        [self.dataDict setValue:self.activityCostTextField.text forKey:@"activityCost"];
        self.block(self.isModify, self.dataDict);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setPreDict:(NSDictionary*)dict {
    self.dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [self.tableView reloadData];
}

@end
