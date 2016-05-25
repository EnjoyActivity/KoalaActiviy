//
//  SessionInfoViewController.h
//  ledong
//
//  Created by liuxu on 16/5/24.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeBlock)(BOOL isMoidfy, NSDictionary* dict);

@interface SessionInfoViewController : UIViewController

- (void)setPreDict:(NSDictionary*)dict;
- (void)setCompleteBlock:(completeBlock)block
                isModify:(BOOL)isModify;

@end
