//
//  LoginAndRegistViewController.h
//  ledong
//
//  Created by TDD on 16/3/3.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^jumpToHomePage)();

@interface LoginAndRegistViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *getNum;
@property (weak, nonatomic) IBOutlet UITextField *putNumber;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *gobackButton;
@property (weak, nonatomic) IBOutlet UIImageView *btnImage;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (assign,nonatomic) BOOL isPersonalCenterPage;

@property (strong,nonatomic) jumpToHomePage block;

@property (nonatomic) UITabBarController *tabbarController;

@end
