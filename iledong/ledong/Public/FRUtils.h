//
//  FRUtils.h
//  FootRoad
//
//  Created by DongGuoJu on 15/3/8.
//  Copyright (c) 2015年 Hurrican. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "BaseViewController.h"
//#import "LoginViewController.h"
typedef enum : NSUInteger
{
    BlueModel = 1,
    OrangeModel,
    RedModel,
    GreenModel,
} ControllerType;

@interface FRUtils : NSObject
{

}
+ (FRUtils *)Instance;
+(UIImage *)resizeImageWithImage:(UIImage *)image;
+(UIImage *)resizeImageWithImageName:(NSString *)imageName;

//根据图片名称和拉伸的宽高来拉伸图片
+ (UIImage *)stretchImage:(NSString *)imageName
         withLeftCapWidth:(NSInteger)leftCapWidth
             topCapHeight:(NSInteger)topCapHeight;

+ (UIImage *) circleImage:(UIImage*) image withParam:(CGFloat) inset ;

//根据正则表达式来检测用户名和密码是否合法
+ (BOOL)isValid:(NSString *)string;

//根据格式获取当前日期
+ (NSString *)getCurrentDateWithFormat:(NSString *)format;
//日期转换为类似几天前的这种
+ (NSString *)intervalSinceNow:(NSString *)theDate;

//根据key获得userDefault里面 的value
+ (NSString *)getUserDefaultValueWithKey:(NSString *)key;
//获取doc目录下面的路径.需要带后缀
+ (NSString *)getDocPathWithPicName:(NSString *)picName;
//+ (void)hideTabbar;

//把获取NSDate中的weekday int 转换为字符串
+(NSString *)weekDayNumToStr:(int) weekDay;
+(BOOL)configButtonStateWith:(UIButton *)button withIndex:(int)index;

//tabBar的隐藏和显示
+ (void)hideTabBarView;
+ (void)showTabBarView;
//根据文字宽高设置控件大小
+ (CGRect)getContentSizeWith:(NSString *)content withFont:(CGFloat)fontNum withWidth:(CGFloat)width;
+ (BOOL)isLogin;
+ (void)simpleToast:(NSString *)message withDuration:(NSTimeInterval)duration;

//手机号格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//+ (LoginViewController *)presentViewToLoginViewContrller:(BaseViewController *)controller;
+ (UIColor *) colorWithHexString: (NSString *)colorString;
+ (NSString *)getUserId;

+ (void)presentToLoginViewControllerWithRootViewController:(UIViewController *)viewController;



@end
