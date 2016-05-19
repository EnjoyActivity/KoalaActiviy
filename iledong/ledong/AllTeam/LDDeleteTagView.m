//
//  LDDeleteTagView.m
//  ledong
//
//  Created by liuxu on 16/5/19.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "LDDeleteTagView.h"

@implementation LDDeleteTagView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel* label = [[UILabel alloc]initWithFrame:self.bounds];
        label.text = @"删除";
        label.font = [UIFont systemFontOfSize:14.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x333333);
        [self addSubview:label];
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    NSInteger viewWidth = self.frame.size.width;
    NSInteger viewHeight = self.frame.size.height;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, viewWidth, 0);
    CGContextAddLineToPoint(ctx, viewWidth, viewHeight-5);
    CGContextAddLineToPoint(ctx, viewWidth/2+5, viewHeight-5);
    CGContextAddLineToPoint(ctx, viewWidth/2, viewHeight);
    CGContextAddLineToPoint(ctx, viewWidth/2-5, viewHeight-5);
    CGContextAddLineToPoint(ctx, 0, viewHeight-5);
    CGContextAddLineToPoint(ctx, 0, 0);

    [UIColorFromRGB(0xDEDEDE) setStroke];
    CGContextSetLineWidth(ctx, 1);
    CGContextStrokePath(ctx);
}

@end
