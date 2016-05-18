//
//  JoinTeamViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/14.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "JoinTeamViewController.h"
#import "ApplyViewController.h"
#import "AuditViewController.h"

@interface JoinTeamViewController ()<UITextViewDelegate>

@end

@implementation JoinTeamViewController

- (void)viewDidLoad
{
    self.titleName = @"加入团队";
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.textView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - ButtonClick

- (IBAction)submitButtonClick:(id)sender
{
    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_TEAMJOINTEAM_URL];
    NSDictionary *dic = @{@"token":[HttpClient getTokenStr],@"teamid":@"",@"message":_textView.text};
    [HttpClient postJSONWithUrl:urlStr parameters:dic success:^(id responseObject)
     {
         AuditViewController *auditViewController = [[AuditViewController alloc] init];
         [self.navigationController pushViewController:auditViewController animated:YES];
     } fail:^{
         [Dialog simpleToast:@"获取我的团队失败！" withDuration:1.5];
     }];

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
