/*   Copyright 2015 APPNEXUS INC
 
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

#import <Foundation/Foundation.h>
#import "ANAdFetcher.h"

@protocol ANInterstitialAdFetcherDelegate;

#define kANANInterstitialAdFetcherUseUTV2 1

#if kANANInterstitialAdFetcherUseUTV2
static NSString *const kANInterstitialAdFetcherDefaultRequestUrlString = @"http://mediation.adnxs.com/ut/v2";
//static NSString *const kANInterstitialAdFetcherDefaultRequestUrlString = @"http://rlissack.adnxs.net:8080/jtest/utv2html";
//static NSString *const kANInterstitialAdFetcherDefaultRequestUrlString = @"http://rlissack.adnxs.net:8080/jtest/utv2csmnobid";
#else
static NSString *const kANInterstitialAdFetcherDefaultRequestUrlString = @"http://mediation.adnxs.com/ut/v1";
#endif

@interface ANInterstitialAdFetcher : NSObject

- (instancetype)initWithDelegate:(id<ANInterstitialAdFetcherDelegate>)delegate;
- (void)stopAdLoad;
- (void)fireResultCB:(NSString *)resultCBString
              reason:(ANAdResponseCode)reason
            adObject:(id)adObject
           auctionID:(NSString *)auctionID;
- (NSTimeInterval)getTotalLatency:(NSTimeInterval)stopTime;

@end

@protocol ANInterstitialAdFetcherDelegate <ANAdFetcherDelegate>

- (NSMutableSet *)allowedAdSizes;

@optional

- (void)interstitialAdFetcher:(ANInterstitialAdFetcher *)fetcher
 didFinishRequestWithResponse:(ANAdFetcherResponse *)response;

@end