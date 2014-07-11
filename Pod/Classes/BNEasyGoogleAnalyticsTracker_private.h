//
//  BNEasyGoogleAnalyticsTracker_private.h
//  Pods
//
//  Created by bnicholas on 7/11/14.
//
//

#import "GAITracker.h"

@interface BNEasyGoogleAnalyticsTracker ()

@property (nonatomic, strong) id<GAITracker> tracker;

- (instancetype)initWithTracker:(id)tracker;

@end
