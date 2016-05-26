//
//  ModificationPhoneVC2.m
//  ledong
//
//  Created by dengjc on 16/5/20.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ModificationPhoneVC2.h"

@interface ModificationPhoneVC2 ()
{
    int timeNum;
}
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UITextField *codeField;
@property (strong, nonatomic) IBOutlet UIButton *goBackBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imgSend;
@property (strong, nonatomic) IBOutlet UIButton *sendCodeBtn;

@end

@implementation ModificationPhoneVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    timeNum = 60;
    [self.goBackBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [self.goBackBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
    self.imgSend.image = [FRUtils resizeImageWithImageName:@"btn_white"];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)sendCode:(id)sender {
    [self.phoneField resignFirstResponder];
    [self.codeField resignFirstResponder];
    if ([self.phoneField.text isEqualToString:@""])
    {
        [Dialog simpleToast:@"手机号不能为空！" withDuration:1.5];
        return;
    }
    if (![FRUtils isMobileNumber:self.phoneField.text])
    {
        [FRUtils simpleToast:@"请正确输入手机号码" withDuration:kDuration];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSDictionary *parameters = @{@"phone": self.phoneField.text};
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

- (IBAction)okBtnClick:(id)sender {
    NSInteger index = self.navigationController.viewControllers.count;
    UIViewController *vc = self.navigationController.viewControllers[index - 3];
    [self.navigationController popToViewController:vc animated:YES];
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendButtonSet:(NSTimer*)timers
{
    if (timeNum == -1)
    {
        self.sendCodeBtn.enabled = YES;
        [self.sendCodeBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        timeNum = 60;
        [timers invalidate];
        timers = nil;
    }
    else
    {
        self.sendCodeBtn.enabled = NO;
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%d s",timeNum] forState:UIControlStateNormal];
        timeNum--;
    }
    
}

@end
