//
//  LDCityViewController.h
//  ledong
//
//  Created by 郑红 on 5/26/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^getCity)(NSDictionary *);

@interface LDCityViewController : UIViewController

@property (nonatomic,copy) NSString * cityName;
@property (nonatomic,copy) NSString * provinceCode;

@property (nonatomic,copy) getCity city;

@end
