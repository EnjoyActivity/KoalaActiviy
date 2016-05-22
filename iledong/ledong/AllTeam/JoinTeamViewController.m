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
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupTextView {
    self.textView.delegate = self;
    self.textView.frame = CGRectMake(0, 64, APP_WIDTH, self.textView.frame.size.height);
    self.tipLabel.frame = CGRectMake(10, 64+10, self.tipLabel.frame.size.width, self.tipLabel.frame.size.height);
}

- (void)setupNavigationBar {
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor redColor]];
    [customLab setText:@"加入团队"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    self.navigationItem.titleView = customLab;
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
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
