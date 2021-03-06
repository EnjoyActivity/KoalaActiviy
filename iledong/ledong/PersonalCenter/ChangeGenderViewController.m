//
//  ChangeGenderViewController.m
//  ledong
//
//  Created by dengjc on 16/5/19.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "ChangeGenderViewController.h"
#import "ChangeNickNameViewController.h"

@interface ChangeGenderViewController ()
{
    UIImageView *maleImageView;
    UIImageView *femaleImageView;
}
@end

@implementation ChangeGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"您的性别";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    if (_isGuide) {
        self.leftButton.hidden = YES;
    }
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setIsFemale:(BOOL)isFemale {
    _isFemale = isFemale;
    if (_isFemale) {
        maleImageView.image = [UIImage imageNamed:@"ic_male"];
        femaleImageView.image = [UIImage imageNamed:@"ic_female_on"];
    } else {
        maleImageView.image = [UIImage imageNamed:@"ic_male_on"];
        femaleImageView.image = [UIImage imageNamed:@"ic_female"];
    }
}

- (void)setupUI {
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    tipLabel.text = @"您的性别是:";
    tipLabel.textColor = RGB(51, 51, 51, 1);
    tipLabel.font = [UIFont systemFontOfSize:15];
    [tipLabel sizeToFit];
    tipLabel.center = CGPointMake(APP_WIDTH/2, 170+64);
    
    maleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(90, CGRectGetMaxY(tipLabel.frame) + 20, 50, 50)];
    maleImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *maleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseMale:)];
    [maleImageView addGestureRecognizer:maleTap];
    
    femaleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(APP_WIDTH - 90 -50, CGRectGetMaxY(tipLabel.frame) + 20, 50, 50)];
    femaleImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *femaleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseFemale:)];
    [femaleImageView addGestureRecognizer:femaleTap];
    
    if (_isFemale) {
        maleImageView.image = [UIImage imageNamed:@"ic_male"];
        femaleImageView.image = [UIImage imageNamed:@"ic_female_on"];
    } else {
        maleImageView.image = [UIImage imageNamed:@"ic_male_on"];
        femaleImageView.image = [UIImage imageNamed:@"ic_female"];
    }
    
    //完成
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, APP_HEIGHT - 45, APP_WIDTH, 45)];
    doneBtn.backgroundColor = [UIColor redColor];
    if (_isGuide) {
        [doneBtn setTitle:@"下一步" forState:UIControlStateNormal];
    } else {
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tipLabel];
    [self.view addSubview:maleImageView];
    [self.view addSubview:femaleImageView];
    [self.view addSubview:doneBtn];
}

#pragma mark - button method
- (void)doneBtnClick:(UIButton*)sender {
    if (_isGuide) {
        if (_isFemale) {
            [FRUtils setGender:0];
        } else {
            [FRUtils setGender:1];
        }
        ChangeNickNameViewController *vc = [[ChangeNickNameViewController alloc]init];
        vc.isGuide = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [HttpClient JSONDataWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_USERINFO_URL] parameters:@{@"token":[HttpClient getTokenStr]} success:^(id json){

            NSDictionary* temp = (NSDictionary*)json;
            if ([[temp objectForKey:@"code"]intValue]!=0) {
                [Dialog toast:[temp objectForKey:@"msg"]];
                return;
            }
            NSMutableDictionary *postDic = [NSMutableDictionary dictionaryWithDictionary:[temp objectForKey:@"result"]];
            if (_isFemale) {
                [postDic setObject:@0 forKey:@"Sex"];
                [postDic setObject:@"女" forKey:@"SexName"];
            } else {
                [postDic setObject:@1 forKey:@"Sex"];
                [postDic setObject:@"男" forKey:@"SexName"];
            }
            [postDic setObject:[HttpClient getTokenStr] forKey:@"token"];
            [HttpClient postJSONWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_SAVEUSERINFO_URL] parameters:postDic success:^(id response){
                NSDictionary* temp = (NSDictionary*)json;
                if ([[temp objectForKey:@"code"]intValue]!=0) {
                    [Dialog toast:[temp objectForKey:@"msg"]];
                    return;
                }
                if (self.block) {
                    self.block(_isFemale);
                }
                if (_isFemale) {
                    [FRUtils setGender:0];
                } else {
                    [FRUtils setGender:1];
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            }fail:^{
                [Dialog toast:@"网络失败，请稍后再试"];
            }];
            
        }fail:^{
            [Dialog toast:@"网络失败，请稍后再试"];
        }];

    }
}

- (void)chooseMale:(id)sender {
    if (self.isFemale) {
        self.isFemale = NO;
    }
}

- (void)chooseFemale:(id)sender {
    if (!self.isFemale) {
        self.isFemale = YES;
    }
}
@end
