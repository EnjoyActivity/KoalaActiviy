//
//  AuditViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/14.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "AuditViewController.h"
#import "AllTeamController.h"

@interface AuditViewController ()

@end

@implementation AuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupNavigationBar {
    //self.navigationController.navigationBarHidden = NO;
    //self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.title = @"等待审核";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goBackHomePageClicked:(id)sender {
    for (UIViewController* Vc in self.navigationController.viewControllers) {
        if ([Vc isKindOfClass:[AllTeamController class]]) {
            [self.navigationController popToViewController:Vc animated:YES];
            return;
        }
    }
}

@end
