//
//  UserNameViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/11.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "UserNameViewController.h"
#import "UserHeaderViewController.h"

@interface UserNameViewController ()<UITextFieldDelegate>

@end

@implementation UserNameViewController

- (void)viewDidLoad {
    self.titleName = @"用户信息完善";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextButtonClick:(id)sender
{
    if ([self.textFiedl.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请填写昵称！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        UserHeaderViewController *userHeaderViewController = [[UserHeaderViewController alloc] init];
        [self.navigationController pushViewController:userHeaderViewController animated:YES];
    }
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
