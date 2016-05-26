//
//  LDLocationManager.h
//  ledong
//
//  Created by 郑红 on 5/19/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^locationSuccess)(NSDictionary *);
typedef void(^locationFail)(NSError *);

@interface LDLocationManager : NSObject


- (void)getLocationSuccess:(locationSuccess)success fail:(locationFail)fail;

- (void)getCityByProvinceCode:(NSString *)code
                      success:(void(^)(NSArray * ))successResult
                      failure:(void(^)(NSError * ))failReason;

@end
