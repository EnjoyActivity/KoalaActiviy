//
//  HttpClient.h
//  ILeDong
//
//  Created by xiechuan on 15/9/29.
//  Copyright (c) 2015年 xiechuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface HttpClient : NSObject
{
    MBProgressHUD *_HUD;
}
-(void)showMessageHUD:(NSString *)tipStr;
- (void)hiddenMessageHUD;
+(id)shareHttpClient;
//GET
+ (void)JSONDataWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id json))success fail:(void (^)())fail;
+ (void)JSONDataWithUrlSilent:(NSString *)url parameters:(id)parameters success:(void (^)(id json))success fail:(void (^)())fail;
//POST
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)())fail;

+ (void)postJSONWithUrl:(NSString *)urlStr header:(NSString*)header parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)())fail;
//Token获取
+(NSString *)getTokenStr;
//POST上传图片和内容
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters withImages:(NSArray *)images success:(void (^)(id responseObject))success fail:(void (^)())fail;
//下载
+ (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName tag:(NSInteger)aTag success:(void (^)(id responseObject))success fail:(void (^)())fail;
+ (void)loginOrRegistWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id json))success fail:(void (^)())fail;

+(BOOL)isLogin;

@end
