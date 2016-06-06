//
//  LDActivityViewController.m
//  ledong
//
//  Created by 郑红 on 5/19/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import "LDActivityViewController.h"
#import "LDActivityTableViewCell.h"
#import "ActiveDetailViewController.h"
#import "LDMainPageNetWork.h"

static NSString * const locationIdentifier = @"LocationCell";

@interface LDActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentButton;
    UITableView * activityTableView;
    NSMutableArray * activityArray;
    NSArray * locationArray;
    NSInteger currentPage;
    BOOL changeActivity;
    
    NSString * gtime1;
    NSString * gtime2;
    NSString * gareaCode;
    
    
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
    else
    {
//        NSDictionary * dic = @{
//                               @"ActivityClassId":[NSNumber numberWithInteger:self.activityId ],
//                               @"ReadFlag" :[NSNumber numberWithInt:1]
//                               };
        [self requestActivityData:currentPage];
        
    }
    if (self.cityCode) {
        [self getAreaByCityCode:self.cityCode];
    }
    
    [self setUpFilterView];
    [self setUpUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NetWork
- (void)requestActivityData:(NSInteger)pageIndex{
    NSString * token = [HttpClient getTokenStr];
    NSMutableDictionary * parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setValue:token forKey:@"token"];
    [parameterDic setValue:[NSNumber numberWithInt:10] forKey:@"PageSize"];
    [parameterDic setValue:[NSNumber numberWithInteger:pageIndex] forKey:@"page"];
    if (self.activityId != 0) {
        [parameterDic setValue:[NSNumber numberWithInteger:self.activityId] forKey:@"ActivityClassId"];
    }
    if (gtime1.length != 0) {
        [parameterDic setValue:gtime1 forKey:@"time1"];
        [parameterDic setValue:gtime2 forKey:@"time2"];
    }
    if (gareaCode.length != 0) {
        [parameterDic setValue:gareaCode forKey:@"AreaCode"];
    }
    if (self.isHot) {
        [parameterDic setValue:[NSNumber numberWithInt:1] forKey:@"ReadFlag"];
    }
    [[LDMainPageNetWork defaultInstance] postPath:MQueryActivity parameter:parameterDic success:^(id result) {
        NSArray * array = (NSArray *)result;
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
    } fail:^(NSError *error) {
        
    }];
}

- (void)getAreaByCityCode:(NSString *)cityCode {
    if (cityCode.length ==0) {
        return;
    }
    NSDictionary * dic = @{
                           @"CityCode":cityCode
                           };
    [[LDMainPageNetWork defaultInstance] getPath:MGetArea parameter:dic success:^(id result) {
        locationArray = (NSArray *)result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.locationTableview reloadData];
        });
    } fail:^(NSError *error) {
        
    }];
}




#pragma mark - UitableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.locationTableview]) {
        return changeActivity ? _activityClassArray.count:(locationArray.count+1);
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
            if (indexPath.row == locationArray.count) {
                label.text = @"全部地区";
            }
            else
            {
                label.text = [locationArray[indexPath.row] valueForKey:@"Name"];
            }
        
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
    
    return cell;
    
}


#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.locationTableview]) {
        if (changeActivity) {
            [self changeActivity:indexPath.row];
        }
        else
        {
            [self changeLocation:indexPath.row];
            
        }
    }
    else
    {
        NSDictionary * dic = activityArray[indexPath.row];
        
        ActiveDetailViewController * activityVc = [[ActiveDetailViewController alloc] init];
        activityVc.Id = [[dic objectForKey:@"Id"] intValue];
        [self.navigationController pushViewController:activityVc animated:YES];
    }
    
}

- (void)changeActivity:(NSInteger)row {
    self.activityId = [[_activityClassArray[row] objectForKey:@"Id"] integerValue];
    NSString * titleTemp = [_activityClassArray[row] objectForKey:@"ClassName"];
    [self.activityButton setTitle:[NSString stringWithFormat:@"精彩活动 %@",titleTemp] forState:UIControlStateNormal];
    [self.activityButton setSelected:NO];
//    NSDictionary * dic= @{
//                          @"ActivityClassId":[NSNumber numberWithInteger:self.activityId],
//                          @"ReadFlag" :[NSNumber numberWithInt:1]
//                          };
    currentPage = 1;
    self.isHot = NO;
    [self.locationTableview setHidden:YES];
    [self requestActivityData:currentPage];
}

- (void)changeLocation:(NSInteger)row {
    gtime1 = nil;
    gtime2 = nil;
    currentPage = 1;
    self.isHot = NO;
    UIButton * button  =(UIButton *)[self.filterView viewWithTag:4];
    if (row == locationArray.count) {
        gareaCode = nil;
        [button setTitle:@"全部地区" forState:UIControlStateNormal];
    }
    else
    {
        NSDictionary * area = locationArray[row];
        gareaCode = [area objectForKey:@"Code"];
        [button setTitle:[area objectForKey:@"Name"] forState:UIControlStateNormal];
        
    }
    [self.locationTableview setHidden:YES];
    [self requestActivityData:currentPage];
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
//            NSDictionary * dic = @{
//                                   @"ActivityClassId":[NSNumber numberWithInteger:self.activityId],
//                                   @"ReadFlag" :[NSNumber numberWithInt:1]
//                                   };
            self.isHot = YES;
            currentPage = 1;
            gtime2 = nil;
            gtime1 = nil;
            gareaCode = nil;
            [self requestActivityData:currentPage];
            [self.locationTableview setHidden:YES];
        }
            break;
        case 2:
        {
//            NSDictionary * dic = @{
//                                   @"ActivityClassId":[NSNumber numberWithInteger:self.activityId],
//                                   @"ReadFlag" :[NSNumber numberWithInt:0]
//                                   };
            self.isHot = NO;
            currentPage = 1;
            gtime2 = nil;
            gtime1 = nil;
            gareaCode = nil;
            [self requestActivityData:currentPage];
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
    gtime1 = mondayStr;
    gtime2 = sundayStr;
    self.isHot =NO;
    currentPage = 1;
    [self requestActivityData:currentPage];
    
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
