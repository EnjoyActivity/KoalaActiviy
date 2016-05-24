//
//  ActiveItemModel.m
//  ledong
//
//  Created by dengjc on 16/5/24.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import "ActiveItemModel.h"

@implementation ActiveItemModel

- (instancetype)init {
    if (self == [super init]) {
        self.Id = 0;
        self.activityId = 0;
        self.remark = @"";
        self.beginTime = @"";
        self.endTime = @"";
        self.entryMoney = 0;
        self.willNum = 0;
        self.maxNum = 0;
        self.constitutorId = 0;
        self.placeName = @"";
        self.address = @"";
        self.mapX = 0.0;
        self.mapY = 0.0;
        self.provinceCode = @"";
        self.cityCode = @"";
        self.areaCode = @"";
        self.className = @"";
        self.provinceName = @"";
        self.cityName = @"";
        self.areaName = @"";
        self.constitutorName = @"";
    }
    return self;
}

@end
