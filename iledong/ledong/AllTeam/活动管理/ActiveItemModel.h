//
//  ActiveItemModel.h
//  ledong
//
//  Created by dengjc on 16/5/24.
//  Copyright © 2016年 LeDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActiveItemModel : NSObject

@property (nonatomic,assign) int Id;
@property (nonatomic,assign) int activityId;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *beginTime;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,assign) int entryMoney;
@property (nonatomic,assign) int willNum;
@property (nonatomic,assign) int maxNum;
@property (nonatomic,assign) int applyNum;
@property (nonatomic,assign) int maxApplyNum;
@property (nonatomic,assign) int constitutorId;
@property (nonatomic,copy) NSString *placeName;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,assign) double mapX;
@property (nonatomic,assign) double mapY;
@property (nonatomic,copy) NSString *provinceCode;
@property (nonatomic,copy) NSString *cityCode;
@property (nonatomic,copy) NSString *areaCode;
@property (nonatomic,copy) NSString *className;
@property (nonatomic,copy) NSString *provinceName;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *areaName;
@property (nonatomic,copy) NSString *constitutorName;

@end
