//
//  ContactTypeViewController.m
//  ledong
//
//  Created by liuxu on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ContactTypeViewController.h"

@interface ContactTypeViewController ()

@end

@implementation ContactTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"联系方式";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH-30, 40)];
    [self.view addSubview:textField];
    textField.placeholder = @"请输入联系电话";
    textField.font = [UIFont systemFontOfSize:14.0];
    textField.center = CGPointMake(APP_WIDTH/2, APP_HEIGHT/2-20);
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, textField.frame.origin.y+textField.frame.size.height+10, 100, 40)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.center = CGPointMake(APP_WIDTH/2, btn.center.y);
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
