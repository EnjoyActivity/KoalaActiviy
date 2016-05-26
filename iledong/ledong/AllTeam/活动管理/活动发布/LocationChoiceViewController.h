//
//  LocationChoiceViewController.h
//  ledong
//
//  Created by liuxu on 16/5/26.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeLocationChoice)(NSDictionary* dict);

@interface LocationChoiceViewController : UIViewController

- (void)setCompleteBlock:(completeLocationChoice)block;

@end
