//
//  ModificationPhoneVC.h
//  ledong
//
//  Created by luojiao  on 16/4/25.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"

@interface ModificationPhoneVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *gobackButton;

@property (weak, nonatomic) IBOutlet UIImageView *ImageSend;
@end
