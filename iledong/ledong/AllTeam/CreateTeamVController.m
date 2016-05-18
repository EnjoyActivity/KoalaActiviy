//
//  CreateTeamVController.m
//  ledong
//
//  Created by luojiao  on 16/3/30.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "CreateTeamVController.h"

@interface CreateTeamVController ()

@end

@implementation CreateTeamVController

- (void)viewDidLoad {
    self.titleName = @"创建团队";
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    // Do any additional setup after loading the view from its nib.
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

@end
