//
//  LocationView.h
//  ledong
//
//  Created by dengjc on 16/5/23.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationView : UIView
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@end
