//
//  UIView+TestView.m
//  Test
//
//  Created by liuxu on 16/5/30.
//  Copyright © 2016年 liuxu. All rights reserved.
//

#import "UIView+CoordinatesView.h"

@implementation UIView (CoordinatesView)

- (CGFloat)width {
    return self.bounds.size.width;
}

- (CGFloat)height {
    return self.bounds.size.height;
}

- (CGFloat)originX {
    return self.frame.origin.x;
}

- (CGFloat)originY {
    return self.frame.origin.y;
}

- (CGFloat)endX {
    return self.frame.origin.x+self.frame.size.width;
}

- (CGFloat)endY {
    return self.frame.origin.y + self.frame.size.height;
}

@end
