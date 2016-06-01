//
//  LDMainPageNetWork.h
//  ledong
//
//  Created by 郑红 on 6/1/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestSuccess)(NSArray *);
typedef void(^requestError)(NSError*);

@interface LDMainPageNetWork : NSObject

+ (instancetype)defaultInstance;


+ (void)getMainPageAd:(requestSuccess)successed requestError:(requestError)failed;
@end
