//
//  PersonalCenterController.m
//  ledong
//
//  Created by dongguoju on 16/2/29.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "PersonalCenterController.h"
#import "PersonalInfomationViewController.h"
#import "FocusViewController.h"
#import "IntergralViewController.h"
#import "FootprintViewController.h"
#import "MyMessageViewController.h"
#import "MySettingViewController.h"
#import "LoginAndRegistViewController.h"
#import "MyWalletViewController.h"
#import "FRUtils.h"
#import "FansViewController.h"
#import "MyCollectionViewController.h"
#import "ChangeGenderViewController.h"
#import "ActivityMessageViewController.h"


@interface PersonalCenterController ()
{
    NSArray *dataArr;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PersonalCenterController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *myBar = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"ic_mine_on"] tag:2];
        myBar.selectedImage = [UIImage imageNamed:@"ic_mine"];
        self.tabBarItem = myBar;
    
        dataArr = @[@"我的活动",@"我的荣誉",@"我的收藏",@"我的优惠券"];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showGuide:) name:@"ShowGuideNotification" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUserInfo:) name:@"RefreshUserinfo" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshHeaderImage:) name:@"RefreshHeaderImage" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshNickName:) name:@"RefreshNickName" object:nil];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (![HttpClient isLogin]) {
        LoginAndRegistViewController *loginView = [[LoginAndRegistViewController alloc]init];
        loginView.isPersonalCenterPage = YES;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginView];
        [self presentViewController:nav animated:YES completion:nil];
    }
//    else {
//        if (![FRUtils getNickName]||[FRUtils getNickName].length == 0||[[FRUtils getNickName] isEqualToString:[FRUtils getPhoneNum]]) {
//            [self showGuide:nil];
////            [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowGuideNotification" object:nil];
////            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshUserinfo" object:nil];
//        }
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.tableView.indicatorStyle = UITableViewCellAccessoryDisclosureIndicator;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
//    self.headerImage.image = [FRUtils circleImage:[UIImage imageNamed:@"user02_44"] withParam:1];
    self.signingImage.image = [FRUtils resizeImageWithImageName:@"btn_white"];
    //关注、积分、足迹、粉丝button设置
    [self.focusBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.intergralBtn setTitle:@"积分" forState:UIControlStateNormal];
    [self.footPrintBtn setTitle:@"足迹" forState:UIControlStateNormal];
    [self.fansButton setTitle:@"粉丝" forState:UIControlStateNormal];
    [self.focusBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.intergralBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.footPrintBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.fansButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    
    
    [self.messageButton setImage:[UIImage imageNamed:@"ic_message"] forState:UIControlStateNormal];
    [self.messageButton setImageEdgeInsets:UIEdgeInsetsMake(-20, 150, 0, 0)];
    [self.messageButton setTitle:@"160条新消息" forState:UIControlStateNormal];
    [self.messageButton setTitleEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, 0)];
    self.messageButton.hidden = YES;
    
    CGFloat hight = self.headerView.frame.size.height + self.signView.frame.size.height + self.tableView.frame.size.height + 100;
    self.scrollView.contentSize = CGSizeMake(APP_WIDTH, hight);
    
    _nameLabel.text = [FRUtils getNickName];
    _signatureLabel.text = [FRUtils getSign];
    
    UIImage *headImage = [FRUtils getHeaderImage];
    if (headImage) {
        _headerImage.image = [FRUtils circleImage:headImage withParam:1];
    } else {
        _headerImage.image = [FRUtils circleImage:[UIImage imageNamed:@"img_avatar_44"] withParam:1];
    }

    if ([HttpClient isLogin]) {
        [FRUtils queryUserInfoFromWeb:^{
            [self refreshUserInfo:nil];
            if (![FRUtils getNickName]||[FRUtils getNickName].length == 0||[[FRUtils getNickName] isEqualToString:[FRUtils getPhoneNum]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ChangeGenderViewController *vc = [[ChangeGenderViewController alloc]init];
                    vc.isGuide = YES;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:NO];
                });
                
//                    [self showGuide:nil];
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowGuideNotification" object:nil];
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshUserinfo" object:nil];
                }
        }failBlock:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }
    return 9;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = dataArr[indexPath.row];
    } else if (indexPath.section == 1){
        cell.textLabel.text = @"我的钱包";
    } else {
        cell.textLabel.text = @"设置";
    }
    cell.textLabel.textColor = RGB(51, 51, 51, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = RGB(153, 153, 153, 1);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                // 进入我的活动
                ActivityMessageViewController *activityMessageViewController = [[ActivityMessageViewController alloc] init];
                activityMessageViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:activityMessageViewController animated:YES];
            }
                break;
            case 1:
            {
            }
                break;
            case 2:
            {
                MyCollectionViewController *myCollectionVC = [[MyCollectionViewController alloc] init];
                myCollectionVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myCollectionVC animated:YES];
            }
                break;
            case 3:
            {

            }
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        // 点击进入钱包
        MyWalletViewController *myWalletViewController = [[MyWalletViewController alloc] init];
        myWalletViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myWalletViewController animated:YES];
    } else {
        // 进入我的设置
        MySettingViewController *mySettingViewController = [[MySettingViewController alloc] init];
        [self.navigationController pushViewController:mySettingViewController animated:YES];
    }
}


#pragma mark - button click

- (IBAction)personalInfomationButtonClick:(id)sender
{
    // 点击进入个人信息
    PersonalInfomationViewController *personalInfoController = [[PersonalInfomationViewController alloc] init];
    personalInfoController.image = _headerImage.image;
    personalInfoController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalInfoController animated:YES];
    
    // 进入登录注册
//    LoginAndRegistViewController *loginAndRegistController = [[LoginAndRegistViewController alloc] init];
//    [self.navigationController pushViewController:loginAndRegistController animated:YES];
}

- (IBAction)footPrintButtonClick:(id)sender
{
    // 点击进入我的相册/足迹
    FootprintViewController *footprintViewController = [[FootprintViewController alloc] init];
    footprintViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:footprintViewController animated:YES];
}

- (IBAction)intergralButtonClick:(id)sender
{
    // 点击进入积分
    IntergralViewController *intergralViewController = [[IntergralViewController alloc] init];
    intergralViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:intergralViewController animated:YES];
}

- (IBAction)focusButtonClick:(id)sender
{
    // 点击进入关注
    FocusViewController *focusViewController = [[FocusViewController alloc]init];
    focusViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:focusViewController animated:YES];
}
- (IBAction)fansButtonClick:(id)sender
{
    FansViewController *fansViewController = [[FansViewController alloc] init];
    [self.navigationController pushViewController:fansViewController animated:YES];
}

- (IBAction)myMessageButtonClick:(id)sender
{
    // 进入我的消息
    MyMessageViewController *myMessageViewController = [[MyMessageViewController alloc] init];
    myMessageViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myMessageViewController animated:YES];
}

- (IBAction)signButtonClick:(id)sender
{
}

//通知
- (void)showGuide:(NSNotification *)notification {
    ChangeGenderViewController *vc = [[ChangeGenderViewController alloc]init];
    vc.isGuide = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)refreshUserInfo:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        _nameLabel.text = [FRUtils getNickName];
        _signatureLabel.text = [FRUtils getSign];
        UIImage *headImage = [FRUtils getHeaderImage];
        if (headImage) {
            _headerImage.image = [FRUtils circleImage:headImage withParam:1];
        } else {
            _headerImage.image = [FRUtils circleImage:[UIImage imageNamed:@"img_avatar_44"] withParam:1];
        }
    });

}

- (void)refreshHeaderImage:(NSNotification *)notification {

    _headerImage.image = [FRUtils circleImage:[notification object] withParam:1];
}

- (void)refreshNickName:(NSNotification *)notification {
    _nameLabel.text = [notification object];
}


@end
