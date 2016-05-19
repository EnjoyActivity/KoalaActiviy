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

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

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
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

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

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.tipLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0)
        self.tipLabel.hidden = NO;
}

@end
