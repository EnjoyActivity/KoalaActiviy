//
//  ChangeAvatarViewController.h
//  ledong
//
//  Created by dengjc on 16/5/19.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"
#import "ChangeAvatarView.h"

typedef void (^ChangeAvatarBlock)(UIImage *image);

@interface ChangeAvatarViewController : BaseViewController<ChangeAvatarViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) ChangeAvatarBlock block;

@property (nonatomic,assign) BOOL isGuide;

@property (nonatomic,strong) UIImage *headImage;

@end
