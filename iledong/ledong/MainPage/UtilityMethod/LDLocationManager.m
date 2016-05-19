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
    CLLocation * location = [locations firstObject];
    CLLocationCoordinate2D  coordinate = location.coordinate;
    
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            if (failResult != nil) {
                failResult(error);
            }
        }
        if (placemarks.count == 0) {
            return ;
        }
        CLPlacemark * mark = [placemarks firstObject];
        NSDictionary * dic = mark.addressDictionary;
        
        NSString * city = mark.locality;
        if (!city) {
            city = mark.administrativeArea;
        }
        NSDictionary * infoDic = @{
                               @"longitude"   :[NSNumber numberWithDouble:coordinate.longitude],
                               @"latitude"    :[NSNumber numberWithDouble:coordinate.latitude],
                               @"areaCode"    :dic[@"postalCode"],
                                 @"city"        :city
                               };
        if (successResult != nil) {
            successResult(infoDic);
        }
        [self.locationManager stopUpdatingLocation];
    }];
    

}

@end
