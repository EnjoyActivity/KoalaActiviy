//
//  LDMainPageNetWork.m
//  ledong
//
//  Created by 郑红 on 6/1/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import "LDMainPageNetWork.h"

@implementation LDMainPageNetWork

#pragma mark - instance
+ (instancetype)defaultInstance {
    static LDMainPageNetWork * netWork;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWork = [[LDMainPageNetWork alloc] init];
    });
    return netWork;
}

#pragma mark - Post

- (void)postPath:(NSString *)path
       parameter:(NSDictionary *)parameter
         success:(requestSuccess)successed
            fail:(requestError)errored {
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [requestManager POST:path parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code !=0 ) {
            NSError * err = [[NSError alloc] initWithDomain:@"请求失败" code:1000 userInfo:nil];
            errored(err);
            return ;
        }
        id result = [dic objectForKey:@"result"];
        successed(result);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errored(error);
    }];
    
}

#pragma mark - Get

- (void)getPath:(NSString *)path
      parameter:(NSDictionary *)parameter
        success:(requestSuccess)successed
           fail:(requestError)errored {
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [requestManager GET:path parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code !=0 ) {
            NSError * err = [[NSError alloc] initWithDomain:@"请求失败" code:1000 userInfo:nil];
            errored(err);
            return ;
        }
        id result = [dic objectForKey:@"result"];
        successed(result);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errored(error);
    }];
}

@end
