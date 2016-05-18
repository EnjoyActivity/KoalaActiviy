//
//  FailureSignViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/18.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "FailureSignViewController.h"
#import "FRUtils.h"

@interface FailureSignViewController ()

@end

@implementation FailureSignViewController

- (void)viewDidLoad {
    self.titleName = @"报名失败";
    [super viewDidLoad];
    [self.creatButton setImage:[FRUtils resizeImageWithImageName:@"btn_white"] forState:UIControlStateNormal];
    [self.creatButton setImage:[FRUtils resizeImageWithImageName:@"btn_white_press"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button

- (IBAction)changeButtonClick:(id)sender {
}

- (IBAction)shareButtonClick:(id)sender {
}

- (IBAction)createTeamButtonClick:(id)sender {
}

- (IBAction)gobackActiv:(id)sender {
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
