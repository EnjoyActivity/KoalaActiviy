//
//  LDSearchHistory.m
//  ledong
//
//  Created by 郑红 on 6/2/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import "LDSearchHistory.h"

@implementation LDSearchHistory

+ (instancetype)defaultInstance {
    static LDSearchHistory * historyManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        historyManager = [[LDSearchHistory alloc] init];
    });
    return historyManager;
}

- (NSArray *)getSearchHitory:(NSString *)type {
    NSString * path = [self getPlistPath:type];
    NSArray * array = [NSArray arrayWithContentsOfFile:path];
    return array;
}

- (void)addSearchHistory:(NSString *)type Array:(NSArray *)history {
    NSString * path = [self getPlistPath:type];
    NSMutableArray * array = [NSMutableArray arrayWithContentsOfFile:path];
    [array addObjectsFromArray:history];
    [array writeToFile:path atomically:YES];
}

- (void)removeHistory:(NSString *)type {
    NSString * path = [self getPlistPath:type];
    NSError * error;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
}

#pragma mark - privetMetgod
- (NSString *)getPlistPath:(NSString *)type {
    NSString * docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * pathEnd = [NSString stringWithFormat:@"searchHistory/%@",type];
    NSString * plistPath = [docPath stringByAppendingPathComponent:pathEnd];
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:plistPath]) {
        NSString * pathTemp = [docPath stringByAppendingPathComponent:@"searchHistory"];
        [manager createDirectoryAtPath:pathTemp withIntermediateDirectories:nil attributes:nil error:nil];
        [manager createFileAtPath:docPath contents:nil attributes:nil];
    }
    return plistPath;
}

@end
