//
//  GeographicInfoViewController.h
//  ledong
//
//  Created by liuxu on 16/5/26.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum GeographicType {
    GeographicTypeProvinces = 0,
    GeographicTypeCity,
    GeographicTypeAreas
}GeographicType;

typedef void (^completeSelect)(GeographicType type, NSDictionary* dict);

@interface GeographicInfoViewController : UIViewController

@property (nonatomic, assign)GeographicType type;
@property (nonatomic, assign)NSInteger preCode;

- (void)setSelectBlock:(completeSelect)block;

@end
