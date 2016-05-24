//
//  LDActivityViewController.m
//  ledong
//
//  Created by 郑红 on 5/19/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import "LDActivityViewController.h"
#import "LDActivityTableViewCell.h"

static NSString * const locationIdentifier = @"LocationCell";

@interface LDActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentButton;
    UITableView * activityTableView;
    NSMutableArray * activityArray;
    NSArray * locationArray;
    NSInteger currentPage;
    BOOL changeActivity;
    
}
@property (strong, nonatomic) IBOutlet UIButton *activityButton;
@property (nonatomic, strong) UIView * filterView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic,strong) UITableView * locationTableview;

@end

@implementation LDActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage = 1;

    if (self.activityId == 0) {
        [self.locationTableview setHidden:NO];
        changeActivity = YES;
    }
    NSDictionary * dic = @{
                           @"ActivityClassId":[NSNumber numberWithInteger:self.activityId],
                           @"ReadFlag" :[NSNumber numberWithInt:1]
                           };
    [self requestActivityData:currentPage parameter:dic];
    locationArray = @[@"全部地区",@"附近",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去"];
    [self setUpFilterView];
    [self setUpUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NetWork
- (void)requestActivityData:(NSInteger)pageIndex parameter:(NSDictionary *)parameter{
    NSString * token = [HttpClient getTokenStr];
    NSMutableDictionary * parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setValue:token forKey:@"token"];
    [parameterDic setValue:[NSNumber numberWithInt:10] forKey:@"PageSize"];
    [parameterDic setValue:[NSNumber numberWithInteger:pageIndex] forKey:@"page"];
    [parameterDic setValuesForKeysWithDictionary:parameter];
    
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager POST:@"Activity/QueryActivitys" parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * resultDic = (NSDictionary *)responseObject;
        NSInteger code = [resultDic[@"code"] integerValue];
        if (code != 0) {
            return ;
        }
        NSArray * array = resultDic[@"result"];
        if (pageIndex == 1) {
            activityArray = [array copy];
        }
        else {
            [activityArray addObjectsFromArray:array];
        }
        currentPage ++;
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityTableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}


#pragma mark - UitableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.locationTableview]) {
        return changeActivity ? _activityClassArray.count:locationArray.count;
    }
    return activityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.locationTableview]) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:locationIdentifier forIndexPath:indexPath];
        UILabel * label = (UILabel *)[cell viewWithTag:2];
        if (changeActivity) {
            label.text = [_activityClassArray[indexPath.row] valueForKey:@"ClassName"];
        }
        else {
            label.text = locationArray[indexPath.row];
        }
        return cell;
    }
    LDActivityTableViewCell * cell = (LDActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    
    NSDictionary * dic = activityArray[indexPath.row];
    [cell.adImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"Cover"]] placeholderImage:[UIImage imageNamed:@"img_1@2x"]];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"Cover"]] placeholderImage:[UIImage imageNamed:@"user01_44@2x"]];
    cell.activityPrice.text = [NSString stringWithFormat:@"%@-%@",dic[@"EntryMoneyMin"],dic[@"EntryMoneyMax"]];
    cell.activityName.text = dic[@"Title"];
    cell.activityOwer.text = dic[@"ConstitutorName"];
    cell.activityDetail.text = [NSString stringWithFormat:@"%@",dic[@"ClassName"]];
    
//    cell.adImageView.image = [UIImage imageNamed:@"img_1@2x"];
//    cell.headImageView.image = [UIImage imageNamed:@"user01_44@2x"];
    return cell;
    
}


#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.locationTableview]) {
        if (changeActivity) {
            [self changeActivity:indexPath.row];
        }
    }
    
}

- (void)changeActivity:(NSInteger)row {
    self.activityId = [[_activityClassArray[row] objectForKey:@"Id"] integerValue];
    NSString * titleTemp = [_activityClassArray[row] objectForKey:@"ClassName"];
    [self.activityButton setTitle:[NSString stringWithFormat:@"精彩活动 %@",titleTemp] forState:UIControlStateNormal];
    [self.activityButton setSelected:NO];
    NSDictionary * dic= @{
                          @"ActivityClassId":[NSNumber numberWithInteger:self.activityId]
                          };
    currentPage = 1;
    [self.locationTableview setHidden:YES];
    [self requestActivityData:currentPage parameter:dic];
}

- (void)filterUserArea:(NSInteger)row {
    //ProvinceCode
    //CityCode
    //AreaCode
    NSDictionary * dic= @{
                          @"ActivityClassId":[NSNumber numberWithInteger:self.activityId],
                          @"CityCode" :@"1111"
                          };
    currentPage = 1;
    [self.locationTableview setHidden:YES];
    [self requestActivityData:currentPage parameter:dic];
    
}
#pragma mark - ButtonAction
- (IBAction)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)activityButtonCicked:(UIButton *)sender {
    BOOL isSeleted = sender.isSelected;
    if (isSeleted) {
        [self.locationTableview setHidden:YES];;
        [sender setSelected:NO];
    }
    else {
        changeActivity = YES;
        [sender setSelected:YES];
        [self.locationTableview setHidden:NO];
        [self.locationTableview reloadData];
    }
  
}

- (void)filterButtonClicked:(UIButton *)sender {
    [self.activityButton setSelected:NO];
    
    UIButton * button = (UIButton *)[self.filterView viewWithTag:currentButton];
    [button setSelected:NO];
    currentButton = sender.tag;
    [sender setSelected:YES];
    
    switch (sender.tag) {
        case 1:
        {
            NSDictionary * dic = @{
                                   @"ActivityClassId":[NSNumber numberWithInteger:self.activityId],
                                   @"ReadFlag" :[NSNumber numberWithInt:1]
                                   };
            currentPage = 1;
            [self requestActivityData:currentPage parameter:dic];
            [self.locationTableview setHidden:YES];
        }
            break;
        case 2:
        {
            NSDictionary * dic = @{
                                   @"ActivityClassId":[NSNumber numberWithInteger:self.activityId],
                                   };
            currentPage = 1;
            [self requestActivityData:currentPage parameter:dic];
            [self.locationTableview setHidden:YES];
        }
            break;
        case 3:
        {
            [self thisWeakActivity];
        }
            break;
        case 4:
        {
            changeActivity = false;
            [self.locationTableview setHidden:NO];;
            [self.locationTableview reloadData];
        }
            break;
    }
    
}


- (void)thisWeakActivity {
    NSDate * currentDate = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDateComponents * comp = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:currentDate];
    NSInteger weak = comp.weekday-1;
    
    NSDate * monday = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:1-weak toDate:currentDate options:0];
    NSDate * sunday =[[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:7-weak toDate:currentDate options:0];
    
    NSString * mondayStr = [formatter stringFromDate:monday];
    NSString * sundayStr = [formatter stringFromDate:sunday];
    
    NSDictionary * dic = @{
                           @"ActivityClassId":[NSNumber numberWithInteger:self.activityId],
                           @"time1" :mondayStr,
                           @"time2" :sundayStr
                           };
    currentPage = 1;
    [self requestActivityData:currentPage parameter:dic];
    
    [self.locationTableview setHidden:YES];
}
#pragma mark - UI

- (void)setUpUI {
    [self.backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [self.backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
    
    NSString * acTitle = [NSString stringWithFormat:@"精彩活动 %@ ",self.activityClassName];
    [self.activityButton setTitle:acTitle forState:UIControlStateNormal];
    
    [self.activityButton setImage:[UIImage imageNamed:@"ic_triangle_grey@2x"] forState:UIControlStateNormal];
    [self.activityButton setImage:[UIImage imageNamed:@"ic_triangle_grey_up@2x"] forState:UIControlStateSelected];
    
    self.activityButton.transform = CGAffineTransformMakeScale(-1,1);
    self.activityButton.titleLabel.transform = CGAffineTransformMakeScale(-1, 1);
    self.activityButton.imageView.transform = CGAffineTransformMakeScale(-1, 1);
    
    activityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, APP_WIDTH, APP_HEIGHT - 104) style:UITableViewStylePlain];
    activityTableView.delegate = self;
    activityTableView.dataSource = self;
    activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [activityTableView registerNib:[UINib nibWithNibName:@"LDActivityTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"activityCell"];
    CGFloat height = APP_WIDTH*9/16;
    NSString * sysVersion = [UIDevice currentDevice].systemVersion;
    if ([sysVersion floatValue] < 8.0) {
        activityTableView.rowHeight = height + 110;
    } else {
        activityTableView.estimatedRowHeight = 280;
        activityTableView.rowHeight = UITableViewAutomaticDimension;
    }
    [self.view addSubview:activityTableView];
    
    [self.view addSubview:self.locationTableview];
}

- (void)setUpFilterView{
    CGFloat width = (APP_WIDTH - 150-36)/3;
    currentButton = 1;
    
    UIButton * buttonOne = [self buttonWithFrame:CGRectMake(18, 5, 30, 30) title:@"热门" tag:1];
    UIButton * buttonTwo = [self buttonWithFrame:CGRectMake(18+width+30, 5, 30, 30) title:@"全部" tag:2];
    UIButton * buttonThr = [self buttonWithFrame:CGRectMake(18+width+width+60, 5, 30, 30) title:@"本周" tag:3];
    UIButton * buttonFou = [self buttonWithFrame:CGRectMake(APP_WIDTH-60-18, 5, 60, 30) title:@"全部地区 " tag:4];
    [buttonFou setImage:[UIImage imageNamed:@"ic_triangle_grey@2x"] forState:UIControlStateNormal];
    [buttonFou setImage:[UIImage imageNamed:@"ic_triangle_grey_up@2x"] forState:UIControlStateSelected];
    buttonFou.transform = CGAffineTransformMakeScale(-1,1);
    buttonFou.titleLabel.transform = CGAffineTransformMakeScale(-1, 1);
    buttonFou.imageView.transform = CGAffineTransformMakeScale(-1, 1);
    
    [buttonOne setSelected:YES];
    
    [self.filterView addSubview:buttonOne];
    [self.filterView addSubview:buttonTwo];
    [self.filterView addSubview:buttonThr];
    [self.filterView addSubview:buttonFou];
    
    [self.view addSubview:self.filterView];
}

- (UIView *)filterView {
    if (!_filterView) {
        _filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, APP_WIDTH, 40)];
        _filterView.backgroundColor = [UIColor whiteColor];
    }
    return _filterView;
}

- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGB(227.0, 26.0, 26.0, 1.0) forState:UIControlStateSelected];
    [button setTitleColor:RGB(153.0, 153.0, 153.0, 153.0) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    return button;
}


- (UITableView *)locationTableview {
    if (!_locationTableview) {
        _locationTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, APP_WIDTH, APP_HEIGHT - 104) style:UITableViewStylePlain];
        _locationTableview.backgroundColor = [UIColor whiteColor];
        _locationTableview.delegate = self;
        _locationTableview.dataSource = self;
        _locationTableview.rowHeight = 37;
        _locationTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _locationTableview.hidden = YES;
        [_locationTableview registerNib:[UINib nibWithNibName:@"ActivityLocationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:locationIdentifier];
        
    }
    return  _locationTableview;
}

@end
