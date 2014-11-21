/*   Copyright 2013 APPNEXUS INC
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "ANBasicConfig.h"
#import ANLOCATIONHEADER
#import "ANLogging.h"

static NSInteger const kANLocationMaxLocationPrecision = 6;
static NSInteger const kANLocationDefaultHorizontalAccuracy = 100;

@interface ANLOCATION ()

@property (nonatomic, readwrite, assign) NSInteger precision;

@end

@implementation ANLOCATION

+ (ANLOCATION *)getLocationWithLatitude:(CGFloat)latitude
                              longitude:(CGFloat)longitude
                              timestamp:(NSDate *)timestamp
                     horizontalAccuracy:(CGFloat)horizontalAccuracy {
    return [ANLOCATION getLocationWithLatitude:latitude
                                     longitude:longitude
                                     timestamp:timestamp
                            horizontalAccuracy:horizontalAccuracy
                                     precision:-1];
}

+ (ANLocation *)getLocationWithLatitude:(CGFloat)latitude
                              longitude:(CGFloat)longitude
                              timestamp:(NSDate *)timestamp
                     horizontalAccuracy:(CGFloat)horizontalAccuracy
                              precision:(NSInteger)precision {
    BOOL invalidLatitude = latitude < -90 || latitude > 90;
    BOOL invalidLongitude = longitude < -180 || longitude > 180;
    BOOL invalidHorizontalAccuracy = horizontalAccuracy < 0;
    if (invalidLatitude || invalidLongitude || invalidHorizontalAccuracy) {
        return nil;
    }

    BOOL invalidPrecision = precision < -1;
    if (invalidPrecision) {
        ANLogWarn(@"Invalid precision passed in (%d) with location, no rounding will occur", (int)precision);
    }
    
    if (horizontalAccuracy == 0)
        horizontalAccuracy = kANLocationDefaultHorizontalAccuracy;
    
    if (timestamp == nil)
        timestamp = [NSDate date];
    
    // make a new object every time to make sure we don't use old data
    ANLOCATION *location = [[ANLOCATION alloc] init];
    if (precision <= -1) {
        location.latitude = latitude;
        location.longitude = longitude;
        location.precision = -1;
    } else {
        NSInteger effectivePrecision = precision;
        if (precision > kANLocationMaxLocationPrecision) {
            effectivePrecision = kANLocationMaxLocationPrecision;
        }
        
        CGFloat precisionFloat = powf(10, effectivePrecision);
        location.latitude = roundf(latitude * precisionFloat) / precisionFloat;
        location.longitude = roundf(longitude * precisionFloat) / precisionFloat;
        location.precision = effectivePrecision;
    }
    location.timestamp = timestamp;
    location.horizontalAccuracy = horizontalAccuracy;
    return location;
}

@end