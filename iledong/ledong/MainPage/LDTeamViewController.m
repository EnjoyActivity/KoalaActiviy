//
//  LDTeamViewController.m
//  ledong
//
//  Created by 郑红 on 5/20/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import "LDTeamViewController.h"
#import "LDTeamTableViewCell.h"
#import "TeamHomeViewController.h"
#import "LDMainPageNetWork.h"

static NSInteger const hotButtonTag = 101;
static NSInteger const categoryButtonTag = 102;
static NSInteger const areaButtonTag = 103;

static NSString * const locationIdentifier = @"LocationCell";
static NSString * const teamCell = @"teamCell";

@interface LDTeamViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * teamtableView;
    UIView * filterView;
    NSInteger currentButton;
    NSArray * locationArray;
    NSMutableArray * teamArray;
    
    BOOL locationChange;
    BOOL activityChange;
    NSInteger currentPage;

    NSInteger activityId;
    NSString * areaCode;

}

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic,strong) UITableView * locationTableview;

@end

@implementation LDTeamViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    activityId = -1;
    
    currentPage = 1;
    teamArray = [NSMutableArray array];
    [self setUpUI];
    [self requestTeamData:currentPage];
    if (self.cityCode) {
        [self getAreaByCityCode:self.cityCode];
    }
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

- (void)requestTeamData:(NSInteger)pageIndex{
    NSMutableDictionary * parameterDic = [[NSMutableDictionary alloc] init];
    [parameterDic setValue:[NSNumber numberWithInt:1] forKey:@"Page"];
    [parameterDic setValue:[NSNumber numberWithInt:20] forKey:@"PageSize"];
    [parameterDic setValue:[NSNumber numberWithBool:YES] forKey:@"IsHot"];
    if (activityId > 0) {
        [parameterDic setValue:[NSNumber numberWithInteger:activityId] forKey:@"ActivityClassId"];
    }
    if (areaCode.length != 0) {
        [parameterDic setValue:areaCode forKey:@"AreaCode"];
    }
    
    [[LDMainPageNetWork defaultInstance] postPath:MQueryTeams parameter:parameterDic success:^(id result) {
        NSDictionary * dic = (NSDictionary*)result;
        NSInteger topalPage = [[dic objectForKey:@"TotalPage"] integerValue];
        NSArray * resultArr = [dic objectForKey:@"Data"];
        if (pageIndex == 1) {
            teamArray = [resultArr copy];
        }
        else{
            [teamArray addObjectsFromArray:resultArr];
        }
        currentPage ++;
        dispatch_async(dispatch_get_main_queue(), ^{
            [teamtableView reloadData];
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

#pragma mark - TabledataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.locationTableview]) {
        return locationChange ? locationArray.count+1 : _activityArray.count+1;
    }
    return teamArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.locationTableview]) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:locationIdentifier forIndexPath:indexPath];
        UILabel * label = (UILabel *)[cell viewWithTag:2];
        if (locationChange) {
            NSString * str = indexPath.row == locationArray.count ? @"全部地区":[locationArray[indexPath.row] objectForKey:@"Name"];
            label.text = str;
        }
        else {
            NSString * str = indexPath.row == _activityArray.count ? @"全部类别":[_activityArray[indexPath.row] valueForKey:@"ClassName"];
            label.text = str;
        }
        return cell;
    }
    
    LDTeamTableViewCell * cell = (LDTeamTableViewCell*)[tableView dequeueReusableCellWithIdentifier:teamCell forIndexPath:indexPath];
    NSDictionary * dic =teamArray[indexPath.row];
    NSString * teamImage = [dic objectForKey:@"AvatarUrl"];
    NSURL * teamUrl = [NSURL URLWithString:teamImage];
    
    NSString * name = [dic objectForKey:@"Name"];
    NSString * member = [dic objectForKey:@"PersonNum"];
    NSString * focus = [dic objectForKey:@"Concern"];
    NSString * activity = [dic objectForKey:@"Liveness"];
    
    [cell.teamImageView sd_setImageWithURL:teamUrl placeholderImage:[UIImage imageNamed:@"img_avatar_100"]];
    cell.teamMember.text = [NSString stringWithFormat:@"%@人",member];
    cell.teamName.text = name;
    cell.teamFocus.text = [NSString stringWithFormat:@"%@人关注",focus];
    cell.teamActivity.text = [NSString stringWithFormat:@"团队活跃度%@",activity];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.locationTableview]) {
        return 37;
    }
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.locationTableview]) {
        if (locationChange) {
            [self changeLocation:indexPath.row];
        }
        else
        {
            [self changeActivity:indexPath.row];
        }
        
    }
    else
    {
        NSDictionary * dic = teamArray[indexPath.row];
        TeamHomeViewController * teamVc = [[TeamHomeViewController alloc] init];
        teamVc.teamId = [dic objectForKey:@"Id"];
        [self.navigationController pushViewController:teamVc animated:YES];
    }
}

- (void)changeLocation:(NSInteger)row {
    currentPage = 1;
    locationChange = NO;
    NSString * str = @"";
    [self.locationTableview setHidden:YES];
    if (row == locationArray.count) {
        areaCode = nil;
        str = @"全部地区";
    }
    else
    {
        NSDictionary * area = locationArray[row];
        areaCode = [area objectForKey:@"Code"];
        str = [area objectForKey:@"Name"] ;
    }
    
    [self requestTeamData:currentPage];
    UIButton * button = (UIButton *)[filterView viewWithTag:areaButtonTag];
    [button setTitle:str forState:UIControlStateNormal];
}

- (void)changeActivity:(NSInteger)row {
    currentPage = 1;
    activityChange = NO;
    NSString * str;
    [self.locationTableview setHidden:YES];
    if (row == _activityArray.count) {
        str = @"全部活动";
        activityId = -1;
    }
    else
    {
        NSDictionary * dic = _activityArray[row];
        
        activityId= [[dic objectForKey:@"Id"] integerValue];
        str =[dic objectForKey:@"ClassName"];
    }
    
    [self requestTeamData:currentPage];
    
    UIButton * button = (UIButton *)[filterView viewWithTag:categoryButtonTag];
    [button setTitle:str forState:UIControlStateNormal];
    
}
#pragma mark - buttonAction
- (IBAction)back:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}


- (void)filterButtonClicked:(UIButton *)sender {
    if (sender.tag == categoryButtonTag && activityChange) {
        [self.locationTableview setHidden:YES];
        activityChange = NO;
        [sender setSelected:NO];
        return;
    }
    if (sender.tag == areaButtonTag && locationChange) {
        [self.locationTableview setHidden:YES];
        locationChange = NO;
        [sender setSelected:NO];
        return;
    }
    
    UIButton * button = (UIButton *)[filterView viewWithTag:currentButton];
    [button setSelected:NO];
    
    currentButton= sender.tag;
    [sender setSelected:YES];
    
    switch (sender.tag) {
        case hotButtonTag:
        {
            currentPage = 1;
            [self requestTeamData:currentPage];
            [self.locationTableview setHidden:YES];
        }
            break;
        case areaButtonTag:
        {
            locationChange = YES;
            activityChange = NO;
            [self.locationTableview setHidden:NO];
            [self.locationTableview reloadData];
        }
            break;
        case categoryButtonTag:
        {
            activityChange = YES;
            locationChange = NO;
            [self.locationTableview setHidden:NO];
            [self.locationTableview reloadData];
        }
            break;
    }
}


#pragma mark - UI
- (void)setUpUI {
    teamtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, APP_WIDTH, APP_HEIGHT-100) style:UITableViewStylePlain];
    teamtableView.delegate  = self;
    teamtableView.dataSource = self;
    teamtableView.backgroundColor = [UIColor whiteColor];
    [teamtableView registerNib:[UINib nibWithNibName:@"LDTeamTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:teamCell];
    teamtableView.tableFooterView =[UIView new];

    [self.view addSubview:teamtableView];
    
    [self addFilterView];
    [self.view addSubview:self.locationTableview];
}

- (void)addFilterView {
    filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, APP_HEIGHT, 36)];
    filterView.backgroundColor = [UIColor whiteColor];
    
    UIButton * hotButton = [self buttonFrame:CGRectMake(18, 3, 45, 30) title:@"热门" isSelete:NO];
    UIButton * cataryButton = [self buttonFrame:CGRectMake(0, 3, 75, 30) title:@"全部类别 " isSelete:YES];
    cataryButton.center = CGPointMake(APP_WIDTH/2, 18);
    UIButton *  areaButton = [self buttonFrame:CGRectMake(APP_WIDTH - 93, 3, 75, 30) title:@"全部地区 " isSelete:YES];
    hotButton.tag = hotButtonTag;
    cataryButton.tag = categoryButtonTag;
    areaButton.tag = areaButtonTag;
    currentButton = hotButtonTag;
    [hotButton setSelected:YES];
    
    
    [filterView addSubview:hotButton];
    [filterView addSubview:cataryButton];
    [filterView addSubview:areaButton];
    
    [self.view addSubview:filterView];
}

- (UIButton *)buttonFrame:(CGRect)frame title:(NSString *)title isSelete:(BOOL)filter {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGB(227, 26, 26, 1) forState:UIControlStateSelected];
    [button setTitleColor:RGB(153, 153, 153, 1) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (filter) {
        [button setImage:[UIImage imageNamed:@"ic_triangle_grey@2x"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"ic_triangle_grey_up@2x"] forState:UIControlStateSelected];
        button.transform = CGAffineTransformMakeScale(-1,1);
        button.titleLabel.transform = CGAffineTransformMakeScale(-1, 1);
        button.imageView.transform = CGAffineTransformMakeScale(-1, 1);
    }
    return button;
}

- (UITableView *)locationTableview {
    if (!_locationTableview) {
        _locationTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, APP_WIDTH, APP_HEIGHT - 100) style:UITableViewStylePlain];
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
