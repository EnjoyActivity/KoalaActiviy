//
//  ScanViewController.m
//  ledong
//
//  Created by luojiao  on 16/3/28.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "ScanViewController.h"
#import "ZHScanView.h"

@interface ScanViewController ()
@property (strong, nonatomic) IBOutlet UIButton *goBackButton;

@end

@implementation ScanViewController

- (void)viewDidLoad
{
    self.titleName = @"扫描";
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    [self.goBackButton setBackgroundImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    ZHScanView *scanf = [ZHScanView scanViewWithFrame:CGRectMake(0, 62, APP_WIDTH, APP_HEIGHT)];
//    scanf.promptMessage = @"您可以直接输入或者选择扫描二维码";
    [self.view addSubview:scanf];
    
    [scanf startScaning];
    
    [scanf outPutResult:^(NSString *result)
    {
        NSLog(@"%@",result);
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden= YES;
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)gobackButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)openPhoto:(id)sender {
}


@end
