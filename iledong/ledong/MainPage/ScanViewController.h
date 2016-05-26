//
//  ScanViewController.h
//  ledong
//
//  Created by luojiao  on 16/3/28.
//  Copyright © 2016年 yangqiyao. All rights reserved.
//

#import "BaseViewController.h"
#import "ZHScanView.h"

@interface ScanViewController : BaseViewController<UIAlertViewDelegate>
{
    ZHScanView *scanView;
}

@end
