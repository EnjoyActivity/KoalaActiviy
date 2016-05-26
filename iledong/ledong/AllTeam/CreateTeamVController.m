//
//  CreateTeamVController.m
//  ledong
//
//  Created by luojiao  on 16/3/30.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "CreateTeamVController.h"
#import "LDDeleteTagView.h"
#import "ActivityAddressViewController.h"

#define kOrighHeight 64

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
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIButton *StartBtn;
@property (weak, nonatomic) IBOutlet UITextField *teamNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *teamIntrodectionTextView;
@property (weak, nonatomic) IBOutlet UITextField *maxCountTextField;
@property (weak, nonatomic) IBOutlet UISwitch *switchCtl;
@property (strong, nonatomic) IBOutlet UITextField *addTagTextField;

@property (strong, nonatomic) NSMutableArray* tagArray;
@property (strong, nonatomic) UIScrollView* tagScrollView;
@property (strong, nonatomic) LDDeleteTagView* deleteTagView;
@property (strong, nonatomic) NSDictionary* currentDeleteTagDict;
@property (strong, nonatomic) NSMutableDictionary* parameterDict;

@end

@implementation CreateTeamVController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tagArray = [NSMutableArray array];
    [self setupNavigationBar];
    [self layoutSubView];
    [self addKeyBoardNotification];
    [self setupTapGestureRecognizer];
    [self setupAddressTapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self removeKeyBoardNotification];
}

- (NSMutableDictionary*)parameterDict {
    if (!_parameterDict) {
        _parameterDict = [NSMutableDictionary dictionary];
    }
    return _parameterDict;
}

#pragma mark - draw UI
- (void)setupNavigationBar {
    self.navigationController.navigationBarHidden = NO;
    //self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    backItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backItem;

    self.navigationItem.title = @"创建团队";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:227/255.0 green:26/255.0 blue:26/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
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
    
    self.switchCtl.onTintColor = UIColorFromRGB(0xD20203);
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

- (void)setupAddressTapGesture {
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes addTarget:self action:@selector(addressViewClicked)];
    [self.addressView addGestureRecognizer:tapGes];
}

#pragma mark - btn Clicked
- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endEditing {
    if ([self.addTagTextField isFirstResponder]) {
        NSInteger index = 0;
        if (self.tagArray.count > 0)
            index = self.tagArray.count;
        [self addTagView:self.addTagTextField.text isReDraw:NO index:index];
    }
    [self.view endEditing:YES];
}

- (void)addressViewClicked {
    ActivityAddressViewController* Vc = [[ActivityAddressViewController alloc]init];
    [self.navigationController pushViewController:Vc animated:YES];
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
    
    _keyboardShow = YES;
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
    [self changeStartBtnBgColor];
    [UIView animateWithDuration:0.5 animations:^{
        [_mainScrollView setContentSize:CGSizeMake(APP_WIDTH, _mainScrollViewContentHeight)];
        [_mainScrollView setContentOffset:CGPointMake(0, _mainScrollViewContentOffsetY) animated:YES];
    } completion:nil];
}

- (void)addTagView:(NSString*)str isReDraw:(BOOL)isReDraw index:(NSInteger)index {
    if (str.length == 0)
        return;

    UILabel* tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.addTagTextField.frame.origin.x, 10, 0, 0)];
    tagLabel.text = str;
    if (!isReDraw) {
        [self.tagArray addObject:tagLabel.text];
        [self changeStartBtnBgColor];
    }

    tagLabel.font = [UIFont systemFontOfSize:14.0];
    tagLabel.textColor = [UIColor whiteColor];
    tagLabel.backgroundColor = UIColorFromRGB(0xD20203);
    [tagLabel sizeToFit];
    tagLabel.frame = CGRectMake(tagLabel.frame.origin.x, tagLabel.frame.origin.y, tagLabel.frame.size.width*1.5, tagLabel.frame.size.height+10);
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.layer.cornerRadius = tagLabel.frame.size.height/2;
    tagLabel.layer.masksToBounds = YES;
    [self.tagScrollView addSubview:tagLabel];
    
    tagLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    NSDictionary* dict = @{@"index":[NSNumber numberWithInteger:index],
                           @"centerX":[NSNumber numberWithInt:tagLabel.center.x]};
    objc_setAssociatedObject(tapGes, @"tapGesData", dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [tapGes addTarget:self action:@selector(deleteTagClicked:)];
    [tagLabel addGestureRecognizer:tapGes];
    
    self.addTagTextField.frame = CGRectMake(tagLabel.frame.origin.x+tagLabel.frame.size.width + 15, self.addTagTextField.frame.origin.y, self.addTagTextField.frame.size.width, self.addTagTextField.frame.size.height);
    self.addTagTextField.text = @"";
    
    self.tagScrollView.contentSize = CGSizeMake(self.addTagTextField.frame.origin.x+self.addTagTextField.frame.size.width+10, self.tagScrollView.contentSize.height);
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
        self.deleteTagView = [[LDDeleteTagView alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
        self.deleteTagView.backgroundColor = [UIColor whiteColor];
        [self.mainScrollView addSubview:self.deleteTagView];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
        [tapGes addTarget:self action:@selector(deleteTag)];
        [self.deleteTagView addGestureRecognizer:tapGes];
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
    int i = 0;
    for (NSString* str in self.tagArray) {
        [self addTagView:str isReDraw:YES index:i++];
    }
}

- (void)changeStartBtnBgColor {
    if (self.teamNameTextField.text.length > 0 && self.teamIntrodectionTextView.text.length > 0 &&
        self.maxCountTextField.text.length > 0 && self.tagArray.count > 0) {
        UIImage* btnBgImg = [self imageWithColor:UIColorFromRGB(0xff615d) size:self.StartBtn.frame.size];
        [self.StartBtn setBackgroundImage:btnBgImg forState:UIControlStateNormal];
    }
    else {
        self.StartBtn.backgroundColor = UIColorFromRGB(0xDEDEDE);
    }
}

- (UIImage*)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
        UIImage* newImage = smallImage;
        weakSelf.headerImageView.image = newImage;
        
        NSString* strTemp = [weakSelf getStringWithDate:[NSDate date] format:@"yyyyMMddHHmmss"];
        NSString* fileName = [NSString stringWithFormat:@"%@.png", strTemp];
        NSData * imageData = UIImagePNGRepresentation(image);
        long long length = [imageData length];
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setValue:[HttpClient getTokenStr] forKey:@"token"];
        [dict setValue:[NSNumber numberWithLongLong:length] forKey:@"ContentLength"];
        [dict setValue:@"file" forKey:@"ContentType"];
        [dict setValue:fileName forKey:@"FileName"];
        //[dict setValue:imageData forKey:@"InputStream"];
        //[weakSelf uploadHeaderImage:dict];
        
        NSString *urlStr = [API_BASE_URL stringByAppendingString:API_UPLOAD_HEADERIMAGE_URL];
        [HttpClient postJSONWithUrl:urlStr parameters:dict withImages:@[image] success:^(id responseObject) {
            [Dialog simpleToast:@"上传团队头像成功！" withDuration:1.5];
        } fail:^{
            [Dialog simpleToast:@"上传团队头像失败！" withDuration:1.5];
        }];
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
        NSInteger index = 0;
        if (self.tagArray.count > 0)
            index = self.tagArray.count;
        [self addTagView:self.addTagTextField.text isReDraw:NO index:index];
        return YES;
    }
    return NO;
}

- (IBAction)startBtnClick:(id)sender {
    //    tag	true	string	团队标签
    //    activityclassId	true	int	运动类别 （从活动类别接口获取）
    //    provinceCode	true	string	省
    //    cityCode	true	string	市
    //    areaCode	true	string	区
    
    int maxPersonNum = [self.maxCountTextField.text intValue];
    BOOL isNeedaudit = self.switchCtl.on;
    NSMutableString* tag = [NSMutableString string];
    for (int i=0; i<self.tagArray.count; i++) {
        NSString* str = self.tagArray[i];
        if (i == self.tagArray.count - 1) {
            tag = (NSMutableString*)[tag stringByAppendingString:str];
        }
        else {
            NSString* temp = [NSString stringWithFormat:@"%@、", str];
            tag = (NSMutableString*)[tag stringByAppendingString:temp];
        }
    }
    NSDictionary* dict = @{
                           @"token":[HttpClient getTokenStr],
                           @"name":self.teamNameTextField.text,
                           @"intro":self.teamIntrodectionTextView.text,
                           @"maxPersonNum":[NSNumber numberWithInt:maxPersonNum],
                           @"needaudit":[NSNumber numberWithBool:isNeedaudit],
                           @"tag":tag,
                           @"activityclassId":@"",
                           @"provinceCode":@"",
                           @"cityCode":@"",
                           @"areaCode":@"",
                          };
    
    NSString *urlStr = [API_BASE_URL stringByAppendingString:API_CREATETEAM_URL];
    [HttpClient postJSONWithUrl:urlStr parameters:dict success:^(id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSNumber* codeNum = [dict objectForKey:@"code"];
        if (codeNum.intValue == 0) {
            [Dialog simpleToast:@"创建团队成功！" withDuration:1.5];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            NSString* msg = [dict objectForKey:@"msg"];
            [Dialog simpleToast:msg withDuration:1.5];
        }
    } fail:^{
        [Dialog simpleToast:@"创建团队失败！" withDuration:1.5];
    }];
}

@end
