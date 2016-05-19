//
//  LoginAndRegistViewController.m
//  ledong
//
//  Created by TDD on 16/3/3.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "LoginAndRegistViewController.h"
#import "UserProtocolVC.h"
#import "MainPageController.h"


@interface LoginAndRegistViewController ()<UITextFieldDelegate>

{
    int timeNum;
}
@end

@implementation LoginAndRegistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.phoneNum.delegate = self;
    self.putNumber.delegate = self;
    timeNum = 60;
    self.btnImage.image = [FRUtils resizeImageWithImageName:@"btn_white"];
    //设置字体和下划线
    NSString *labelStr = @"点击登录，即代表同意用户协议";
    NSMutableAttributedString *Str = [[NSMutableAttributedString alloc] initWithString:labelStr];
    NSRange redRange = [labelStr rangeOfString:@"用户协议"];
    [Str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    [Str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:redRange];
    self.agreeLabel.attributedText = Str;
    
    [self.gobackButton setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [self.gobackButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.gobackButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonClick

//获取验证码
- (IBAction)getNumberButtonClick:(id)sender
{
    [self.phoneNum resignFirstResponder];
    [self.putNumber resignFirstResponder];
    if ([self.phoneNum.text isEqualToString:@""])
    {
        [Dialog simpleToast:@"手机号不能为空！" withDuration:1.5];
        return;
    }
    if (![FRUtils isMobileNumber:self.phoneNum.text])
    {
        [FRUtils simpleToast:@"请正确输入手机号码" withDuration:kDuration];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *parameters = @{@"phone": self.phoneNum.text};
    NSString *str = [API_BASE_URL stringByAppendingString:API_VALIDATION_URL];
    [manager GET:str parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        if ([[responseObject objectForKey:@"code"] intValue] == 1)
        {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendButtonSet:) userInfo:nil repeats:YES];
            [timer fire];
            [Dialog simpleToast:@"验证码已发送！" withDuration:1.5];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error)
    {
        [Dialog simpleToast:@"验证码获取失败！" withDuration:1.5];
    }];
}

//登录
- (IBAction)userLoginButtonClick:(id)sender
{
    [self.phoneNum resignFirstResponder];
    [self.putNumber resignFirstResponder];
    if ([self.phoneNum.text isEqualToString:@""]||[self.putNumber.text isEqualToString:@""])
    {
        [Dialog simpleToast:@"手机号或验证码不能为空！" withDuration:1.5];
        return;
    }
    if (![FRUtils isMobileNumber:self.phoneNum.text])
    {
        [FRUtils simpleToast:@"请正确输入手机号码" withDuration:kDuration];
        return;
    }
    NSDictionary *parameters = @{@"phone": self.phoneNum.text,@"validateCode":self.putNumber.text};
    NSString *str = [API_BASE_URL stringByAppendingString:API_USER_LOGIN_URL];
    [HttpClient loginOrRegistWithUrl:str parameters:parameters success:^(id json)
    {
        NSLog(@"登陆成功！");
        [self dismiss];
        
    } fail:^{
        [Dialog simpleToast:@"登录失败，请检查网络！" withDuration:1.5];
    }];
}

- (IBAction)userProtocolButton:(id)sender
{
    UserProtocolVC *userProtocolVC = [[UserProtocolVC alloc] init];
    [self.navigationController pushViewController:userProtocolVC animated:YES];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)sendButtonSet:(NSTimer*)timers
{
    if (timeNum == -1)
    {
        self.getNum.enabled = YES;
        [self.getNum setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        timeNum = 60;
        [timers invalidate];
        timers = nil;
    }
    else
    {
        self.getNum.enabled = NO;
        [self.getNum setTitle:[NSString stringWithFormat:@"%d s",timeNum] forState:UIControlStateNormal];
        timeNum--;
    }
    
}
@end
