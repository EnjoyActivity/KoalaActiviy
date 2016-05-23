//
//  SearchViewController.m
//  ledong
//
//  Created by luojiao  on 16/3/28.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "FRUtils.h"
#import "SearchActiveVC.h"
#import "SearchTeamVC.h"
#import "SearchFriendVC.h"

#import "HistoryTableViewCell.h"

static NSString * historyCell = @"HistoryCell";
static NSString * activityCell = @"sActivityCell";
static NSString * teamCell   = @"ActivityCell";
static NSString * friendCell = @"ActivityCell";


@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSArray *sectionTitleArray;
    NSMutableArray * historyArray;
    NSMutableArray * activityArray;
    NSMutableArray * teamArray;
    NSMutableArray * friendArray;
}
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    [self setUpUI];
  
    self.resultTableView.hidden = YES;
    self.textFiled.delegate = self;
    
    sectionTitleArray = @[@"活动",@"团队",@"好友"];
    
    NSArray * history = @[@"history1",@"history2",@"history3",@"history4",@"history5"];
    historyArray = [NSMutableArray array];
    [historyArray addObjectsFromArray:history];
    
    activityArray = [NSMutableArray array];
     NSArray * activity = @[@"activity1",@"activity2",@"activity3",@"activity4"];
    [activityArray addObjectsFromArray:activity];
    teamArray =[NSMutableArray array];
    NSArray * team = @[@"team1",@"team2",@"team3",@"team4",@"team5",@"team6",@"team7",@"team8"];
    
    [teamArray addObjectsFromArray:team];
    
    friendArray = [NSMutableArray array];
    
    NSArray * friedn = @[@"friend1",@"friend2",@"friend3"];
    [friendArray addObjectsFromArray:friedn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ButtonClick
- (IBAction)searchTeamButtonClick:(id)sender
{
    SearchTeamVC *teamController = [[SearchTeamVC alloc] init];
    [self.navigationController pushViewController:teamController animated:YES];
}

- (IBAction)searchActivButtonClick:(id)sender
{
    SearchActiveVC *activeController = [[SearchActiveVC alloc] init];
    [self.navigationController pushViewController:activeController animated:YES];
}

- (IBAction)searchFrindsButtonClick:(id)sender
{
    SearchFriendVC *friendController = [[SearchFriendVC alloc] init];
    [self.navigationController pushViewController:friendController animated:YES];
}

- (IBAction)gobackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchButtonClicked:(id)sender {
    
}

- (IBAction)clearSearchButtonClick:(id)sender
{
    [historyArray removeAllObjects];
    [self.tableView reloadData];
    
}

- (void)getMoreActivityInfo:(UIButton *)sender {
    NSInteger tag = sender.tag-100;
    switch (tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.contentView.hidden = YES;
    self.resultTableView.hidden = NO;
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.resultTableView.hidden = YES;
    self.contentView.hidden = NO;
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        return 44.0;
    }
    else
    {
        return 100.0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.resultTableView)
    {
        return 3;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        return historyArray.count;
    }
    else {
        switch (section) {
            case 0:
            {
                return activityArray.count;
            }
                break;
            case 1:
            {
                return teamArray.count;
            }
                break;
            default:
            {
                return friendArray.count;
            }
                break;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCell forIndexPath:indexPath];
        UILabel * label = (UILabel *)[cell viewWithTag:2];
        label.text = historyArray[indexPath.row];
        return cell;
    }
    else
    {
        if (indexPath.section == 0) {
            SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCell forIndexPath:indexPath];
            cell.activityName.text = @"dasda";
            cell.activityPrice.text = @"ewqq";
            return cell;
        }
        else if (indexPath.section == 1) {
            HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamCell forIndexPath:indexPath];
            cell.sNameLabel.text = @"hahahahh";
            return cell;
        }
        else {
            HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCell forIndexPath:indexPath];
            cell.sNameLabel.text = @"oooo";
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.resultTableView)
    {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.resultTableView)
    {
        return section == 0 ? 0:49;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        return nil;
    }
    return [self viewForHeader:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        return nil;
    }
    if (section == 0) {
        return nil;
    }
    return [self viewForFooter:section];
}

#pragma mark - UitableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        
    }
    else {
        
    }
}


#pragma mark - UI

- (void)setUpUI {
    self.tableView.tableFooterView = _footerView;

    [self.tableView registerNib:[UINib nibWithNibName:@"SearchHistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:historyCell];
    
    [self.resultTableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"sActivityCell"];
    [self.resultTableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:teamCell];
    
    [self.searchButton setBackgroundImage:[FRUtils resizeImageWithImageName:@"ic_search_a"] forState:UIControlStateNormal];
    
    [self.searchActive setImage:[FRUtils resizeImageWithImageName:@"ic_search_activity"] forState:UIControlStateNormal];
    [self.searchTeam setImage:[FRUtils resizeImageWithImageName:@"ic_search_team"] forState:UIControlStateNormal];
    [self.searchFriend setImage:[FRUtils resizeImageWithImageName:@"ic_search_friend"] forState:UIControlStateNormal];
    
    self.clearSarchImage.image = [FRUtils resizeImageWithImageName:@"btn_white"];
}

- (UIView *)viewForFooter:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 49)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40)];
    button.tag = 100 + section;
    [button addTarget:self action:@selector(getMoreActivityInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 200, 40)];
    nameLabel.text = [NSString stringWithFormat:@"查看更多相关%@",sectionTitleArray[section]];
    nameLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    nameLabel.font = [UIFont systemFontOfSize:15];
    
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, 40, APP_WIDTH, 9);
    lineLayer.backgroundColor = RGB(242.0, 243.0, 244.0, 1.0).CGColor;
    

    [button setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0,  APP_WIDTH - 35, 0,0)];

    [footerView addSubview:nameLabel];
    [footerView.layer addSublayer:lineLayer];
    [footerView addSubview:button];
    return footerView;
}



- (UIView *)viewForHeader:(NSInteger)section {
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(18, 10, 40, 20)];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    title.text = sectionTitleArray[section];
    CALayer * lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(18, 39, APP_WIDTH, 1);
    lineLayer.backgroundColor = RGB(242.0, 243.0, 244.0, 1.0).CGColor;

    nameView.backgroundColor = [UIColor whiteColor];

    [nameView.layer addSublayer:lineLayer];
    [nameView addSubview:title];
    
    return nameView;
}
@end
