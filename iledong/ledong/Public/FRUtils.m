//
//  FRUtils.m
//  FootRoad
//
//  Created by DongGuoJu on 15/3/8.
//  Copyright (c) 2015年 Hurrican. All rights reserved.
//

#import "FRUtils.h"
#import "LoginAndRegistViewController.h"

static FRUtils *instance = nil;

@implementation FRUtils
+ (FRUtils *)Instance
{
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [self new];
        }
    }
    return instance;
}

+(UIImage *)resizeImageWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    float top = image.size.height/2;
    float left = image.size.width/2;
    float right = image.size.width/2;
    float bottom = image.size.height/2;
    UIImage *strechImg = [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
    return strechImg;
}

+(UIImage *)resizeImageWithImage:(UIImage *)image
{
    float top = image.size.height/2;
    float left = image.size.width/2;
    float right = image.size.width/2;
    float bottom = image.size.height/2;
    UIImage *strechImg = [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
    return strechImg;
}

+ (void)presentToLoginViewControllerWithRootViewController:(UIViewController *)viewController
{
    LoginAndRegistViewController *loginView = [[LoginAndRegistViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginView];
    [viewController presentViewController:nav animated:YES completion:nil];
}
//根据图片名称和拉伸的宽高来拉伸图片
+ (UIImage *)stretchImage:(NSString *)imageName
         withLeftCapWidth:(NSInteger)leftCapWidth
             topCapHeight:(NSInteger)topCapHeight
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *strtchImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    return strtchImage;
}

//圆形imageview
+ (UIImage*)circleImage:(UIImage*) image withParam:(CGFloat) inset
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO ,[UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);

    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

//根据正则表达式来检测用户名和密码是否合法---字母数字下划线，^\w+$　　//匹配由数字、26个英文字母或者下划线组成的字符串
+ (BOOL)isValid:(NSString *)string
{
    //    NSString * regex = @"^[A-Za-z0-9_]{6,16}$";
    NSString * regex = @"\\S{6,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

//根据格式获取当前日期
+ (NSString *)getCurrentDateWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)intervalSinceNow:(NSString *)theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];     //yyyy-MM-dd HH:mm:ss
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1)
    {
        if (cha/60<1)
        {
            timeString = @"刚刚";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        }
    }
    else if (cha/3600>1&&cha/86400<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    else if (cha/86400>1&&cha/86400/15<1)     //需要是15天的
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    else
    {
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        //        NSArray *array = [theDate componentsSeparatedByString:@" "];
        //        //        return [array objectAtIndex:0];
        //        timeString = [array objectAtIndex:0]; //直取出年月日
        //        timeString = [date stringFromDate:d];   //不用秒了
        timeString = [theDate substringToIndex:theDate.length - 3];
    }
    return timeString;
}

//手机号格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|7[0-45-9]|8[0-25-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//根据key获得userDefault里面 的value
+ (NSString *)getUserDefaultValueWithKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+ (NSString *)getFilePathWithDirectoryName:(NSString *)dName fileName:(NSString *)fName
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // 文件夹的路径
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",path,dName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath])
    {
        // 如果不存在文件夹  就创建一个文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 文件路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",directoryPath,fName];
    
    // 保证文件也是存在的
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        // 创建一个空文件
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    return filePath;
}
//获取doc目录下面的路径.需要带后缀
+ (NSString *)getDocPathWithPicName:(NSString *)picName
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [docPath stringByAppendingPathComponent:picName];
}

//+ (void)hideTabbar
//{
//    kAppDelegate.mainTabbarController.tabBarTransparent = YES;
//    [kAppDelegate.mainTabbarController hidesTabBar:YES animated:NO];
//}

//把获取NSDate中的weekday int 转换为字符串
+(NSString *)weekDayNumToStr:(int) weekDay{
    weekDay = weekDay%7;
    switch (weekDay) {
        case 1:
            return @"周日";
        case 2:
            return @"周一";
        case 3:
            return @"周二";
        case 4:
            return @"周三";
        case 5:
            return @"周四";
        case 6:
            return @"周五";
        case 0:
            return @"周六";
        default:
            return nil;
    }
}


+(BOOL)configButtonStateWith:(UIButton *)button withIndex:(int)index
{
    [button setBackgroundColor:[UIColor clearColor]];
    NSString *normal = @"";
    NSString *press = @"";
    NSString *disable = @"";
    switch (index) {
        case 1://常用按钮
        {
            normal = @"btn_commonly_normal";
            press = @"btn_commonly_press";
            disable = @"btn_commonly_-disable";
        }
            break;
        case 2://辅助按钮
        {
            
            normal = @"btn_secondary_normal";
            press = @"btn_commonly_press";
            disable = @"btn_commonly_-disable";
        }
            break;
        case 3://特殊按钮
        {
            normal = @"btn_special_normal";
            press = @"btn_special_press";
            disable = @"btn_commonly_-disable";
        }
            break;
        case 4://辅助按钮
        {
            normal = @"btn_assist_normal";
            press = @"btn_assist_press";
            disable = @"btn_commonly_-disable";
        }
            break;
            
        default:
            break;
    }
    UIImage *imageNormal = [FRUtils resizeImageWithImageName:normal];
    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    UIImage *imagePress = [FRUtils resizeImageWithImageName:press];
    [button setBackgroundImage:imagePress forState:UIControlStateHighlighted];
    UIImage *imageDisable = [FRUtils resizeImageWithImageName:disable];
    [button setBackgroundImage:imageDisable forState:UIControlStateDisabled];
    
    return YES;
}

//隐藏tabBar

//+ (void)hideTabBarView
//{
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    TabBarViewController *tabBar = (TabBarViewController *)app.window.rootViewController;
//    [tabBar hideTabBar];
//    
//}
//
//+ (void)showTabBarView
//{
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    TabBarViewController *tabBar = (TabBarViewController *)app.window.rootViewController;
//    [tabBar showTabBar];
//}

//第一个参数为需要适应的内容
//第二个为字号大小
//第三个为适应的宽度

+ (CGRect)getContentSizeWith:(NSString *)content withFont:(CGFloat)fontNum withWidth:(CGFloat)width
{
    UIFont *font = [UIFont systemFontOfSize:fontNum];
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil];
    return rect;
}

+ (void)simpleToast:(NSString *)message withDuration:(NSTimeInterval)duration
{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [SVProgressHUD showInfoWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
//    [NSObject cancelPreviousPerformRequestsWithTarget:[FRUtils Instance] selector:@selector(hideSimpleToast) object:nil];
    [[FRUtils Instance] performSelector:@selector(hideSimpleToast) withObject:nil afterDelay:duration];
}

+ (UIColor *) colorWithHexString: (NSString *)colorString
{
    NSString *cString = [[colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
- (void)hideSimpleToast
{
    [SVProgressHUD dismiss];
}

//+ (LoginViewController *)presentViewToLoginViewContrller:(BaseViewController *)controller
//{
//    LoginViewController *loginView = [[LoginViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginView];
//    [controller presentViewController:nav animated:YES completion:nil];
//    
//    return loginView;
//}

//+ (BOOL)isLogin
//{
//    NSData *data = [kUserDefaults objectForKey: kCookiesDataKey];
//    if (data)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
//+ (NSString *)getUserId
//{
//    NSData *data = [kUserDefaults objectForKey:kCookiesDataKey];
//    //反序列化
//    NSDictionary *dataDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    NSString *userId = [dataDic objectForKey:kUserIdKey];
//    return userId;
//}

+ (void)queryUserInfoFromWeb:(void(^)())success  failBlock:(void(^)())fail {
    [HttpClient JSONDataWithUrlSilent:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"User/GetUserInfo"] parameters:@{@"token":[HttpClient getTokenStr]} success:^(id json){
        if ([[json objectForKey:@"code"]intValue]!=0) {
            [Dialog toast:[json objectForKey:@"msg"]];
            return;
        }
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
             [FRUtils saveUserInfo:json];
             if (success) {
                 success();
             }
         });
        
    }fail:^{
        if (fail) {
            fail();
        }
    }];
}

+ (void)saveUserInfo:(id)json {
    NSDictionary* temp = (NSDictionary*)json;
    
    NSDictionary *result = [temp objectForKey:@"result"];
    
    NSString *nickName = [result objectForKey:@"NickName"];
    if (!nickName||[nickName isKindOfClass:[NSNull class]]||nickName.length == 0) {
        [FRUtils setNickName:@""];
    } else {
        [FRUtils setNickName:nickName];
    }
    
    NSString *phone = [result objectForKey:@"Phone"];
    if (!phone||[phone isKindOfClass:[NSNull class]]||phone.length == 0) {
        [FRUtils setPhoneNum:@""];
    } else {
        [FRUtils setPhoneNum:phone];
    }
    
    NSString *interest = [result objectForKey:@"Interest"];
    if (!interest||[interest isKindOfClass:[NSNull class]]||interest.length == 0) {
        [FRUtils setInterest:@""];
    } else {
        [FRUtils setInterest:interest];
    }
    
    NSString *remark = [result objectForKey:@"Remark"];
    if (!remark||[remark isKindOfClass:[NSNull class]]||remark.length == 0) {
        [FRUtils setRemark:@""];
    } else {
        [FRUtils setRemark:remark];
    }
    
    NSString *sign = [result objectForKey:@"Sign"];
    if (!sign||[sign isKindOfClass:[NSNull class]]||sign.length == 0) {
        [FRUtils setSign:@""];
    } else {
        [FRUtils setSign:sign];
    }
    
    NSInteger score = [[result objectForKey:@"Score"]integerValue];
    if (!score) {
        [FRUtils setScore:0];
    } else {
        [FRUtils setScore:score];
    }
    
    NSString *avatar = [result objectForKey:@"AvatarUrl"];
    if (!avatar||[avatar isKindOfClass:[NSNull class]]||avatar.length == 0) {
        [FRUtils setAvatarUrl:@""];
    } else {
        [FRUtils setAvatarUrl:avatar];
        //缓存头像
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *headerImageDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/headerImg/"];
        if (![fileManager fileExistsAtPath:headerImageDirectory]) {
            [fileManager createDirectoryAtPath:headerImageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSURL *aUrl = [NSURL URLWithString:[FRUtils getAvatarUrl]];
        NSString *fileName = [headerImageDirectory stringByAppendingString:[aUrl lastPathComponent]];
        if (![fileManager fileExistsAtPath:fileName]) {
            NSData *imgData = [NSData dataWithContentsOfURL:aUrl];
            [imgData writeToFile:fileName atomically:NO];
        }
       
    }
    int sex = [[result objectForKey:@"Sex"]intValue];
    [FRUtils setGender:sex];
}


+ (BOOL)isFirstLogin {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [defs boolForKey:[FRUtils getPhoneNum]];
}
+ (void)setIsFirstLogin {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setBool:YES forKey:@"gender"];
}

//get
+ (NSString*)getPhoneNum {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [defs objectForKey:@"phoneNum"];
}
+ (NSString*)getNickName {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [defs objectForKey:@"nickName"];
}

+ (NSInteger)getGender {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [defs integerForKey:@"gender"];
}

+ (NSString*)getAvatarUrl {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [defs objectForKey:@"avatarUrl"];
}
+ (NSInteger)getScore {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [defs integerForKey:@"score"];
}

+ (NSString*)getRemark {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [defs objectForKey:@"remark"];
}
+ (NSString*)getSign {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [defs objectForKey:@"sign"];
}
+ (NSString*)getinterest {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [defs objectForKey:@"interest"];
}
+ (NSString*)getBirthday {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    return [defs objectForKey:@"birthday"];
}
+ (UIImage*)getHeaderImage {
    NSString *headerImageDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/headerImg/"];
    NSURL *aUrl = [NSURL URLWithString:[FRUtils getAvatarUrl]];
    if ([FRUtils getAvatarUrl]&&[FRUtils getAvatarUrl].length!=0) {
        NSString *fileName = [headerImageDirectory stringByAppendingString:[aUrl lastPathComponent]];
        return [UIImage imageWithContentsOfFile:fileName];
    } else {
        return nil;
    }
}
//set
+ (void)setNickName:(NSString*)name {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:name forKey:@"nickName"];
}
+ (void)setPhoneNum:(NSString*)phone {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:phone forKey:@"phoneNum"];
}
+ (void)setGender:(NSInteger)gender {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setInteger:gender forKey:@"gender"];
}
+ (void)setScore:(NSInteger)score {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setInteger:score forKey:@"score"];
}
+ (void)setSign:(NSString*)sign {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:sign forKey:@"sign"];
}
+ (void)setInterest:(NSString*)interest {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:interest forKey:@"interest"];
}
+ (void)setRemark:(NSString*)remark {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:remark forKey:@"remark"];
}
+ (void)setAvatarUrl:(NSString*)url {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    if ([url hasPrefix:@".."]) {
        NSString *fullUrl = [NSString stringWithFormat:@"%@%@",API_BASE_URL,[url substringFromIndex:3]];
        [defs setObject:fullUrl forKey:@"avatarUrl"];
    } else {
        [defs setObject:url forKey:@"avatarUrl"];
    }
}
+ (void)setBirthday:(NSString *)birth {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:birth forKey:@"birthday"];
}

+ (void)setToken:(NSString *)token
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:token forKey:@"kToken"];
    [defs synchronize];
}
+ (void)setHeaderImage:(UIImage*)headerImage {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *headerImageDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/headerImg"];
    if (![fileManager fileExistsAtPath:headerImageDirectory]) {
        [fileManager createDirectoryAtPath:headerImageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSURL *aUrl = [NSURL URLWithString:[FRUtils getAvatarUrl]];
    NSString *fileName = [headerImageDirectory stringByAppendingString:[aUrl lastPathComponent]];
    NSData *imgData = UIImagePNGRepresentation(headerImage);
    [imgData writeToFile:fileName atomically:NO];
}
@end
