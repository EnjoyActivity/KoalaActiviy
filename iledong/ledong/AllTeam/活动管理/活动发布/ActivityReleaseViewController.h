//
//  ActivityReleaseViewController.h
//  ledong
//
//  Created by liuxu on 16/5/20.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface ActivityReleaseViewController : UIViewController

@property (nonatomic, strong)NSString* teamId;
@property (nonatomic, strong)NSString* activityId;

- (id)initWithPreDictionary:(NSDictionary*)dict;

@end
