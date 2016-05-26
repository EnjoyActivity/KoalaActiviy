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
@property (nonatomic, strong)UITextField* complainTelTextField;

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
    self.textField.center = CGPointMake(APP_WIDTH/2, APP_HEIGHT/2-60);
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.layer.borderColor = UIColorFromRGB(0xEFEFEF).CGColor;
    self.textField.layer.borderWidth = 1;
    
    self.complainTelTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.textField.frame.origin.x, self.textField.frame.size.height+self.textField.frame.origin.y+10, APP_WIDTH-30, 40)];
    [self.view addSubview:self.complainTelTextField];
    self.complainTelTextField.placeholder = @"请输入举报电话";
    self.complainTelTextField.font = [UIFont systemFontOfSize:14.0];
    self.complainTelTextField.textAlignment = NSTextAlignmentCenter;
    self.complainTelTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.complainTelTextField.layer.borderColor = UIColorFromRGB(0xEFEFEF).CGColor;
    self.complainTelTextField.layer.borderWidth = 1;
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.complainTelTextField.frame.origin.y+self.complainTelTextField.frame.size.height+10, 100, 40)];
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
    if (self.textField.text.length == 0 ||
        self.complainTelTextField.text.length == 0) {
        [Dialog simpleToast:@"请填写相关参数！" withDuration:1.5];
        return;
    }
    if (self.block) {
        self.block(self.textField.text, self.complainTelTextField.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setCompleteSelect:(completeSelect)block {
    self.block = block;
}

@end
