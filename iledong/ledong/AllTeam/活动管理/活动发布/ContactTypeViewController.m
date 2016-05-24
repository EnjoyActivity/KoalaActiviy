//
//  ContactTypeViewController.m
//  ledong
//
//  Created by liuxu on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ContactTypeViewController.h"

@interface ContactTypeViewController ()

@property (nonatomic, copy)completeSelect block;
@property (nonatomic, strong)UITextField* textField;

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
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH-30, 40)];
    [self.view addSubview:self.textField];
    self.textField.placeholder = @"请输入联系电话";
    self.textField.font = [UIFont systemFontOfSize:14.0];
    self.textField.center = CGPointMake(APP_WIDTH/2, APP_HEIGHT/2-20);
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.layer.borderColor = UIColorFromRGB(0xEFEFEF).CGColor;
    self.textField.layer.borderWidth = 1;
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.textField.frame.origin.y+self.textField.frame.size.height+10, 100, 40)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.center = CGPointMake(APP_WIDTH/2, btn.center.y);
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 1;
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnClicked {
    [self.view endEditing:YES];
    NSString* str = self.textField.text;
    if (self.block) {
        self.block(str);
    }
}

- (void)setCompleteSelect:(completeSelect)block {
    self.block = block;
}

@end
