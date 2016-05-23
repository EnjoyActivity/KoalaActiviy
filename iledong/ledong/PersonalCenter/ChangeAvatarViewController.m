//
//  ChangeAvatarViewController.m
//  ledong
//
//  Created by dengjc on 16/5/19.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "ChangeAvatarViewController.h"


@interface ChangeAvatarViewController ()
{
    UIImageView *headerImageView;
    UIView *maskView;
    UIImage *headImage;
}

@end

@implementation ChangeAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"个人头像";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    NSString *avatarUrl = [FRUtils getAvatarUrl];
    if (!avatarUrl||avatarUrl.length == 0) {
        headImage = [UIImage imageNamed:@"img_avatar_44"];
    } else {
        headImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarUrl]]];
    }
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(APP_WIDTH/2 - 50, 156 - 32, 100, 100)];
    headerImageView.layer.cornerRadius = 50;
    headerImageView.clipsToBounds = YES;
    headerImageView.image = headImage;
//    headerImageView.backgroundColor = [UIColor purpleColor];
    
    UIButton *uploadBtn = [[UIButton alloc]initWithFrame:CGRectMake(APP_WIDTH/2 - 64, CGRectGetMaxY(headerImageView.frame) + 40, 128, 40)];
    [uploadBtn setTitle:@"上传头像" forState:UIControlStateNormal];
    uploadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [uploadBtn setTitleColor:RGB(51, 51, 51, 1) forState:UIControlStateNormal];
    [uploadBtn setBackgroundImage:[FRUtils resizeImageWithImageName:@"btn_white"] forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [uploadBtn setBackgroundImage:[FRUtils resizeImageWithImageName:@"btn_white_press"] forState:UIControlStateHighlighted];
    
    //跳过提醒
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    tipLabel.text = @"之后到我的主页设置";
    tipLabel.textColor = RGB(153, 153, 153, 1);
    tipLabel.font = [UIFont systemFontOfSize:15];
    [tipLabel sizeToFit];
    tipLabel.center = CGPointMake(APP_WIDTH/2, APP_HEIGHT - 64 - 45 - 18 - tipLabel.frame.size.height/2);
    
    
    UILabel *tmpLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    tmpLabel.text = @"跳过这一步";
    tmpLabel.font = [UIFont systemFontOfSize:15];
    [tmpLabel sizeToFit];
    CGSize size = tmpLabel.frame.size;
    UIButton *tipBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [tipBtn setTitle:@"跳过这一步" forState:UIControlStateNormal];
    [tipBtn setTitleColor:RGB(227, 26, 26, 1) forState:UIControlStateNormal];
    tipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    tipBtn.center = CGPointMake(APP_WIDTH/2, tipLabel.frame.origin.y - 9 - size.height/2);
    
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
    
    [self.view addSubview:headerImageView];
    [self.view addSubview:uploadBtn];
    
    [self.view addSubview:tipLabel];
    [self.view addSubview:tipBtn];
    
    [self.view addSubview:doneBtn];
}

#pragma mark - button method
- (void)uploadBtnClick:(UIButton*)sender {
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT)];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.5;
//
//    [[[UIApplication sharedApplication]keyWindow]addSubview:maskView];
    ChangeAvatarView* sheet = [[ChangeAvatarView alloc]initWithFrame:CGRectMake(0, APP_HEIGHT - 160, APP_WIDTH, 160)];    sheet.frame = CGRectMake(0, APP_HEIGHT, APP_WIDTH, 160);
    sheet.maskView = maskView;
    sheet.delegate = self;
    [[[UIApplication sharedApplication]keyWindow]addSubview:sheet];
    [UIView animateWithDuration:0.5 animations:^{
        sheet.frame = CGRectMake(0, APP_HEIGHT-160, APP_WIDTH, 160);
    } completion:nil];
    
    [[[UIApplication sharedApplication]keyWindow]addSubview:maskView];
//    [[[UIApplication sharedApplication]keyWindow]addSubview:sheet];
}

- (void)doneBtnClick:(UIButton*)sender {
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc]init];
    [postDic setObject:[HttpClient getTokenStr] forKey:@"token"];
    NSString *url;
    if (_isGuide) {
        [postDic setObject:[FRUtils getNickName]  forKey:@"NickName"];
        [postDic setObject:@([FRUtils getGender]) forKey:@"Sex"];
        [postDic setObject:[FRUtils getPhoneNum] forKey:@"Phone"];
        [postDic setObject:[FRUtils getSign] forKey:@"Sign"];
        [postDic setObject:[FRUtils getRemark] forKey:@"Remark"];
        [postDic setObject:[FRUtils getinterest] forKey:@"Interest"];
        [postDic setObject:[FRUtils getAvatarUrl] forKey:@"AvatarUrl"];
        
        url = [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"User/UploadAvatarUrl"];
    } else {
        url = [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"User/SaveUserInfo"];
    }
    
    [HttpClient postJSONWithUrl:url parameters:postDic withImages:@[headImage] success:^(id response){
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        id jsonObject = [jsonParser objectWithString:[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]];
        NSDictionary* temp = (NSDictionary*)jsonObject;
        if ([[temp objectForKey:@"code"]intValue]!=0) {
            [Dialog toast:[temp objectForKey:@"msg"]];
            return;
        }
        if (self.block) {
            self.block(headImage);
        }
        [FRUtils setAvatarUrl:[temp objectForKey:@"result"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshUserinfo" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }fail:^{
        [SVProgressHUD showErrorWithStatus:@"网络失败，请稍后再试"];
    }];
}


- (void)onTakePhotoBtnClicked {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //支持拍照
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        picker.view.backgroundColor = [UIColor whiteColor];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"不支持拍照，请设置权限"];
    }
}

- (void)onPictureBtnClicked {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        //支持图库、相片库
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        picker.view.backgroundColor = [UIColor whiteColor];
        UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.sourceType = sourcheType;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"不支持获取图库及相片库，请设置权限"];
    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        headerImageView.image = headImage;
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //拍照，则需要手动保存到本地
            UIImageWriteToSavedPhotosAlbum(headImage, self, nil, nil);
        }
        
        
    }];
}


@end
