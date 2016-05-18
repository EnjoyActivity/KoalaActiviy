//
//  MySettingViewController.m
//  ledong
//
//  Created by TDD on 16/3/3.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "MySettingViewController.h"
#import "ReBindingViewController.h"

@interface MySettingViewController ()

@end

@implementation MySettingViewController

- (void)viewDidLoad {
    self.titleName = @"我的设置";
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self setButton];
}


- (void)setButton
{
    [self.aboutUsButton setTitle:@"联系我们" forState:UIControlStateNormal];
    [self.clearButton setTitle:@"清除缓存" forState:UIControlStateNormal];
    [self.aboutUsButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, APP_WIDTH - 80)];
    [self.clearButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, APP_WIDTH - 90)];
    [self.aboutUsButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [self.aboutUsButton setImageEdgeInsets:UIEdgeInsetsMake(0, APP_WIDTH - 38, 0, 0)];
    
}

#pragma mark - button Click
- (IBAction)aboutUsButtonClick:(id)sender {
}
- (IBAction)noticeSwitch:(id)sender {
}

- (IBAction)messageSwitch:(id)sender {
}

- (IBAction)clearButtonClick:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
