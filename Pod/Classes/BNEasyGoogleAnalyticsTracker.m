//
//  BNEasyGoogleAnalyticsTracker.m
//  Pods
//
//  Created by bnicholas on 7/11/14.
//
//

#import "BNEasyGoogleAnalyticsTracker.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

@interface BNEasyGoogleAnalyticsTracker ()

@property (nonatomic, strong) id<GAITracker> tracker;

- (instancetype)initWithTracker:(id)tracker;

@end

@implementation BNEasyGoogleAnalyticsTracker

- (instancetype)initWithTracker:(id)tracker
{
    self = [super init];
    if (self) {
        self.tracker = tracker;
    }
    return self;
}

#pragma mark - Setup

+ (void)startWithTrackingId:(NSString *)trackingId
{
    [[GAI sharedInstance] trackerWithTrackingId:trackingId];
}

+ (instancetype)sharedTracker
{
    static BNEasyGoogleAnalyticsTracker *tracker;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        tracker = [[BNEasyGoogleAnalyticsTracker alloc] initWithTracker:[[GAI sharedInstance] defaultTracker]];
    });
    
    return tracker;
}

#pragma mark - Tracking

- (void)trackEventWithCategory:(NSString *)category andAction:(NSString *)action andLabel:(NSString *)label andValue:(NSNumber *)value
{
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                               action:action
                                                                label:label
                                                                value:value] build]];
}

- (void)trackScreenNamed:(NSString *)screenName;
{
    [self.tracker set:kGAIScreenName
                value:screenName];
    
    [self.tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)trackExceptionWithMessage:(NSString *)message andFatal:(NSNumber *)fatal
{
    [self.tracker send:[[GAIDictionaryBuilder createExceptionWithDescription:message
                                                                   withFatal:fatal] build]];
}

- (void)trackSocialActivityWithNetwork:(NSString *)network andAction:(NSString *)action toTarget:(NSString *)target
{
    [self.tracker send:[[GAIDictionaryBuilder createSocialWithNetwork:network
                                                               action:action
                                                               target:target] build]];
}

#pragma mark - Social sharing

- (void)trackTweetToTarget:(NSString *)target
{
    [self trackSocialActivityWithNetwork:@"Twitter" andAction:@"Tweet" toTarget:target];
}

- (void)trackLikeToTarget:(NSString *)target
{
    [self trackSocialActivityWithNetwork:@"Facebook" andAction:@"Like" toTarget:target];
}

#pragma mark - Properties

- (void)setTracksUncaughtExceptions:(BOOL)tracksUncaughtExceptions
{
    [[GAI sharedInstance] setTrackUncaughtExceptions:tracksUncaughtExceptions];
}

- (BOOL)tracksUncaughtExceptions
{
    return [[GAI sharedInstance] trackUncaughtExceptions];
}

- (void)setSyncInterval:(NSTimeInterval)syncInterval
{
    [GAI sharedInstance].dispatchInterval = syncInterval;
}

- (NSTimeInterval)syncInterval
{
    return [GAI sharedInstance].dispatchInterval;
}

#pragma mark - Manual syncing

- (void)sync {
    [[GAI sharedInstance] dispatch];
}


@end
