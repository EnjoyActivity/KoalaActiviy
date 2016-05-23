//
//  StepperView.h
//  ledong
//
//  Created by liuxu on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^currentNumBlock)(NSInteger num);

@interface StepperView : UIView

- (void)setPreNum:(NSInteger)num;
- (void)setCurrentSelectNum:(currentNumBlock)block;

@end
