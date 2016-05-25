//
//  ModificationPhoneVC.m
//  ledong
//
//  Created by luojiao  on 16/4/25.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "ModificationPhoneVC.h"
#import "ModificationPhoneVC2.h"
#import "FRUtils.h"

@interface ModificationPhoneVC ()<UITextFieldDelegate>
{
    int timeNum;
}
@end

@implementation ModificationPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    timeNum = 60;
    [self.gobackButton setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [self.gobackButton setImageEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
    self.ImageSend.image = [FRUtils resizeImageWithImageName:@"btn_white"];
    
    self.phoneNum.text = [self modifityPhoneNumber:[FRUtils getPhoneNum]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)modifityPhoneNumber :(NSString *)number
{
    NSString *lastStr = [number substringFromIndex:7];
    NSString *headStr = [number substringToIndex:3];
    NSString *StrNew = [NSString stringWithFormat:@"%@****%@",headStr,lastStr];
    return StrNew;
}

#pragma mark - buttonClick

- (IBAction)sendButtonClick:(id)sender
{
    [self.textField resignFirstResponder];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *parameters = @{@"phone": [FRUtils getPhoneNum]};
    NSString *str = [API_BASE_URL stringByAppendingString:API_VALIDATION_URL];
    [Dialog progressToast:@""];
    [manager GET:str parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         if ([[responseObject objectForKey:@"code"] intValue] == 0)
         {
             NSLog(@"%@",responseObject);
             NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendButtonSet:) userInfo:nil repeats:YES];
             [timer fire];
             [Dialog simpleToast:@"验证码已发送！" withDuration:1.5];
         }
         
     } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error)
     {
         [Dialog simpleToast:@"验证码获取失败！" withDuration:1.5];
     }];
}
- (IBAction)gobackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextButton:(id)sender
{
    if (self.textField.text.length == 0) {
        [Dialog simpleToast:@"验证码为空！" withDuration:1.5];
        return;
    }
    
    [[HttpClient shareHttpClient] showMessageHUD:@""];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes  =[NSSet setWithObjects:@"application/json",@"text/html",nil];
    
    NSString *str = [API_BASE_URL stringByAppendingString:API_USER_LOGIN_URL];
    NSDictionary *parameters = @{@"phone": self.phoneNum.text,@"validateCode":self.textField.text};
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@",responseObject);
         if ([[responseObject objectForKey:@"code"] intValue] == 0)
         {
             ModificationPhoneVC2 *vc = [[ModificationPhoneVC2 alloc]init];
             vc.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:vc animated:YES];
         }
         else
         {
             [FRUtils simpleToast:[responseObject objectForKey:@"msg"] withDuration:kDuration];
         }
         
         [[HttpClient shareHttpClient] hiddenMessageHUD];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [FRUtils simpleToast:@"网络失败，请稍后再试！" withDuration:kDuration];
         [[HttpClient shareHttpClient] hiddenMessageHUD];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)sendButtonSet:(NSTimer*)timers
{
    if (timeNum == -1)
    {
        self.sendButton.enabled = YES;
        [self.sendButton setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        timeNum = 60;
        [timers invalidate];
        timers = nil;
    }
    else
    {
        self.sendButton.enabled = NO;
        [self.sendButton setTitle:[NSString stringWithFormat:@"%d s",timeNum] forState:UIControlStateNormal];
        timeNum--;
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
