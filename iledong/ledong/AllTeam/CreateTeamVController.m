//
//  CreateTeamVController.m
//  ledong
//
//  Created by luojiao  on 16/3/30.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "CreateTeamVController.h"

#define kOrighHeight 64
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CreateTeamVController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate> {
    @private
    CGFloat _mainScrollViewContentHeight;
    CGFloat _mainScrollViewContentOffsetY;
    BOOL _keyboardShow;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *uploadHeaderImgBtn;
@property (weak, nonatomic) IBOutlet UIView *teamNameView;
@property (weak, nonatomic) IBOutlet UIView *teamIntroductionView;
@property (weak, nonatomic) IBOutlet UIView *teamOtherInfoView;
@property (weak, nonatomic) IBOutlet UIView *teamAuditView;
@property (weak, nonatomic) IBOutlet UIButton *StartBtn;
@property (weak, nonatomic) IBOutlet UITextField *teamNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *teamIntrodectionTextView;
@property (weak, nonatomic) IBOutlet UITextField *maxCountTextField;
@property (weak, nonatomic) IBOutlet UISwitch *switchCtl;
@property (strong, nonatomic) IBOutlet UITextField *addTagTextField;

@property (strong, nonatomic) NSMutableArray* tagArray;
@property (strong, nonatomic) UIScrollView* tagScrollView;
@property (strong, nonatomic) UIView* deleteTagView;
@property (strong, nonatomic) NSDictionary* currentDeleteTagDict;

@end

@implementation CreateTeamVController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];
    [self layoutSubView];
    [self addKeyBoardNotification];
    [self setupTapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self removeKeyBoardNotification];
}

#pragma mark - draw UI
- (void)setupNavigationBar {
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor redColor]];
    [customLab setText:@"创建团队"];
    customLab.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = customLab;
}

- (void)layoutSubView {
    self.uploadHeaderImgBtn.layer.borderWidth = 1.0;
    self.uploadHeaderImgBtn.layer.borderColor = UIColorFromRGB(0xDEDEDE).CGColor;
    
    self.tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.teamOtherInfoView.frame.size.height-50, APP_WIDTH, 50)];
    [self.teamOtherInfoView addSubview:self.tagScrollView];

    self.addTagTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 16, 0, 0)];
    self.addTagTextField.placeholder = @"添加标签";
    self.addTagTextField.font = [UIFont systemFontOfSize:14.0];
    self.addTagTextField.textColor = [UIColor redColor];
    self.addTagTextField.delegate = self;
    self.addTagTextField.returnKeyType = UIReturnKeyDone;
    [self.addTagTextField sizeToFit];
    [self.tagScrollView addSubview:self.addTagTextField];
    
    self.switchCtl.onTintColor = [UIColor redColor];
}

- (void)addKeyBoardNotification {
    _keyboardShow = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)setupTapGestureRecognizer {
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes addTarget:self action:@selector(endEditing)];
    [self.mainScrollView addGestureRecognizer:tapGes];
}

#pragma mark - btn Clicked
- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endEditing {
    [self.view endEditing:YES];
}

- (IBAction)uploadImageBtnClicked:(id)sender {
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

- (void)keyboardWillShow:(NSNotification *) notif {
    if (_keyboardShow)
        return;

    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    _mainScrollViewContentHeight = self.mainScrollView.contentSize.height;
    _mainScrollViewContentOffsetY = self.mainScrollView.contentOffset.y;
    
    CGFloat y = 0;
    if ([self.teamNameTextField isFirstResponder])
        y = self.teamNameView.frame.origin.y - kOrighHeight;
    else if ([self.teamIntrodectionTextView isFirstResponder])
        y = self.teamIntroductionView.frame.origin.y - kOrighHeight;
    else if ([self.maxCountTextField isFirstResponder])
        y = self.teamOtherInfoView.frame.origin.y - kOrighHeight;
    else if ([self.addTagTextField isFirstResponder]) {
        y = self.teamAuditView.frame.origin.y - kOrighHeight - 80;
        self.deleteTagView.hidden = YES;
        self.tagScrollView.scrollEnabled = YES;
    }
    CGFloat sizeHeigth = _mainScrollViewContentHeight + keyboardSize.height;
    [UIView animateWithDuration:0.5 animations:^{
        [self.mainScrollView setContentSize:CGSizeMake(APP_WIDTH, sizeHeigth)];
        [self.mainScrollView setContentOffset:CGPointMake(0, y) animated:YES];
    } completion:nil];
}

- (void)keyboardDidHide:(NSNotification *) notif {
    _keyboardShow = NO;
    [UIView animateWithDuration:0.5 animations:^{
        [_mainScrollView setContentSize:CGSizeMake(APP_WIDTH, _mainScrollViewContentHeight)];
        [_mainScrollView setContentOffset:CGPointMake(0, _mainScrollViewContentOffsetY) animated:YES];
    } completion:nil];
}

- (void)uploadHeaderImage:(NSDictionary*)dict {
    if ([HttpClient isLogin]) {
        NSString *urlStr = [API_BASE_URL stringByAppendingString:API_UPLOAD_HEADERIMAGE_URL];
        [HttpClient postJSONWithUrl:urlStr parameters:dict success:^(id responseObject) {
            NSDictionary* dict = (NSDictionary*)responseObject;
            NSNumber* codeNum = [dict objectForKey:@"code"];
            if (codeNum.intValue == 0) {
                [Dialog alert:@"上传团队头像成功！"];
            }
//            else {
//                [Dialog alert:@"上传团队头像失败！"];
//            }
        } fail:^{
            //[Dialog alert:@"上传团队头像失败！"];
        }];
    }
}

- (void)addTagView:(NSString*)str isReDraw:(BOOL)isReDraw {
    UILabel* tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.addTagTextField.frame.origin.x, 10, 0, 0)];
    tagLabel.text = str;
    if (!isReDraw) {
        if (!self.tagArray)
            self.tagArray = [NSMutableArray array];
        [self.tagArray addObject:tagLabel.text];
    }

    tagLabel.font = [UIFont systemFontOfSize:14.0];
    tagLabel.textColor = [UIColor whiteColor];
    tagLabel.backgroundColor = [UIColor redColor];
    [tagLabel sizeToFit];
    tagLabel.frame = CGRectMake(tagLabel.frame.origin.x, tagLabel.frame.origin.y, tagLabel.frame.size.width*1.5, tagLabel.frame.size.height+10);
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.layer.cornerRadius = tagLabel.frame.size.height/2;
    tagLabel.layer.masksToBounds = YES;
    [self.tagScrollView addSubview:tagLabel];
    
    tagLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    NSDictionary* dict = @{@"index":[NSNumber numberWithInteger:self.tagArray.count-1],
                           @"centerX":[NSNumber numberWithInt:tagLabel.center.x]};
    objc_setAssociatedObject(tapGes, @"tapGesData", dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [tapGes addTarget:self action:@selector(deleteTagClicked:)];
    [tagLabel addGestureRecognizer:tapGes];
    
    self.addTagTextField.frame = CGRectMake(tagLabel.frame.origin.x+tagLabel.frame.size.width + 15, self.addTagTextField.frame.origin.y, self.addTagTextField.frame.size.width, self.addTagTextField.frame.size.height);
    self.addTagTextField.text = @"";
    
    self.tagScrollView.contentSize = CGSizeMake(self.addTagTextField.frame.origin.x+self.addTagTextField.frame.size.width+10, self.tagScrollView.contentSize.height);
    //self.tagScrollView.contentOffset = CGPointMake(tagLabel.frame.origin.x-10, self.tagScrollView.contentOffset.y);
}

- (void)deleteTagClicked:(UITapGestureRecognizer*)tapGes {
    NSDictionary* dict = objc_getAssociatedObject(tapGes, @"tapGesData");
    NSNumber* centerX = [dict objectForKey:@"centerX"];
    NSNumber* indexNum = [dict objectForKey:@"index"];
    if (self.deleteTagView && !self.deleteTagView.hidden) {
        NSNumber* tempNum = [self.currentDeleteTagDict objectForKey:@"index"];
        if (tempNum.integerValue == indexNum.integerValue) {
            self.deleteTagView.hidden = YES;
            self.tagScrollView.scrollEnabled = YES;
            return;
        }
    }

    self.currentDeleteTagDict = dict;
    //弹出删除框
    if (!self.deleteTagView) {
        self.deleteTagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
        self.deleteTagView.backgroundColor = [UIColor whiteColor];
        [self.mainScrollView addSubview:self.deleteTagView];
        UILabel* label = [[UILabel alloc]initWithFrame:self.deleteTagView.bounds];
        label.text = @"删除";
        label.font = [UIFont systemFontOfSize:14.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x333333);
        [self.deleteTagView addSubview:label];

        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
        [tapGes addTarget:self action:@selector(deleteTag)];
        [self.deleteTagView addGestureRecognizer:tapGes];
        
        self.deleteTagView.layer.borderColor = UIColorFromRGB(0xDEDEDE).CGColor;
        self.deleteTagView.layer.borderWidth = 1;
    }
    self.deleteTagView.frame = CGRectMake(0, self.teamOtherInfoView.frame.origin.y+self.teamOtherInfoView.frame.size.height-90, 70, 40);
    self.deleteTagView.center = CGPointMake(centerX.intValue - self.tagScrollView.contentOffset.x, self.deleteTagView.center.y);
    if (self.deleteTagView.frame.origin.x <= 0) {
        self.deleteTagView.frame = CGRectMake(5, self.teamOtherInfoView.frame.origin.y+self.teamOtherInfoView.frame.size.height-90, 70, 40);
    }
    self.deleteTagView.hidden = NO;
    self.tagScrollView.scrollEnabled = NO;
}

- (void)deleteTag {
    self.deleteTagView.hidden = YES;
    self.tagScrollView.scrollEnabled = YES;
    NSNumber* indexNum = [self.currentDeleteTagDict objectForKey:@"index"];
    //删除该数据，并重绘标签栏
    [self.tagArray removeObjectAtIndex:indexNum.intValue];
    for (UIView* view in self.tagScrollView.subviews) {
        if (view == self.addTagTextField)
            continue;
        [view removeFromSuperview];
    }
    self.addTagTextField.frame = CGRectMake(15, 16, self.addTagTextField.frame.size.width, self.addTagTextField.frame.size.height);
    for (NSString* str in self.tagArray)
        [self addTagView:str isReDraw:YES];
}

#pragma mark - delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        CGRect rect = weakSelf.headerImageView.frame;
        UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
        [image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image = smallImage;
        weakSelf.headerImageView.image = image;
        
        NSString* strTemp = [weakSelf getStringWithDate:[NSDate date] format:@"yyyyMMddHHmmss"];
        NSString* fileName = [NSString stringWithFormat:@"%@.png", strTemp];
        NSData * imageData = UIImagePNGRepresentation(image);
        long long length = [imageData length];
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setValue:[HttpClient getTokenStr] forKey:@"token"];
        [dict setValue:[NSNumber numberWithLongLong:length] forKey:@"ContentLength"];
        [dict setValue:@"file" forKey:@"ContentType"];
        [dict setValue:fileName forKey:@"FileName"];
        [dict setValue:imageData forKey:@"InputStream"];
        [weakSelf uploadHeaderImage:dict];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString*)getStringWithDate:(NSDate*)_date format:(NSString*)_format{
    if (!_date || _format.length == 0)
        return @"";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:_format];
    NSString* dateStr = [dateFormatter stringFromDate:_date];
    return  dateStr;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.addTagTextField) {
        [self.addTagTextField resignFirstResponder];
        [self addTagView:self.addTagTextField.text isReDraw:NO];
        return YES;
    }
    return NO;
}


    /*
- (NSString *)postRequestWithURL: (NSString *)url
                      postParems: (NSMutableDictionary *)postParems
                     picFilePath: (UIImage *)image
                     picFileName: (NSString *)picFileName {
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    NSString *FORM_FLE_INPUT = @"file";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                    timeoutInterval:10];
    //得到图片的data
    NSData* data;
    if (UIImagePNGRepresentation(image))
        data = UIImagePNGRepresentation(image);
    else
        data = UIImageJPEGRepresentation(image, 1.0);

    NSMutableString *body=[[NSMutableString alloc]init];
    NSArray *keys = [postParems allKeys];
//    for(int i=0; i<[keys count]; i++) {
//        //得到当前key
//        NSString *key=[keys objectAtIndex:i];
//        //添加分界线，换行
//        [body appendFormat:@"%@\r\n",MPboundary];
//        //添加字段名称，换2行
//        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//        //添加字段的值
//        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
//        
//        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
//    }
    
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    NSMutableData *myRequestData = [NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:data];
    
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:myRequestData];
    [request setHTTPMethod:@"POST"];

    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        return result;
    }
    return nil;
}
*/
@end
