//
//  LDLocationManager.m
//  ledong
//
//  Created by 郑红 on 5/19/16.
//  Copyright © 2016 LeDong. All rights reserved.
//

#import "LDLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LDLocationManager ()<CLLocationManagerDelegate>
{
    locationSuccess successResult;
    locationFail failResult;
}

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLGeocoder * geoCoder;

@end

@implementation LDLocationManager

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (CLGeocoder *)geoCoder {
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

- (void)updateLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    } else {
        if (failResult != nil) {
            NSDictionary *info = [NSDictionary dictionaryWithObject:@"位置获取失败"                                                                      forKey:NSLocalizedDescriptionKey];
            NSError * error = [[NSError alloc] initWithDomain:@"locationError" code:101 userInfo:info];
            failResult(error);
        }
    }
}

- (void)getLocationSuccess:(locationSuccess)success fail:(locationFail)fail {
    successResult = success;
    failResult = fail;
    [self updateLocation];
}


#pragma mark - locationDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (failResult != nil) {
        failResult(error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count == 0) {
        return;
    }
    CLLocation * location = [locations firstObject];
    CLLocationCoordinate2D  coordinate = location.coordinate;
    
    NSDictionary * infoDic = @{
                               @"longitude"   :[NSNumber numberWithDouble:coordinate.longitude],
                               @"latitude"    :[NSNumber numberWithDouble:coordinate.latitude],
                               };
    if (successResult != nil) {
        successResult(infoDic);
    }
    [self.locationManager stopUpdatingLocation];
    
}

#pragma mark - NetWork
- (void)requestLocationInfo:(double)latitude longitude:(double)longitude {
    NSDictionary * dic = @{
                           @"lng":[NSNumber numberWithDouble:longitude],
                           @"lat":[NSNumber numberWithDouble:latitude]
                           };
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager POST:@"Map/SuggestAddress" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code != 0) {
            return ;
        }
        NSDictionary * result = [dic objectForKey:@"result"];
        NSDictionary * locationInfo = [result objectForKey:@"addressComponent"];
        NSString * addressDetail = [result objectForKey:@"formatted_address"];
        
        [FRUtils setAddressDetail:addressDetail];
        [FRUtils setAddressInfo:locationInfo];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)getCityByProvinceCode:(NSString *)code success:(void (^)(NSArray * result))success failure :(void (^)(NSError * failReason))failReason {
    NSDictionary * dic = @{
                           @"ProvinceCode":code
                           };
    NSURL * baseUrl = [NSURL URLWithString:API_BASE_URL];
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    [manager GET:@"other/GetCitys" parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * resultDic = (NSDictionary *)responseObject;
        NSInteger code = [resultDic[@"code"] integerValue];
        if (code != 0) {
            return ;
        }
        
        NSArray * result = [resultDic objectForKey:@"result"];
        if (success) {
            success(result);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failReason) {
            failReason(error);
        }
    }];
}


@end
