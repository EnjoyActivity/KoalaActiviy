//
//  ModificationPhoneVC.m
//  ledong
//
//  Created by luojiao  on 16/4/25.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "ModificationPhoneVC.h"
#import "FRUtils.h"

@interface ModificationPhoneVC ()<UITextFieldDelegate>

@end

@implementation ModificationPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [self.gobackButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [self.gobackButton setImageEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
    self.ImageSend.image = [FRUtils resizeImageWithImageName:@"btn_white"];
    
    self.phoneNum.text = [self modifityPhoneNumber:@"15108405112"];
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
}
- (IBAction)gobackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextButton:(id)sender
{
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
