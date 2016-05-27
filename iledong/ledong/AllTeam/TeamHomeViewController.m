//
//  TeamHomeViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/28.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "TeamHomeViewController.h"
#import "FRUtils.h"
#import "TeamManagerTableViewController.h"
#import "TeamHomeTableViewCell.h"
#import "LDDeleteTagView.h"
#import "UIImageView+WebCache.h"
#import "ActiveDetailViewController.h"

@interface TeamHomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *quitTeamButton;
    NSDictionary *teamInfo;
    NSArray *teamActivity;
    
}
@property (nonatomic,strong) LDDeleteTagView *deleteTagView;
@property (nonatomic,assign) BOOL quitBtnShow;
@end

@implementation TeamHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    //self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.headerImage.image = [FRUtils circleImage:[UIImage imageNamed:@"user02_44"] withParam:1];
    [self setButton];
    
    CGFloat hight = self.headerImage.frame.size.height + self.middleView.frame.size.height + self.ActiveView.frame.size.height + self.footerView.frame.size.height + 90;
    self.scrollView.contentSize = CGSizeMake(APP_WIDTH, hight);
    [self refreshUI];
    [self queryTeamInfo];
    [self queryTeamActivity];
}

- (void)viewWillDisappear:(BOOL)animated {
    [quitTeamButton removeFromSuperview];
}
- (void)setQuitBtnShow:(BOOL)quitBtnShow {
    _quitBtnShow = quitBtnShow;
    if (!_quitBtnShow) {
        [quitTeamButton removeFromSuperview];
    }
}

- (void)setButton
{
    //关注、积分、足迹、粉丝button设置
    [self.footButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.fansButton setTitle:@"积分" forState:UIControlStateNormal];
    [self.membersButton setTitle:@"足迹" forState:UIControlStateNormal];
    [self.publicButton setTitle:@"粉丝" forState:UIControlStateNormal];
    [self.footButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.fansButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.membersButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.publicButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    
    if (self.teamType == teamTypeCreate) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_manage"] style:UIBarButtonItemStylePlain target:self action:@selector(manageBtnClicked)];
        rightButton.tintColor = [UIColor redColor];
        self.navigationItem.rightBarButtonItem = rightButton;
    }

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //我的团队不显示关注和申请加入，显示我是成员和聊天
    if (_teamType == teamTypeCreate) {
        UIButton *memberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        memberButton.titleLabel.font = [UIFont systemFontOfSize:15];
        memberButton.frame =_focusButton.frame;
        [memberButton setTitle:@"我是成员 " forState:UIControlStateNormal];
        [memberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [memberButton addTarget:self action:@selector(memberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [memberButton setImage:[UIImage imageNamed:@"ic_triangle_grey"] forState:UIControlStateNormal];
        memberButton.transform = CGAffineTransformMakeScale(-1,1);
        memberButton.titleLabel.transform = CGAffineTransformMakeScale(-1, 1);
        memberButton.imageView.transform = CGAffineTransformMakeScale(-1, 1);
        
        
        UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chatButton.titleLabel.font = [UIFont systemFontOfSize:15];
        chatButton.frame = _applyJoinButton.frame;
        [chatButton setTitle:@"聊天" forState:UIControlStateNormal];
        [chatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [chatButton addTarget:self action:@selector(chatBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        [_focusButton removeFromSuperview];
        [_applyJoinButton removeFromSuperview];
        [_footerView addSubview:memberButton];
        [_footerView addSubview:chatButton];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - buttonClick
- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
//我是成员
- (void)memberBtnClick:(UIButton*)sender {
    if (_quitBtnShow) {
        self.quitBtnShow = NO;
        return;
    }
    _quitBtnShow = YES;
    quitTeamButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [quitTeamButton setTitle:@"退出团队" forState:UIControlStateNormal];
    quitTeamButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [quitTeamButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
    [quitTeamButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [quitTeamButton setBackgroundImage:[UIImage imageNamed:@"bg_popup"] forState:UIControlStateNormal];
    quitTeamButton.backgroundColor = [UIColor clearColor];
    quitTeamButton.frame = CGRectMake(0, 0, 150, 40);
    quitTeamButton.center = CGPointMake(APP_WIDTH/4, APP_HEIGHT - 50 - 30);
    [quitTeamButton addTarget:self action:@selector(quitTeamClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitTeamButton];
}
//聊天
- (void)chatBtnClick:(UIButton*)sender {
    
}
//退出团队
- (void)quitTeamClick:(UIButton*)sender {
    NSString* token = [HttpClient getTokenStr];
    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_EXIT_TEAM_URL];
    [HttpClient postJSONWithUrl:urlStr parameters:@{@"teamid":_teamId,@"token":token} success:^(id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSNumber* result = [dict objectForKey:@"Result"];
        if (!result.boolValue) {
            NSString* str = [dict objectForKey:@"Message"];
            [Dialog simpleToast:str withDuration:1.5];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^{
        [Dialog simpleToast:@"退出团队失败！" withDuration:1.5];
    }];
}
- (IBAction)memberButton:(id)sender {
    
}
- (IBAction)fansButton:(id)sender {
    
}

- (IBAction)publicButton:(id)sender {
    
}
- (IBAction)footButton:(id)sender {
    
}

- (void)manageBtnClicked {
    TeamManagerTableViewController* VC = [[TeamManagerTableViewController alloc]init];
    VC.teamId = self.teamId;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return teamActivity.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"teamHCell";
    TeamHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TeamHomeTableViewCell" owner:self options:nil][0];
    }
    NSDictionary *dic = teamActivity[indexPath.row];
    cell.name.text = [dic objectForKey:@"Title"];
    cell.address.text = [NSString stringWithFormat:@"%@ | 已报名%d",[dic objectForKey:@"ClassName"],[[dic objectForKey:@"WillNum"]intValue]];
    cell.price.text = [NSString stringWithFormat:@"%d - %d元",[[dic objectForKey:@"EntryMoneyMin"]intValue],[[dic objectForKey:@"EntryMoneyMax"]intValue]];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Cover"]] placeholderImage:[UIImage imageNamed:@"img_5"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = teamActivity[indexPath.row];
    ActiveDetailViewController *vc = [[ActiveDetailViewController alloc]init];
    vc.Id = [[dic objectForKey:@"Id"]intValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)queryTeamInfo {
    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_QUERY_TEAMINFO_URL];
    NSDictionary *dic = @{@"token":[HttpClient getTokenStr],
                          @"teamid":self.teamId};
    [HttpClient postJSONWithUrl:urlStr parameters:dic success:^(id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSNumber* codeNum = [dict objectForKey:@"code"];
        if (codeNum.intValue == 0) {
            teamInfo = [dict objectForKey:@"result"];
            [self refreshUI];
        }
    } fail:^{
        [Dialog simpleToast:@"获取团队信息失败！" withDuration:1.5];
    }];
}

- (void)queryTeamActivity {
    //暂不使用分页,设置第一页获取1000个数据
    NSInteger pageSize = 1000;
    //
    
    NSString* strToken = [HttpClient getTokenStr];
    NSDictionary* parameter = @{@"token":strToken,@"page":[NSNumber numberWithInteger:1/*pageIndex*/],@"PageSize":[NSNumber numberWithInteger:pageSize],@"ActivityType":@1,
                                @"TeamId":self.teamId};
    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_QUERY_ACTIVITY_URL];
    [HttpClient postJSONWithUrl:urlStr parameters:parameter success:^(id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSNumber* codeNum = [dict objectForKey:@"code"];
        if (codeNum.intValue == 0) {
            teamActivity = [dict objectForKey:@"result"];
            [self.tableView reloadData];
        }
    } fail:^{
        [Dialog simpleToast:@"查询活动列表失败！" withDuration:1.5];
    }];
}

- (void)refreshUI {
    self.nameLabel.text = [teamInfo objectForKey:@"Name"];
    self.signatureLabel.text = [teamInfo objectForKey:@"Intro"];
    NSString *url = [teamInfo objectForKey:@"AvatarUrl"];
    if (!url||[url isKindOfClass:[NSNull class]]||url.length==0) {
        self.headerImage.image = [FRUtils circleImage:[UIImage imageNamed:@"img_teamavatar_120"] withParam:1];
        return;
    }
    
    NSURL* dataUrl = [NSURL URLWithString:url];
    self.headerImage.image = [FRUtils circleImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:dataUrl]] withParam:1];
}

@end
