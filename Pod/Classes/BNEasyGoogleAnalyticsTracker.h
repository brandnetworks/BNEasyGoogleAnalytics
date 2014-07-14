//
//  BNEasyGoogleAnalyticsTracker.h
//  Pods
//
//  Created by bnicholas on 7/11/14.
//
//

#import <Foundation/Foundation.h>

/**
 *  This is the standard string to describe Twitter as the network when tracking social activity
 */
extern NSString *const kTwitterSocialNetwork;
/**
 *  This is the standard string to describe Facebook as the network when tracking social activity
 */
extern NSString *const kFacebookSocialNetwork;
/**
 *  This is the standard string to describe Tweeting as the action when tracking social activity
 */
extern NSString *const kTweetSocialAction;
/**
 *  This is the standard string to describe liking as the action when tracking social activity
 */
extern NSString *const kLikeSocialAction;

/**
 *  BNEasyGoogleAnalyticsTracker is a basic tracker allowing a more fluent iOS-style interface to Google Analytics tracking
 */
@interface BNEasyGoogleAnalyticsTracker : NSObject

/**
 *  A property determining whether uncaught exceptions should be automatically reported to Google Analytics.
 *
 * This property defaults to NO
 */
@property (nonatomic, assign) BOOL tracksUncaughtExceptions;
/**
 *  How long should the system wait between issuing syncs to Google Analytics servers.
 *
 *  Values are saved into a local cache before sending directly to the server. This determines 
 *  how often that cache is drained into the cannonical web store.
 *
 *  This property defaults to 120.
 */
@property (nonatomic, assign) NSTimeInterval syncInterval;

/**
 *  Initialize a common tracker with the given tracking ID.
 *
 *  This will create a default tracker that is registered with the given trackign id. This should be called from the
 *  AppDelegate didFinishLaunchingWithOptions method, so that the tracking ID is available everywhere else in the application.
 *
 *  @param trackingId The tracking ID that is provided by Google.
 */
+ (void) startWithTrackingId:(NSString *)trackingId;
/**
 *  Global accessor for the default tracker
 *
 *  Returns the shared tracker that is automatically configured with your tracking ID.
 *
 *  @return The shared tracker.
 */
+ (instancetype) sharedTracker;

/**
 *  Track an event to Google Analytics.
 *
 *  This method allows you to log a custom event against the Google Analytics API, with the given parameters.
 *
 *  @param category The category of the event.
 *  @param action   The action associated with the event.
 *  @param label    The label for the given event. May be nil.
 *  @param value    A value attached to the event. May be nil.
 */
- (void)trackEventWithCategory:(NSString *)category andAction:(NSString *)action andLabel:(NSString *)label andValue:(NSNumber *)value;
/**
 *  Track a screen view to Google Analytics.
 *
 *  This method allows you to track the user viewing a particular screen (or view controller) within the application.
 *
 *  @param screenName The name of the screen viewed.
 */
- (void)trackScreenNamed:(NSString *)screenName;
/**
 *  Track an exception discovered in the application.
 *
 *  This method allows you to log a discovered exception against Google Analytics with the given parameters.
 *
 *  @param message A description of the exception, which can be up to 100 characters. May be nil.
 *  @param fatal   YES if the exception was fatal to the application, NO if it was recoverable.
 */
- (void)trackExceptionWithMessage:(NSString *)message andFatal:(BOOL)fatal;
/**
 *  Track social interactions within the application.
 *
 *  This method allows you to track social network activity from withinthe application to Google Analytics.
 *
 *  @param network The social network the user is interacting with
 *  @param action  The action being taken (Like, comment, tweet, etc.).
 *  @param target  The content the action is being taken on. May be nil.
 */
- (void)trackSocialActivityWithNetwork:(NSString *)network andAction:(NSString *)action toTarget:(NSString *)target;
/**
 *  Track time spent performing an action.
 *
 *  This method allows you to track how long it takes to perform a given action. This variant is used when the time taken is
 *  determined externally.
 *
 *  @param timing   The timing measurement in milliseconds.
 *  @param category The category of the timed event.
 *  @param name     The name of the timed event. May be nil.
 *  @param label    The label for the timed event. May be nil.
 */
- (void)trackTimePeriod:(NSNumber *)timing withCategory:(NSString *)category forName:(NSString *)name andLabel:(NSString *)label;
/**
 *  Track time spent working in a block.
 *
 *  This method allows you to track how long it takes to perform a given action. This variant is used when the time taken is 
 *  determined by the amount of time spent synchronously in a block.
 *
 *  @param block    The block to time.
 *  @param category The category of the timed event.
 *  @param name     The name of the timed event. May be nil.
 *  @param lable    The label for the timed event. May be nil.
 */
- (void)trackTimeSpentInBlock:(void (^)())block withCategory:(NSString *)category forName:(NSString *)name andLabel:(NSString *)label;
/**
 *  Track time spent working in a block asynchronously.
 *
 *  This method allows you to track how long it takes to perform a given action. This variant is used when the time taken is 
 *  determined by the amount of time spent in a block that involves asynchronous operations.
 *
 *  @param block    The block to time. The first parameter(done) must be called when processing is done.
 *  @param category The category of the timed event.
 *  @param name     The name of the timed event. May be nil.
 *  @param label    The label for the timed event. May be nil.
 */
- (void)trackAsyncTimeSpentInBlock:(void (^)(void (^done)(void)))block withCategory:(NSString *)category forName:(NSString *)name andLabel:(NSString *)label;

/**
 *  Track a Tweet to Google Analytics.
 * 
 *  This is just a convenient wrapper for tracking a Tweet.
 *
 *  @param target The content that is being tweeted. May be nil.
 */
- (void)trackTweetToTarget:(NSString *)target;
/**
 *  Track a Facebook like to Google Analytics.
 *
 *  This is just a convenient wrapper for tracking a Like.
 *
 *  @param target The content that is being liked. May be nil.
 */
- (void)trackLikeToTarget:(NSString *)target;
// Add aditional methods in here for different actions

/**
 *  Manually initiate a sync with Google Analytics.
 *
 *  This allows you to manually drain the cache out to the canonical web store on Google's servers. This is
 *  primarily useful when the application is about to exit or otherwise needs to immediately sync any information that is
 *  on the device.
 */
- (void)sync;

@end
