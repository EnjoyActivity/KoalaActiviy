//
//  ParameterTableViewController.h
//  ledong
//
//  Created by liuxu on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selectCellBlock)(NSDictionary* dict);

@interface ParameterTableViewController : UITableViewController

- (void)setSelectCellBlock:(selectCellBlock)block;
@property (nonatomic, strong)NSString* vcTitle;

@end
