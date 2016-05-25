//
//  ActivityAddressViewController.h
//  ledong
//
//  Created by liuxu on 16/5/24.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeActivityAddressInfo)(NSDictionary* dict);

@interface ActivityAddressViewController : UIViewController

- (void)setCompleteActivityAddressInfo:(completeActivityAddressInfo)block;

@end
