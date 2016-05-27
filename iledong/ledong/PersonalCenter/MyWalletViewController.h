//
//  MyWalletViewController.h
//  ledong
//
//  Created by TDD on 16/3/9.
//  Copyright (c) 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"

@interface MyWalletViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy) NSString *navTitle;
@property (nonatomic,assign) int teamId;
@end
