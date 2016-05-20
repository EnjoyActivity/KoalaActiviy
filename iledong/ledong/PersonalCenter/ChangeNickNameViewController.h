//
//  ChangeNickNameViewController.h
//  ledong
//
//  Created by dengjc on 16/5/19.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ChangeNickNameBlock)(NSString *name);

@interface ChangeNickNameViewController : BaseViewController

@property (nonatomic,strong)ChangeNickNameBlock block;

@property (nonatomic,assign) BOOL isGuide;
@end
