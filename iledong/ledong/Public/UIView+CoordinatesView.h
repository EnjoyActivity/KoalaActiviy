//
//  UIView+TestView.h
//  Test
//
//  Created by liuxu on 16/5/30.
//  Copyright © 2016年 liuxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CoordinatesView)

@property (assign, nonatomic, readonly)CGFloat width;
@property (assign, nonatomic, readonly)CGFloat height;
@property (assign, nonatomic, readonly)CGFloat originX;
@property (assign, nonatomic, readonly)CGFloat originY;
@property (assign, nonatomic, readonly)CGFloat endX;
@property (assign, nonatomic, readonly)CGFloat endY;

@end
