//
//  ContactTypeViewController.h
//  ledong
//
//  Created by liuxu on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeSelect)(NSString* str);

@interface ContactTypeViewController : UIViewController

- (void)setCompleteSelect:(completeSelect)block;

@end
