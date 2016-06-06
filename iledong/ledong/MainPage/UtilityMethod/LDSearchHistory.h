//
//  LDSearchHistory.h
//  ledong
//
//  Created by 郑红 on 6/2/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define activityHistory @"activityHistory.plist"
#define teamHistory @"teamHistory.plist"
#define friendHistory @"friendHistory.plist"
#define mainHistory @"mainHistory.plist"

@interface LDSearchHistory : NSObject

+ (instancetype)defaultInstance;


- (NSArray *)getSearchHitory:(NSString*)type;
- (void)addSearchHistory:(NSString*)type Array:(NSArray*)history;
- (void)removeHistory:(NSString*)type;

@end
