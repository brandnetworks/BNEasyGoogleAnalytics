//
//  BNEasyGoogleAnalyticsTracker_private.h
//  Pods
//
//  Created by bnicholas on 7/11/14.
//
//

#import "GAITracker.h"

@interface BNEasyGoogleAnalyticsTracker ()

/**
 *  The internal GAITracker being used by the system
 */
@property (nonatomic, strong) id<GAITracker> tracker;

/**
 *  Internal only initializer for creating a Tracker given a GAITracker
 *
 *  @param tracker A GAITracker being provided by the underlying Google Analytics SDK
 *
 *  @return An initialized easy tracker.
 */
- (instancetype)initWithTracker:(id)tracker;

@end
