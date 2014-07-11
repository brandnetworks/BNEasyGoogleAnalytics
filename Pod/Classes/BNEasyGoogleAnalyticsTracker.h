//
//  BNEasyGoogleAnalyticsTracker.h
//  Pods
//
//  Created by bnicholas on 7/11/14.
//
//

#import <Foundation/Foundation.h>

@interface BNEasyGoogleAnalyticsTracker : NSObject

@property (nonatomic, assign) BOOL tracksUncaughtExceptions;
@property (nonatomic, assign) NSTimeInterval syncInterval;

+ (void) startWithTrackingId:(NSString *)trackingId;
+ (instancetype) sharedTracker;

- (void)trackEventWithCategory:(NSString *)category andAction:(NSString *)action andLabel:(NSString *)label andValue:(NSNumber *)value;
- (void)trackScreenNamed:(NSString *)screenName;
- (void)trackExceptionWithMessage:(NSString *)message andFatal:(BOOL)fatal;
- (void)trackSocialActivityWithNetwork:(NSString *)network andAction:(NSString *)action toTarget:(NSString *)target;

- (void)trackTweetToTarget:(NSString *)target;
- (void)trackLikeToTarget:(NSString *)target;
// Add aditional methods in here for different actions

- (void)sync;

@end
