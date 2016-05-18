//
//  UserHeaderViewController.m
//  ledong
//
//  Created by luojiao  on 16/4/11.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "UserHeaderViewController.h"
#import "FRUtils.h"

@interface UserHeaderViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@end

@implementation UserHeaderViewController

- (void)viewDidLoad {
    self.titleName = @"用户信息完善";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- ButtonClick
- (IBAction)upHeaderButton:(id)sender
{
    UIActionSheet *photosSheet = [[UIActionSheet alloc]initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    photosSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [photosSheet showInView:self.view.window];

}


- (IBAction)jumpButton:(id)sender
{
    
}

- (IBAction)nextButtonClick:(id)sender
{
    
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    switch (buttonIndex) {
        case 0:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }else{
                [Dialog simpleToast:@"此设备不支持拍照功能!" withDuration:1.2];
                return;
            }
            break;
        case 1:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            return;
            break;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//    uploadImage = image;
//    //完成之后去请求接口
//    //    NSData *newFile = UIImageJPEGRepresentation(userPic, 0.5);
//    CTHttpClient *httpClient = [CTHttpClient shareHttpClient];
//    httpClient.delegate = self;
//    [httpClient updateIconWithImage:image withUserId:[CTUtils getUserDefaultValueWithKey:kTeacherIdKey]];
    self.headerImage.image = [FRUtils circleImage:image withParam:1.0];
;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
