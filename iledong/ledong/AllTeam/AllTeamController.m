//
//  AllTeamController.m
//  ledong
//
//  Created by dongguoju on 16/2/29.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "AllTeamController.h"
#import "AllTeamCell.h"
#import "HttpClient.h"
#import "LoginAndRegistViewController.h"
#import "FRUtils.h"
#import "CreateTeamVController.h"
#import "JoinTeamViewController.h"
#import "TeamHomeViewController.h"
#import "SelectTeamViewController.h"

#define kCell       @"AllTeamCell"

typedef enum listType {
    listTypeStartTeam = 0,
    listTypeJoinTeam
}listType;

@interface AllTeamController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray* myStartTeamData;
@property (nonatomic, strong)NSMutableArray* myJoinTeamData;
@property (nonatomic, strong)UIImageView* bgImageView;
@property (nonatomic, strong)UILabel* bgLabel;
@property (nonatomic, assign)listType tableViewListType;

@end

@implementation AllTeamController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *myBar = [[UITabBarItem alloc]initWithTitle:@"团队"
                    image:[UIImage imageNamed:@"ic_team_on"] tag:1];
        myBar.selectedImage = [UIImage imageNamed:@"ic_team"];
        self.tabBarItem = myBar;
     
        self.tableViewListType = listTypeStartTeam;
        self.myStartTeamData = [NSMutableArray array];
        self.myJoinTeamData = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self.tableView registerClass:[AllTeamCell class] forCellReuseIdentifier:kCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initBgImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];//有动画的隐藏
    self.tabBarController.tabBar.hidden = NO;
    if (self.tableViewListType == listTypeStartTeam) {
        [self updateStartTeamData];
    } else {
        [self updateJoinTeamData];
    }
    
}

#pragma mark -- API
- (void)updateStartTeamData {
    if ([HttpClient isLogin]) {
        NSString *urlStr = [API_BASE_URL stringByAppendingString:API_JOINTEAMS_URL];
        NSDictionary *dic = @{@"token":[HttpClient getTokenStr]};
        [HttpClient postJSONWithUrl:urlStr parameters:dic success:^(id responseObject) {
            NSDictionary* dict = (NSDictionary*)responseObject;
            NSNumber* codeNum = [dict objectForKey:@"code"];
            if (codeNum.intValue == 0) {
                NSArray* array = [dict objectForKey:@"result"];
                self.myStartTeamData = [NSMutableArray arrayWithArray:array];
                if (self.myStartTeamData.count > 0) {
                    self.bgImageView.hidden = YES;
                    self.bgLabel.hidden = YES;
                }
                else {
                    self.bgImageView.hidden = NO;
                    self.bgLabel.hidden = NO;
                }
                [self.tableView reloadData];
            }
        } fail:^{
            [Dialog simpleToast:@"获取我的团队失败！" withDuration:1.5];
        }];
    }
}

- (void)updateJoinTeamData {
    if ([HttpClient isLogin]) {
        NSString *urlStr = [API_BASE_URL stringByAppendingString:API_TEAMAPPLY_URL];
        NSDictionary *dic = @{@"token":[HttpClient getTokenStr]};
        [HttpClient postJSONWithUrl:urlStr parameters:dic success:^(id responseObject) {
            NSDictionary* dict = (NSDictionary*)responseObject;
            NSNumber* codeNum = [dict objectForKey:@"code"];
            if (codeNum.intValue == 0) {
                NSArray* array = [dict objectForKey:@"result"];
                self.myJoinTeamData = [NSMutableArray arrayWithArray:array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.myJoinTeamData.count > 0) {
                        self.bgImageView.hidden = YES;
                        self.bgLabel.hidden = YES;
                    }
                    else {
                        self.bgImageView.hidden = NO;
                        self.bgLabel.hidden = NO;
                    }
                    [self.tableView reloadData];
                });
            }
         } fail:^{
             [Dialog simpleToast:@"获取我申请的团队失败！" withDuration:1.5];
         }];
    }
}

#pragma mark -- UIButtonClick
- (IBAction)myTeamButton:(id)sender {
    if (self.tableViewListType == listTypeStartTeam) {
        return;
    }
    [self.myTeam setBackgroundColor:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1]];
    [self.myTeam setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.teamAgree setBackgroundColor:[UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1]];
    [self.teamAgree setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    self.tableViewListType = listTypeStartTeam;
    [self updateStartTeamData];
}

- (IBAction)TeamAgree:(id)sender {
    if (self.tableViewListType == listTypeJoinTeam) {
        return;
    }
    [self.myTeam setBackgroundColor:[UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1]];
    [self.myTeam setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    [self.teamAgree setBackgroundColor:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1]];
    [self.teamAgree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    self.tableViewListType = listTypeJoinTeam;
    [self updateJoinTeamData];
}

//创建团队
- (IBAction)createTeamButtonClick:(id)sender
{
    if ([HttpClient isLogin])
    {
        CreateTeamVController *createViewController = [[CreateTeamVController alloc] init];
        [createViewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:createViewController animated:YES];
    }
    else
    {
        [FRUtils presentToLoginViewControllerWithRootViewController:self];
    }
}

//加入团队
- (IBAction)joinTeamButtonClick:(id)sender
{
    if ([HttpClient isLogin])
    {
        //JoinTeamViewController *joinTeamViewController = [[JoinTeamViewController alloc] init];
        //[joinTeamViewController setHidesBottomBarWhenPushed:YES];
        
        SelectTeamViewController* selectTeamViewController = [[SelectTeamViewController alloc]init];
        [selectTeamViewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:selectTeamViewController animated:YES];
    }
    else
    {
        [FRUtils presentToLoginViewControllerWithRootViewController:self];
    }
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableViewListType == listTypeJoinTeam)
        return self.myJoinTeamData.count;
    else if (self.tableViewListType == listTypeStartTeam)
        return self.myStartTeamData.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];
    NSDictionary* dict = nil;
    if (self.tableViewListType == listTypeJoinTeam)
        dict = self.myJoinTeamData[indexPath.row];
    else if (self.tableViewListType == listTypeStartTeam)
        dict = self.myStartTeamData[indexPath.row];

    if (self.tableViewListType == listTypeJoinTeam) {
        cell.personCountLabel.hidden = YES;
        cell.payAttentionCountLabel.hidden = YES;
        
        cell.teamActiveCountLabel.text = @"审核中";
        cell.teamActiveCountLabel.textColor = UIColorFromRGB(0xE3191A);
    }
    else {
        NSNumber* maxPersonNum = [dict objectForKey:@"PersonNum"];
        cell.personCountLabel.text = [NSString stringWithFormat:@"%d人",maxPersonNum.intValue];
        [cell.personCountLabel sizeToFit];
        
        NSNumber* livenessNum = [dict objectForKey:@"Liveness"];
        cell.teamActiveCountLabel.text = [NSString stringWithFormat:@"团队活跃度 %d", livenessNum.intValue];
        NSNumber* concernNum  = [dict objectForKey:@"Concern"];
        cell.payAttentionCountLabel.text = [NSString stringWithFormat:@"%d人关注", concernNum.intValue];
        [cell.teamActiveCountLabel sizeToFit];
        [cell.payAttentionCountLabel sizeToFit];
        
        cell.personCountLabel.hidden = NO;
        cell.payAttentionCountLabel.hidden = NO;
        cell.teamActiveCountLabel.textColor = UIColorFromRGB(0xBABABA);
    }
    cell.teamNameLabel.text = [dict objectForKey:@"Name"];
    [cell.teamNameLabel sizeToFit];
    
    NSString* avatarUrl = [dict objectForKey:@"AvatarUrl"];
    if (avatarUrl.length > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:avatarUrl]];
            [request setHTTPMethod:@"GET"];
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            if (data == nil)
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.teamImageView.image = [UIImage imageWithData:data];
                [cell setNeedsLayout];
            });
        });
    } else {
        NSString* path = [[NSBundle mainBundle]pathForResource:@"img_teamavatar_120@2x" ofType:@"png"];
        cell.teamImageView.image = [UIImage imageWithContentsOfFile:path];

    }
    return cell;
}

//删除某一行
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    if ([tableView isEqual:_tableView])
        result = UITableViewCellEditingStyleDelete;
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete &&
        self.tableViewListType == listTypeJoinTeam) {
        if (indexPath.row < [self.myJoinTeamData count]) {
            [self exitTeam:self.myJoinTeamData[indexPath.row] listType:listTypeJoinTeam tableView:tableView row:indexPath];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleDelete &&
             self.tableViewListType == listTypeStartTeam) {
        if (indexPath.row < [self.myStartTeamData count]) {
//            [self exitTeam:self.myStartTeamData[indexPath.row]];
//            [self.myStartTeamData removeObjectAtIndex:indexPath.row];
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self exitTeam:self.myStartTeamData[indexPath.row] listType:listTypeStartTeam tableView:tableView row:indexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamHomeViewController *teamHomeVC = [[TeamHomeViewController alloc] init];
    if (self.tableViewListType == listTypeStartTeam) {
        teamHomeVC.teamType = teamTypeCreate;
        NSDictionary* dict = self.myStartTeamData[indexPath.row];
        teamHomeVC.teamId = [dict objectForKey:@"Id"];
    }
    else if (self.tableViewListType == listTypeJoinTeam)  {
        teamHomeVC.teamType = teamTypeJoin;
        NSDictionary* dict = self.myJoinTeamData[indexPath.row];
        teamHomeVC.teamId = [dict objectForKey:@"Id"];
    }

    [teamHomeVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:teamHomeVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"退出";
}

#pragma mark - logic
- (void)exitTeam:(NSDictionary*)dict listType:(listType)listType
       tableView:(UITableView*)tableView row:(NSIndexPath*)indexPath {
    NSString* teamId = [dict objectForKey:@"Id"];
    NSString* token = [HttpClient getTokenStr];
    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_EXIT_TEAM_URL];
    [HttpClient postJSONWithUrl:urlStr parameters:@{@"teamid":teamId,@"token":token} success:^(id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSNumber* result = [dict objectForKey:@"Result"];
        if (!result.boolValue) {
            NSString* str = [dict objectForKey:@"Message"];
            [Dialog simpleToast:str withDuration:1.5];
        }
        else {
            if (listType == listTypeStartTeam)
                [self.myStartTeamData removeObjectAtIndex:indexPath.row];
            else if (listType == listTypeJoinTeam)
                [self.myJoinTeamData removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    } fail:^{
        [Dialog simpleToast:@"退出团队失败！" withDuration:1.5];
    }];
}

- (void)initBgImageView {
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.tableView addSubview:self.bgImageView];

    NSString* path = [[NSBundle mainBundle]pathForResource:@"img_nodata@2x" ofType:@"png"];
    self.bgImageView.image = [UIImage imageWithContentsOfFile:path];
    [self.bgImageView sizeToFit];
    self.bgImageView.center = CGPointMake(self.tableView.bounds.size.width/2, self.tableView.bounds.size.height/2);
    self.bgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bgImageView.frame.size.height+self.bgImageView.frame.origin.y+10, 0, 0)];
    [self.tableView addSubview:self.bgLabel];
    self.bgLabel.numberOfLines = 0;
    self.bgLabel.text = @"还没有找到组织～\r\n赶紧去加个队吧！";
    self.bgLabel.font = [UIFont systemFontOfSize:14.0];
    self.bgLabel.textColor = UIColorFromRGB(0x999999);
    [self.bgLabel sizeToFit];
    self.bgLabel.center = CGPointMake(self.bgImageView.center.x+10, self.bgLabel.center.y);
}

@end
