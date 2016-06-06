//
//  LDMainPageNetWork.h
//  ledong
//
//  Created by 郑红 on 6/1/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - netWorkPath

#define MGetProvince  @"other/getprovinces"
#define MGetCity  @"other/GetCitys"
#define MGetArea @"other/GetAreas"
#define MSearchCity @"Map/SuggestAddress"
#define MQueryActivity @"Activity/QueryActivitys"
#define MQueryTeams @"Team/QueryTeams"
#define MGetHotSearch @"Other/GetKeywords"
#define MGetAd @"Config/FeaturesImages"
#define MGetActivityClass @"ActivityClass/GetActivityClass"
#define MGetHotTeam @"Team/GetHotTeams"
#define MGetLocation @"map/Geolocate"

typedef void(^requestSuccess)(id result);
typedef void(^requestError)(NSError* error);

#pragma mark - init

@interface LDMainPageNetWork : NSObject

+ (instancetype)defaultInstance;

#pragma mark - MainPageRequest
- (void)postPath:(NSString *)path
       parameter:(NSDictionary *)parameter
         success:(requestSuccess)successed
            fail:(requestError)errored;

- (void)getPath:(NSString *)path
       parameter:(NSDictionary *)parameter
         success:(requestSuccess)successed
            fail:(requestError)errored;

@end
