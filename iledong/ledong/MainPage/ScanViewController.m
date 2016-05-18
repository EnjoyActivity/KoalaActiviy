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

@end

@implementation ScanViewController

- (void)viewDidLoad
{
    self.titleName = @"扫描";
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    
    ZHScanView *scanf = [ZHScanView scanViewWithFrame:CGRectMake(0, 62, APP_WIDTH, APP_HEIGHT)];
//    scanf.promptMessage = @"您可以直接输入或者选择扫描二维码";
    [self.view addSubview:scanf];
    
    [scanf startScaning];
    
    [scanf outPutResult:^(NSString *result)
    {
        NSLog(@"%@",result);
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)gobackButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
