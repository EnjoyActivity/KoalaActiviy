//
//  ChangeGenderViewController.h
//  ledong
//
//  Created by dengjc on 16/5/19.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ChangeGenderBlock)(BOOL isFemale);

@interface ChangeGenderViewController : BaseViewController

@property (nonatomic,strong)ChangeGenderBlock block;

@property (nonatomic,assign)BOOL isFemale;

@property (nonatomic,assign) BOOL isGuide;

@end
