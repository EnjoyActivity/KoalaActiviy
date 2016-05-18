//
//  PublishViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/7.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "PublishViewController.h"

@interface PublishViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation PublishViewController

- (void)viewDidLoad {
    self.titleName = @"发布公告";
    [super viewDidLoad];
    self.textField.delegate = self;
    self.textView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)PublicButtonClick:(id)sender {
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
