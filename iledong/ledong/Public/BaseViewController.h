//
//  BaseViewController.h
//  Conditioner
//
//  Created by DongGuoJu on 15/4/20.
//  Copyright (c) 2015年 com.hurrican.package. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(nonatomic,strong)NSString *titleImageName;
@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,strong)NSString *titleColor;
@property (nonatomic) BOOL isSetting;
@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic,strong)UIImageView *imageView;

-(void)backClick:(id)sender;

@end
