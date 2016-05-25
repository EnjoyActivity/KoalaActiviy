//
//  LDTeamViewController.m
//  ledong
//
//  Created by 郑红 on 5/20/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import "LDTeamViewController.h"
#import "LDTeamTableViewCell.h"

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
    
    BOOL locationChange;

}

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic,strong) UITableView * locationTableview;

@end

@implementation LDTeamViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    locationArray = @[@"全部地区",@"附近",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去",@"曹杨去"];
    [self setUpUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NetWork

- (void)requestTeamData:(NSInteger)pageIndex parameter:(NSDictionary *)dic {
    
}

#pragma mark - TabledataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.locationTableview]) {
        return locationChange ? locationArray.count : _categoryArray.count;
    }
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.locationTableview]) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:locationIdentifier forIndexPath:indexPath];
        UILabel * label = (UILabel *)[cell viewWithTag:2];
        if (locationChange) {
            label.text = locationArray[indexPath.row];
        }
        else
        {
            NSDictionary * dic = _categoryArray[indexPath.row];
            label.text = dic[@""];
        }
        return cell;
    }
    LDTeamTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:teamCell forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.locationTableview]) {
        return 37;
    }
    return 120;
}
#pragma mark - buttonAction
- (IBAction)back:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}


- (void)filterButtonClicked:(UIButton *)sender {
    if (sender.tag == currentButton) {
        return;
    }
    
    UIButton * button = (UIButton *)[filterView viewWithTag:currentButton];
    [button setSelected:NO];
    
    currentButton= sender.tag;
    [sender setSelected:YES];
    
    switch (sender.tag) {
        case hotButtonTag:
        {
            [self.locationTableview setHidden:YES];
        }
            break;
        case areaButtonTag:
        {
            locationChange = YES;
            [self.locationTableview setHidden:NO];
            [self.locationTableview reloadData];
        }
            break;
        case categoryButtonTag:
        {
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
