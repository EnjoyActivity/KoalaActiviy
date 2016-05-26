//
//  LDActivityViewController.h
//  ledong
//
//  Created by 郑红 on 5/19/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDActivityViewController : UIViewController

@property (nonatomic,assign) NSInteger activityId;
@property (nonatomic,copy) NSString * activityClassName;
@property (nonatomic,copy) NSArray * activityClassArray;
@property (nonatomic,copy) NSDictionary * locationDic;
@end
