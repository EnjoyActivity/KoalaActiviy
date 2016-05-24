//
//  SessionInfoViewController.h
//  ledong
//
//  Created by liuxu on 16/5/24.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeBlock)(NSDictionary* dict);

@interface SessionInfoViewController : UIViewController

- (void)setCompleteBlock:(completeBlock)block;

@end
