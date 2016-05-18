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


@interface PersonalCenterController ()

@end

@implementation PersonalCenterController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *myBar = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"ic_mine_on"] tag:2];
        myBar.selectedImage = [UIImage imageNamed:@"ic_mine"];
        self.tabBarItem = myBar;
        
//        UIView *bgView = [[UIView alloc] initWithFrame:myBar.bounds];
//        bgView.backgroundColor = [UIColor whiteColor];
//        [myBar insertSubview:bgView atIndex:0];
//        self.tabBar.opaque = YES;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    self.headerImage.image = [FRUtils circleImage:[UIImage imageNamed:@"user02_44"] withParam:1];
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
    
    //活动、收藏、优惠、荣誉button设置
    [self.activeButton setTitle:@"我的活动" forState:UIControlStateNormal];
    [self.honorButton setTitle:@"我的荣誉" forState:UIControlStateNormal];
    [self.collectButton setTitle:@"我的收藏" forState:UIControlStateNormal];
    [self.chepButton setTitle:@"我的优惠券" forState:UIControlStateNormal];
    [self.activeButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, APP_WIDTH - 80)];
    [self.honorButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, APP_WIDTH - 80)];
    [self.chepButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, APP_WIDTH - 90)];
    [self.collectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, APP_WIDTH - 80)];
    
    [self.activeButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [self.personalInfoBtn setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [self.honorButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [self.chepButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [self.activeButton setImageEdgeInsets:UIEdgeInsetsMake(0,APP_WIDTH - 28, 0, 0)];
    [self.personalInfoBtn setImageEdgeInsets:UIEdgeInsetsMake(0,APP_WIDTH - 38, 0, 0)];
    [self.collectButton setImageEdgeInsets:UIEdgeInsetsMake(0, APP_WIDTH - 28, 0, 0)];
    [self.honorButton setImageEdgeInsets:UIEdgeInsetsMake(0, APP_WIDTH - 28, 0, 0)];
    [self.chepButton setImageEdgeInsets:UIEdgeInsetsMake(0, APP_WIDTH - 28, 0, 0)];
    // 设置、钱包设置
    [self.setButton setTitle:@"设置" forState:UIControlStateNormal];
    [self.walletButton setTitle:@"我的钱包" forState:UIControlStateNormal];
    [self.setButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, APP_WIDTH - 50)];
    [self.walletButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, APP_WIDTH - 80)];
    [self.setButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [self.walletButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [self.setButton setImageEdgeInsets:UIEdgeInsetsMake(0, APP_WIDTH - 30, 0, 0)];
    [self.walletButton setImageEdgeInsets:UIEdgeInsetsMake(0, APP_WIDTH - 30, 0, 0)];
    
    [self.messageButton setImage:[UIImage imageNamed:@"ic_message"] forState:UIControlStateNormal];
    [self.messageButton setImageEdgeInsets:UIEdgeInsetsMake(-20, 150, 0, 0)];
    [self.messageButton setTitle:@"160条新消息" forState:UIControlStateNormal];
    [self.messageButton setTitleEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, 0)];
    
    CGFloat hight = self.headerView.frame.size.height + self.signView.frame.size.height + self.buttonView.frame.size.height + 100;
    self.scrollView.contentSize = CGSizeMake(APP_WIDTH, hight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button click

- (IBAction)personalInfomationButtonClick:(id)sender
{
    // 点击进入个人信息
    PersonalInfomationViewController *personalInfoController = [[PersonalInfomationViewController alloc] init];
    [self.navigationController pushViewController:personalInfoController animated:YES];
    
    // 进入登录注册
//    LoginAndRegistViewController *loginAndRegistController = [[LoginAndRegistViewController alloc] init];
//    [self.navigationController pushViewController:loginAndRegistController animated:YES];
}

- (IBAction)footPrintButtonClick:(id)sender
{
    // 点击进入我的相册/足迹
    FootprintViewController *footprintViewController = [[FootprintViewController alloc] init];
    [self.navigationController pushViewController:footprintViewController animated:YES];
}

- (IBAction)intergralButtonClick:(id)sender
{
    // 点击进入积分
    IntergralViewController *intergralViewController = [[IntergralViewController alloc] init];
    [self.navigationController pushViewController:intergralViewController animated:YES];
}

- (IBAction)focusButtonClick:(id)sender
{
    // 点击进入关注
    FocusViewController *focusViewController = [[FocusViewController alloc]init];
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
    [self.navigationController pushViewController:myMessageViewController animated:YES];
}
- (IBAction)mySettingButtonClick:(id)sender
{
    // 进入我的设置
    MySettingViewController *mySettingViewController = [[MySettingViewController alloc] init];
    [self.navigationController pushViewController:mySettingViewController animated:YES];
}

- (IBAction)myWalletButtonClick:(id)sender
{
    // 点击进入钱包
    MyWalletViewController *myWalletViewController = [[MyWalletViewController alloc] init];
    [self.navigationController pushViewController:myWalletViewController animated:YES];
}
- (IBAction)signButtonClick:(id)sender
{
}
- (IBAction)activeButtonClick:(id)sender
{
}
- (IBAction)honorButtonClick:(id)sender
{
}
- (IBAction)collectButtonClick:(id)sender
{
    MyCollectionViewController *myCollectionVC = [[MyCollectionViewController alloc] init];
    [self.navigationController pushViewController:myCollectionVC animated:YES];
}
- (IBAction)cheapButtonClick:(id)sender
{
}




@end
