//
//  AffirmPayViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/18.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "AffirmPayViewController.h"

@interface AffirmPayViewController ()
{
    int number;
}
@end

@implementation AffirmPayViewController

- (void)viewDidLoad {
    self.titleName = @"确认订单";
    [super viewDidLoad];
    number = 900;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(calculateTime:) userInfo:nil repeats:YES];
    [timer fire];
    
    [self.walletButton setImage:[UIImage imageNamed:@"ckb_uncheck"] forState:UIControlStateNormal];
    [self.walletButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.weChatButton setImage:[UIImage imageNamed:@"ckb_uncheck"] forState:UIControlStateNormal];
    [self.unionPayButton setImage:[UIImage imageNamed:@"ckb_uncheck"] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ButtonClick

- (IBAction)walletButtonClick:(id)sender {
}

- (IBAction)weChatButtonClick:(id)sender {
}

- (IBAction)unionButtonClick:(id)sender {
}


- (IBAction)submitButtonClick:(id)sender {
}


- (void)calculateTime:(NSTimer *)timers
{
    if (number == -1)
    {
        number = 60;
        [timers invalidate];
        timers = nil;
    }
    else
    {
        self.payTime.text = [NSString stringWithFormat:@"付款剩余时间 %d分%d秒",number/60,number%60];
        number --;
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
