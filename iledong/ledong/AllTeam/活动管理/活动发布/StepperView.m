//
//  StepperView.m
//  ledong
//
//  Created by liuxu on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "StepperView.h"

@interface StepperView()

@property (nonatomic, strong)UIButton* leftBtn;
@property (nonatomic, strong)UIButton* rightBtn;
@property (nonatomic, strong)UILabel* label;
@property (assign, nonatomic)NSInteger currentNum;
@property (nonatomic, copy)currentNumBlock block;

@end

@implementation StepperView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentNum = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self drawUI];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    NSInteger viewHeight = self.frame.size.height;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 22, 0);
    CGContextAddLineToPoint(ctx, 22, viewHeight);
    CGContextMoveToPoint(ctx, 48, 0);
    CGContextAddLineToPoint(ctx, 48, viewHeight);
    CGContextClosePath(ctx);
    CGContextSetLineWidth(ctx, 1);
    
    CGFloat red = ((float)((0xF2F2F2 & 0xFF0000) >> 16))/255.0;
    CGFloat green = ((float)((0xF2F2F2 & 0xFF00) >> 8))/255.0;
    CGFloat blue = ((float)(0xF2F2F2 & 0xFF))/255.0;
    CGContextSetRGBStrokeColor(ctx, red, green, blue, 1);
    CGContextStrokePath(ctx);
}

- (void)drawUI {
    self.layer.borderColor = UIColorFromRGB(0xF2F2F2).CGColor;
    self.layer.borderWidth = 1;
    
    self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, self.bounds.size.height)];
    [self addSubview:self.leftBtn];
    [self.leftBtn setImage:[UIImage imageNamed:@"ic_sub_grey"] forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageNamed:@"ic_sub"] forState:UIControlStateHighlighted];
    [self.leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 20, self.bounds.size.height)];
    self.label.text = [NSString stringWithFormat:@"%ld", self.currentNum];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.label];
    
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(25+20, 0, 25, self.bounds.size.height)];
    [self addSubview:self.rightBtn];
    [self.rightBtn setImage:[UIImage imageNamed:@"ic_add_grey"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateHighlighted];
    [self.rightBtn addTarget:self action:@selector(rightBtnBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftBtnClicked {
    @synchronized (self) {
        if (self.currentNum == 0)
            return;
        self.currentNum--;
        self.label.text = [NSString stringWithFormat:@"%ld", self.currentNum];
        if (self.block) {
            self.block(self.currentNum);
        }
    }
}

- (void)rightBtnBtnClicked {
    @synchronized (self) {
        self.currentNum++;
        self.label.text = [NSString stringWithFormat:@"%ld", self.currentNum];
        if (self.block) {
            self.block(self.currentNum);
        }
    }
}

- (void)setPreNum:(NSInteger)num {
    @synchronized (self) {
        self.currentNum = num;
    }
}
- (void)setCurrentSelectNum:(currentNumBlock)block {
    self.block = block;
}

@end
