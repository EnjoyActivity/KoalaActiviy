//
//  LDMainPageNetWork.m
//  ledong
//
//  Created by 郑红 on 6/1/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import "LDMainPageNetWork.h"

@implementation LDMainPageNetWork

+ (instancetype)defaultInstance {
    static LDMainPageNetWork * netWork;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWork = [[LDMainPageNetWork alloc] init];
    });
    return netWork;
}

+ (void)getMainPageAd:(requestSuccess)successed requestError:(requestError)failed {
    
}

- (void)requestWithpath:(NSString *)path parameter:(NSDictionary *)parameter  {
//    NSURL * baseUrl = 
}
@end
