//
//  SexViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/11.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "SexViewController.h"
#import "UserNameViewController.h"

@interface SexViewController ()
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;

@end

@implementation SexViewController

- (void)viewDidLoad {
    self.titleName = @"用户信息完善";
    [super viewDidLoad];
//    self.tabBarController.tabBar.hidden = YES;
    [self.maleButton setImage:[UIImage imageNamed:@"ic_male_on"] forState:UIControlStateNormal];
    [self.femaleButton setImage:[UIImage imageNamed:@"ic_female_on"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ButtonClick

- (IBAction)maleButtonClick:(id)sender
{
    self.maleButton = sender;
    self.maleButton.selected =! self.maleButton.selected;
    if (self.maleButton.selected)
    {
        [self.maleButton setImage:[UIImage imageNamed:@"ic_male_on"] forState:UIControlStateNormal];
    }
    else
    {
        [self.maleButton setImage:[UIImage imageNamed:@"ic_male"] forState:UIControlStateNormal];
    }
}
- (IBAction)femaleButtonClick:(id)sender
{
    self.femaleButton = sender;
    self.femaleButton.selected =! self.femaleButton.selected;
    if (self.femaleButton.selected)
    {
        [self.femaleButton setImage:[UIImage imageNamed:@"ic_female"] forState:UIControlStateNormal];
    }
    else
    {
        [self.femaleButton setImage:[UIImage imageNamed:@"ic_female_on"] forState:UIControlStateNormal];
    }
}
- (IBAction)nexButtonClick:(id)sender
{
    UserNameViewController *userNameViewController = [[UserNameViewController alloc] init];
    [self.navigationController pushViewController:userNameViewController animated:YES];
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
