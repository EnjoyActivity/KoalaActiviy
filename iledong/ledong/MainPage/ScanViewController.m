//
//  ScanViewController.m
//  ledong
//
//  Created by luojiao  on 16/3/28.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *goBackButton;

@end

@implementation ScanViewController

- (void)viewDidLoad
{
    self.titleName = @"扫描";
    [super viewDidLoad];
//    [self.goBackButton setBackgroundImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    scanView = [ZHScanView scanViewWithFrame:CGRectMake(0, 62, APP_WIDTH, APP_HEIGHT)];
//    scanf.promptMessage = @"您可以直接输入或者选择扫描二维码";
    [self.view addSubview:scanView];
    
    [scanView startScaning];
    
    [scanView outPutResult:^(NSString *result)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:result]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:result delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

#pragma mark - Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self gobackButtonClick:nil];
        }
            break;
            
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)gobackButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//- (IBAction)openPhoto:(id)sender {
//    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate = self;
//    imagePicker.allowsEditing = YES;
//    
//    [self presentViewController:imagePicker animated:YES completion:nil];
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString * url = [info objectForKey:UIImagePickerControllerReferenceURL];
    
}



@end
