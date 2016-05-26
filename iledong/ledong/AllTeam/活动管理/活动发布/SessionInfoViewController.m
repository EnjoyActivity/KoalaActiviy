//
//  SessionInfoViewController.m
//  ledong
//
//  Created by liuxu on 16/5/24.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "SessionInfoViewController.h"
#import "CHDatePickerView.h"

#define kCell1      @"cell"

@interface SessionInfoViewController ()<UITableViewDelegate,UITableViewDataSource> {
    @private
    CGFloat _mainScrollViewContentSizeheight;
    CGFloat _mainScrollViewoffsetY;
    BOOL _keyboardShow;
    BOOL _scrollViewDidScroll;
}

@property (nonatomic, copy)completeBlock block;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)UITextField* planCountTextField;
@property (nonatomic, strong)UITextField* maxCountTextField;
@property (nonatomic, strong)UITextField* minCountTextField;
@property (nonatomic, strong)UITextField* remarkTextField;
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
    [self setupTableView];
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [self addKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeKeyboardNotification];
}

- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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
    return 9;
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
        cell.textLabel.text = @"活动场馆";
    }
    else if (indexPath.section == 1) {
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
    else if (indexPath.section == 2) {
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
    else if (indexPath.section == 3) {
        self.planCountTextField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-200-15, 5, 200, 40)];
        self.planCountTextField.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:self.planCountTextField];
        self.planCountTextField.textAlignment = NSTextAlignmentRight;
        cell.textLabel.text = @"计划报名数";
        self.planCountTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.planCountTextField.placeholder = @"请输入计划报名数";
        if (self.dataDict)
            self.planCountTextField.text = [NSString stringWithFormat:@"%d", ((NSNumber*)[self.dataDict objectForKey:@"planCount"]).intValue];
    }
    else if (indexPath.section == 4) {
        cell.textLabel.text = @"活动报名数上限";
        self.maxCountTextField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-200-15, 5, 200, 40)];
        self.maxCountTextField.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:self.maxCountTextField];
        self.maxCountTextField.textAlignment = NSTextAlignmentRight;
        self.maxCountTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.maxCountTextField.placeholder = @"请输入活动报名数上限";
        if (self.dataDict)
            self.maxCountTextField.text = [NSString stringWithFormat:@"%d", ((NSNumber*)[self.dataDict objectForKey:@"maxCount"]).intValue];
    }
    else if (indexPath.section == 5) {
        cell.textLabel.text = @"活动报名数下限";
        self.minCountTextField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-200-15, 5, 200, 40)];
        self.minCountTextField.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:self.minCountTextField];
        self.minCountTextField.textAlignment = NSTextAlignmentRight;
        self.minCountTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.minCountTextField.placeholder = @"请输入活动报名数下限";
        if (self.dataDict)
            self.minCountTextField.text = [NSString stringWithFormat:@"%d", ((NSNumber*)[self.dataDict objectForKey:@"minCount"]).intValue];
    }
    else if (indexPath.section == 6) {
        self.activityCostTextField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-200-15, 5, 200, 40)];
        self.activityCostTextField.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:self.activityCostTextField];
        self.activityCostTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.activityCostTextField.textAlignment = NSTextAlignmentRight;
        cell.textLabel.text = @"活动费用";
        self.activityCostTextField.placeholder = @"请输入活动费用";
        if (self.dataDict)
            self.activityCostTextField.text = [self.dataDict objectForKey:@"activityCost"];
    }
    else if (indexPath.section == 7) {
        self.remarkTextField = [[UITextField alloc]initWithFrame:CGRectMake(APP_WIDTH-200-15, 5, 200, 40)];
        self.remarkTextField.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:self.remarkTextField];
        self.remarkTextField.textAlignment = NSTextAlignmentRight;
        cell.textLabel.text = @"活动备注";
        self.remarkTextField.hidden = NO;
        self.remarkTextField.placeholder = @"请输入活动备注";
        if (self.dataDict)
            self.remarkTextField.text = [self.dataDict objectForKey:@"activityRemark"];
    }
    else if (indexPath.section == 8) {
        btn.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 || indexPath.section == 2) {
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
            
            if (indexPath.section == 1)
                self.beginTime = dateStr;
            else if (indexPath.section == 2)
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
    if (_scrollViewDidScroll)
        return;
    [self.view endEditing:YES];
}

- (void)btnClicked {
    [self.view endEditing:YES];
    if (self.block) {
        if (self.planCountTextField.text.length == 0 ||
            self.maxCountTextField.text.length == 0 ||
            self.minCountTextField.text.length == 0 ||
            self.remarkTextField.text.length == 0 ||
            self.activityCostTextField.text.length == 0 ||
            self.beginTime.length == 0 ||
            self.endTime.length == 0) {
            [Dialog simpleToast:@"请填写相关参数！" withDuration:1.5];
            return;
        }
        
        self.dataDict = [NSMutableDictionary dictionary];
        [self.dataDict setValue:self.beginTime forKey:@"beginTime"];
        [self.dataDict setValue:self.endTime forKey:@"endTime"];
        [self.dataDict setValue:
            @{@"provinceCode":@"510000", @"cityCode":@"510100", @"areaCode":@"510104",
                @"mapX":@"", @"mapY":@"", @"placeName":@"成都市体育馆", @"Address":@"成都市顺城街2号"} forKey:@"activityVenue"];

        [self.dataDict setValue:self.activityCostTextField.text forKey:@"activityCost"];
        [self.dataDict setValue:self.planCountTextField.text forKey:@"planCount"];
        [self.dataDict setValue:self.maxCountTextField.text forKey:@"maxCount"];
        [self.dataDict setValue:self.minCountTextField.text forKey:@"minCount"];
        [self.dataDict setValue:self.remarkTextField.text forKey:@"remark"];
        
        self.block(self.isModify, self.dataDict);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setPreDict:(NSDictionary*)dict {
    self.dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [self.tableView reloadData];
}

- (void)keyboardWillShow:(NSNotification *) notif {
    if (_keyboardShow)
        return;
    _scrollViewDidScroll = YES;
    _mainScrollViewContentSizeheight = self.tableView.contentSize.height;
    _mainScrollViewoffsetY = self.tableView.contentOffset.y;
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    CGFloat y = _mainScrollViewoffsetY+keyboardSize.height-80;
    CGFloat sizeHeigth = 0;
    sizeHeigth = _mainScrollViewContentSizeheight+keyboardSize.height;
    _keyboardShow = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.tableView setContentSize:CGSizeMake(APP_WIDTH, sizeHeigth)];
        [self.tableView setContentOffset:CGPointMake(0, y) animated:YES];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _scrollViewDidScroll = NO;
        });
    }];
}

- (void)keyboardDidHide:(NSNotification *) notif {
    [UIView animateWithDuration:0.5 animations:^{
        [self.tableView setContentSize:CGSizeMake(APP_WIDTH, _mainScrollViewContentSizeheight)];
        [self.tableView setContentOffset:CGPointMake(0, _mainScrollViewoffsetY) animated:YES];
        _keyboardShow = NO;
    } completion:nil];
}

@end
