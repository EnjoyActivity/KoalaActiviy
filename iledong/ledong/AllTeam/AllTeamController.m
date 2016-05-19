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

//    [_tableView registerNib:[UINib nibWithNibName:@"AllTeamCell" bundle:nil] forCellReuseIdentifier:@"AllTeamCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initBgImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self updateStartTeamData];
}

#pragma mark -- API
- (void)updateStartTeamData {
    if ([HttpClient isLogin]) {
        NSString *urlStr = [API_BASE_URL stringByAppendingString:API_STARTTEAMS_URL];
        NSDictionary *dic = @{@"token":[HttpClient getTokenStr]};
        [HttpClient postJSONWithUrl:urlStr parameters:dic success:^(id responseObject) {
            NSDictionary* dict = (NSDictionary*)responseObject;
            NSNumber* codeNum = [dict objectForKey:@"code"];
            if (codeNum.intValue == 0) {
                self.myStartTeamData = [dic objectForKey:@"result"];
                if (self.myStartTeamData.count > 0) {
                    self.tableView.hidden = NO;
                    self.bgImageView.hidden = YES;
                    self.bgLabel.hidden = YES;
                    [self.tableView reloadData];
                }
                else {
                    self.bgImageView.hidden = NO;
                    self.bgLabel.hidden = NO;
                    self.tableView.hidden = YES;
                }
            }
        } fail:^{
            [Dialog simpleToast:@"获取我的团队失败！" withDuration:1.5];
        }];
    }
}

- (void)updateJoinTeamData {
    if ([HttpClient isLogin]) {
        NSString *urlStr = [API_BASE_URL stringByAppendingString:API_JOINTEAMS_URL];
        NSDictionary *dic = @{@"token":[HttpClient getTokenStr]};
        [HttpClient postJSONWithUrl:urlStr parameters:dic success:^(id responseObject) {
            NSDictionary* dict = (NSDictionary*)responseObject;
            NSNumber* codeNum = [dict objectForKey:@"code"];
            if (codeNum.intValue == 0) {
                self.myJoinTeamData = [dic objectForKey:@"result"];
                if (self.myJoinTeamData.count > 0) {
                    self.tableView.hidden = NO;
                    self.bgImageView.hidden = YES;
                    self.bgLabel.hidden = YES;
                    [self.tableView reloadData];
                }
                else {
                    self.bgImageView.hidden = NO;
                    self.bgLabel.hidden = NO;
                    self.tableView.hidden = YES;
                }
            }
         } fail:^{
             [Dialog simpleToast:@"获取我申请的团队失败！" withDuration:1.5];
         }];
    }
}

#pragma mark -- UIButtonClick
- (IBAction)myTeamButton:(id)sender
{
    [self.myTeam setBackgroundColor:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1]];
    [self.myTeam setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.teamAgree setBackgroundColor:[UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1]];
    [self.teamAgree setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
//    self.footerView.hidden = NO;

    self.tableViewListType = listTypeStartTeam;
    [self updateStartTeamData];
}
- (IBAction)TeamAgree:(id)sender
{
    [self.myTeam setBackgroundColor:[UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1]];
    [self.myTeam setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    [self.teamAgree setBackgroundColor:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1]];
    [self.teamAgree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.footerView.hidden = YES;
    
    self.tableViewListType = listTypeJoinTeam;
    [self updateJoinTeamData];
}

//创建团队
- (IBAction)createTeamButtonClick:(id)sender
{
    if ([HttpClient isLogin])
    {
        CreateTeamVController *createViewController = [[CreateTeamVController alloc] init];
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
        JoinTeamViewController *joinTeamViewController = [[JoinTeamViewController alloc] init];
        [self.navigationController pushViewController:joinTeamViewController animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
    //UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    //return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string = @"AllTeamCell";
    __block AllTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell)
        cell = [[NSBundle mainBundle] loadNibNamed:@"AllTeamCell" owner:self options:nil][0];
    
    cell.activeCountLabel.hidden = YES;
    cell.attentionCountLabel.hidden = YES;
    
    NSDictionary* dict = nil;
    if (self.tableViewListType == listTypeJoinTeam)
        dict = self.myJoinTeamData[indexPath.row];
    else if (self.tableViewListType == listTypeStartTeam)
        dict = self.myStartTeamData[indexPath.row];
    
    cell.nameLabel.text = [dict objectForKey:@"Name"];
    [cell.nameLabel sizeToFit];
    cell.personCountLabel.text = [dict objectForKey:@"MaxPersonNum"];
    [cell.personCountLabel sizeToFit];
    NSString* avatarUrl = [dict objectForKey:@"AvatarUrl"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:avatarUrl]];
        [request setHTTPMethod:@"GET"];
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (data == nil)
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = [UIImage imageWithData:data];
            [cell setNeedsLayout];
        });
    });
    
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
            [self.myJoinTeamData removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleDelete &&
             self.tableViewListType == listTypeStartTeam) {
        if (indexPath.row < [self.myStartTeamData count]) {
            [self.myStartTeamData removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamHomeViewController *teamHomeVC = [[TeamHomeViewController alloc] init];
    [self.navigationController pushViewController:teamHomeVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - logic
- (void)initBgImageView {
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.bgImageView];

    NSString* path = [[NSBundle mainBundle]pathForResource:@"img_nodata@2x" ofType:@"png"];
    self.bgImageView.image = [UIImage imageWithContentsOfFile:path];
    [self.bgImageView sizeToFit];
    self.bgImageView.center = CGPointMake(APP_WIDTH/2, 64+(APP_HEIGHT-64-60)/2);
    
    self.bgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bgImageView.frame.size.height+self.bgImageView.frame.origin.y+10, 0, 0)];
    [self.view addSubview:self.bgLabel];
    self.bgLabel.numberOfLines = 0;
    self.bgLabel.text = @"还没有找到组织～\r\n赶紧去加个队吧！";
    self.bgLabel.font = [UIFont systemFontOfSize:14.0];
    self.bgLabel.textColor = UIColorFromRGB(0x999999);
    [self.bgLabel sizeToFit];
    self.bgLabel.center = CGPointMake(self.bgImageView.center.x+10, self.bgLabel.center.y);
}

@end
