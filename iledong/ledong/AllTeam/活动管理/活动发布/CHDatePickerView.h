//
//  CHDatePickerView.h
//  test
//
//  Created by liuxu on 15/10/28.
//  Copyright (c) 2015年 liuxu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeDateInt)(int year, int month, int day, int hours, int minutes);
typedef void (^completeDateStr)(NSString* str); //2015年01月01日00时59分
typedef void (^cancelSelete)(BOOL);
@interface CHDatePickerView : UIView

@property(nonatomic, copy) cancelSelete cancelSeleteDate;
- (id)initWithSuperView:(UIView*)superView
        completeDateInt:(completeDateInt)intBlock
        completeDateStr:(completeDateStr)strBlock;


@end
