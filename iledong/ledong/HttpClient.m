//
//  HttpClient.m
//  ILeDong
//
//  Created by xiechuan on 15/9/29.
//  Copyright (c) 2015年 xiechuan. All rights reserved.
//

#import "HttpClient.h"

@implementation HttpClient
+(id)shareHttpClient
{
    static HttpClient *httpClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpClient = [[self alloc] init];
    });
    return httpClient;
}

-(void)showMessageHUD:(NSString *)tipStr
{
    if (!_HUD)
    {
        _HUD = [[MBProgressHUD alloc] initWithWindow:kAppDelegate.window];
        _HUD.dimBackground = YES;
        _HUD.activityIndicatorColor = [UIColor blackColor];
        _HUD.color = [UIColor clearColor];
        _HUD.labelFont = [UIFont systemFontOfSize:12];
    }
    if (tipStr == nil)
    {
        _HUD.labelText = @"正在加载，请稍等...";
    }
    else
    {
        _HUD.labelText = tipStr;
    }
    
    [kAppDelegate.window addSubview:_HUD];
    [kAppDelegate.window bringSubviewToFront:_HUD];
    [_HUD show:YES];
}
- (void)hiddenMessageHUD
{
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD hide:YES afterDelay:0];
}

+ (AFHTTPRequestOperationManager *)getNoEnterLoginRequestManagerWithIsCookie:(BOOL)isCookie
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes  =[NSSet setWithObjects:@"application/json",@"text/html",nil];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    if (isCookie)
    {
        NSDictionary *arcCookies = [NSKeyedUnarchiver unarchiveObjectWithData: [kUserDefaults objectForKey: kCookiesDataKey]];
        [manager.requestSerializer setValue:[arcCookies objectForKey:kSessionId] forHTTPHeaderField:@"sessionid"];
        [manager.requestSerializer setValue:[arcCookies objectForKey:kUserIdKey] forHTTPHeaderField:@"userid"];
    }
    return manager;
}

#pragma mark - 登录、注册
+ (void)loginOrRegistWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id json))success fail:(void (^)())fail
{
    [[HttpClient shareHttpClient] showMessageHUD:@""];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes  =[NSSet setWithObjects:@"application/json",@"text/html",nil];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 0)
        {
            NSUserDefaults *kTokenValue = [NSUserDefaults standardUserDefaults];
            [kTokenValue setObject: [responseObject objectForKey:kResult] forKey: @"kToken"];
            [kTokenValue synchronize];
            success(responseObject);
        }
        else
        {
            [FRUtils simpleToast:[responseObject objectForKey:@"msg"] withDuration:kDuration];
        }
        
        [[HttpClient shareHttpClient] hiddenMessageHUD];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (fail) {
            fail();
        }
        [[HttpClient shareHttpClient] hiddenMessageHUD];
    }];
}

#pragma mark - Token获取
+(NSString *)getTokenStr
{
    NSUserDefaults *kTokenValue = [NSUserDefaults standardUserDefaults];
    NSString *token = [kTokenValue objectForKey:@"kToken"];
    return token;
}

+ (BOOL)isLogin
{
    NSString *data = [HttpClient getTokenStr];
    if (data&&data.length!=0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - JSON方式获取数据 GET方式

+ (void)JSONDataWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id json))success fail:(void (^)())fail
{
    [[HttpClient shareHttpClient] showMessageHUD:@""];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes  =[NSSet setWithObjects:@"application/json",@"text/html",nil];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 0)
        {
            success(responseObject);
        }
        else
        {
            if ([[responseObject objectForKey:@"code"] intValue] == 20010) {
                [FRUtils setToken:@""];
            }
            [FRUtils simpleToast:[responseObject objectForKey:@"msg"] withDuration:kDuration];
        }
        [[HttpClient shareHttpClient] hiddenMessageHUD];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"%@", error);
        if (fail)
        {
            fail();
        }
        [[HttpClient shareHttpClient] hiddenMessageHUD];
    }];
}

#pragma mark - JSON方式post提交数据 POST
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    [[HttpClient shareHttpClient] showMessageHUD:@""];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes  =[NSSet setWithObjects:@"application/json",@"text/html",nil];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 0)
        {
            success(responseObject);
        }
        else
        {
            if ([[responseObject objectForKey:@"code"] intValue] == 20010) {
                [FRUtils setToken:@""];
            }
            [FRUtils simpleToast:[responseObject objectForKey:@"msg"] withDuration:kDuration];
        }
        [[HttpClient shareHttpClient] hiddenMessageHUD];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"%@", error);
        if (fail)
        {
            fail();
        }
        [[HttpClient shareHttpClient] hiddenMessageHUD];
    }];
    
}
#pragma mark - 上传图片和内容
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters withImages:(NSArray *)images success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    [[HttpClient shareHttpClient] showMessageHUD:@""];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        if (images.count>0)
                                        {
                                            for (int i=0; i<images.count; i++)
                                            {
                                                [formData appendPartWithFileData:UIImageJPEGRepresentation(images[i], 0.1) name:[NSString stringWithFormat:@"file_%d",i+1] fileName:[NSString stringWithFormat:@"file_%d.jpg",i+1] mimeType:@"image/jpeg"];
                                            }
                                        }
                                    } error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         NSLog(@"%f,%f,%f",(float)bytesWritten,(float)totalBytesWritten,(float)totalBytesExpectedToWrite);
     }];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"=====请求成功");
//         if ([[responseObject objectForKey:@"code"] integerValue] == 0)
//         {
             success(responseObject);
//         }
         [[HttpClient shareHttpClient] hiddenMessageHUD];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error);
         if (fail)
         {
             fail();
         }
         [[HttpClient shareHttpClient] hiddenMessageHUD];
     }];
}
#pragma mark - 下载文件
+ (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName tag:(NSInteger)aTag success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", aSavePath, aFileName];
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName])
    {
        NSData *audioData = [NSData dataWithContentsOfFile:fileName];
        success(audioData);
    }
    else
    {
        //创建附件存储目录
        if (![fileManager fileExistsAtPath:aSavePath])
        {
            [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        //下载附件
        NSURL *url = [[NSURL alloc] initWithString:aUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        operation.inputStream   = [NSInputStream inputStreamWithURL:url];
        operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
        
        //下载进度控制
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
         {
             
             NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
             
         }];
        //已完成下载
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSData *audioData = [NSData dataWithContentsOfFile:fileName];
            //设置下载数据到res字典对象中并用代理返回下载数据NSData
            if ([[responseObject objectForKey:@"code"] intValue] == 0)
            {
                success(audioData);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
             //下载失败
            if (fail)
            {
                fail();
            }
        }];
        
        [operation start];
    }
}

@end
