//
//  ChangeNickNameViewController.m
//  ledong
//
//  Created by dengjc on 16/5/19.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "ChangeNickNameViewController.h"
#import "ChangeAvatarViewController.h"

@interface ChangeNickNameViewController ()
{
    NSString *nickName;
    UITextField *nameField;
}
@end

@implementation ChangeNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"设置昵称";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.view addGestureRecognizer:tapGes];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    tipLabel.text = @"输入昵称:";
    tipLabel.textColor = RGB(51, 51, 51, 1);
    tipLabel.font = [UIFont systemFontOfSize:15];
    [tipLabel sizeToFit];
    tipLabel.center = CGPointMake(APP_WIDTH/2, 170);
    
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(tipLabel.frame) + 20, APP_WIDTH - 36, 40)];
    nameField.placeholder = @"昵称";
    nameField.tintColor = [UIColor redColor];
    nameField.font = [UIFont systemFontOfSize:16];
    nameField.textAlignment = NSTextAlignmentCenter;
    
    UILabel *underLine = [[UILabel alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(nameField.frame), APP_WIDTH - 36, 0.5)];
    underLine.backgroundColor = RGB(222, 222, 222, 1);
    
//    //昵称已被占用
//    UILabel *nameUsedLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    nameUsedLabel.textColor = RGB(227, 26, 26, 1);
//    nameUsedLabel.text = @"该昵称已被占用!";
//    nameUsedLabel.font = [UIFont systemFontOfSize:12];
//    [nameUsedLabel sizeToFit];
//    CGSize size = nameUsedLabel.frame.size;
//    nameUsedLabel.frame = CGRectMake(APP_WIDTH - 18 - size.width, underLine.frame.origin.y + 6, size.width, size.height);
    //完成
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, APP_HEIGHT - 45 - 64, APP_WIDTH, 45)];
    doneBtn.backgroundColor = [UIColor redColor];
    if (_isGuide) {
        [doneBtn setTitle:@"下一步" forState:UIControlStateNormal];
    } else {
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tipLabel];
    [self.view addSubview:nameField];
    [self.view addSubview:underLine];
//    [self.view addSubview:nameUsedLabel];
    [self.view addSubview:doneBtn];
}

#pragma mark - button method
- (void)hideKeyBoard:(UIGestureRecognizer*)ges {
    [nameField resignFirstResponder];
}

- (void)doneBtnClick:(UIButton*)sender {
    if (nameField.text.length == 0) {
        [Dialog toast:@"昵称不能为空"];
        return;
    }
    
    [HttpClient JSONDataWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"User/GetUserInfo"] parameters:@{@"token":[HttpClient getTokenStr]} success:^(id json){
        NSDictionary* temp = (NSDictionary*)json;
        if ([[temp objectForKey:@"code"]intValue]!=0) {
            [Dialog toast:[temp objectForKey:@"msg"]];
            return;
        }
        NSMutableDictionary *postDic = [NSMutableDictionary dictionaryWithDictionary:[temp objectForKey:@"result"]];
        [postDic setObject:nameField.text forKey:@"NickName"];
        [postDic setObject:[HttpClient getTokenStr] forKey:@"token"];
        if (_isGuide) {
            [postDic setObject:@([FRUtils getGender]) forKey:@"Sex"];
        }
        [HttpClient postJSONWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"User/SaveUserInfo"] parameters:postDic success:^(id response){
            NSDictionary* temp = (NSDictionary*)json;
            if ([[temp objectForKey:@"code"]intValue]!=0) {
                [Dialog toast:[temp objectForKey:@"msg"]];
                return;
            }
            if (self.block) {
                self.block(nameField.text);
            }
            [FRUtils setNickName:nameField.text];
            if (_isGuide) {
                ChangeAvatarViewController *vc = [[ChangeAvatarViewController alloc]init];
                vc.isGuide = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshNickName" object:nameField.text];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        }fail:^{
            [Dialog toast:@"网络失败，请稍后再试"];
        }];
        
    }fail:^{
        [Dialog toast:@"网络失败，请稍后再试"];
    }];
    
    
    
//    if (_isGuide) {
//
//        NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"User/SaveUserInfo"];
//        NSMutableDictionary *postDic = [[NSMutableDictionary alloc]init];
//        
//        [postDic setObject:[FRUtils getNickName]  forKey:@"NickName"];
//        [postDic setObject:@([FRUtils getGender]) forKey:@"Sex"];
//        [postDic setObject:[FRUtils getPhoneNum] forKey:@"Phone"];
//        [postDic setObject:@"" forKey:@"Sign"];
//        [postDic setObject:@"" forKey:@"Remark"];
//        [postDic setObject:@"" forKey:@"Interest"];
//        [postDic setObject:@"" forKey:@"AvatarUrl"];
//        [HttpClient postJSONWithUrl:url parameters:postDic success:^(id response){
//            NSDictionary* temp = (NSDictionary*)response;
//            if ([[temp objectForKey:@"code"]intValue]!=0) {
//                [Dialog toast:[temp objectForKey:@"msg"]];
//                return;
//            }
//            [FRUtils setNickName:nameField.text];
//            ChangeAvatarViewController *vc = [[ChangeAvatarViewController alloc]init];
//            vc.isGuide = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }fail:^{
//            [SVProgressHUD showErrorWithStatus:@"网络失败，请稍后再试"];
//        }];
//        
//    } else {
//        
//        [HttpClient JSONDataWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"User/GetUserInfo"] parameters:@{@"token":[HttpClient getTokenStr]} success:^(id json){
//            NSDictionary* temp = (NSDictionary*)json;
//            if ([[temp objectForKey:@"code"]intValue]!=0) {
//                [Dialog toast:[temp objectForKey:@"msg"]];
//                return;
//            }
//            NSMutableDictionary *postDic = [NSMutableDictionary dictionaryWithDictionary:[temp objectForKey:@"result"]];
//            [postDic setObject:nameField.text forKey:@"NickName"];
//            [postDic setObject:[HttpClient getTokenStr] forKey:@"token"];
//            [HttpClient postJSONWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"User/SaveUserInfo"] parameters:postDic success:^(id response){
//                NSDictionary* temp = (NSDictionary*)json;
//                if ([[temp objectForKey:@"code"]intValue]!=0) {
//                    [Dialog toast:[temp objectForKey:@"msg"]];
//                    return;
//                }
//                if (self.block) {
//                    self.block(nameField.text);
//                }
//                [FRUtils setNickName:nameField.text];
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshUserinfo" object:nil];
//                [self.navigationController popViewControllerAnimated:YES];
//                
//            }fail:^{
//                [Dialog toast:@"网络失败，请稍后再试"];
//            }];
//            
//        }fail:^{
//            [Dialog toast:@"网络失败，请稍后再试"];
//        }];
//    }
}


@end
