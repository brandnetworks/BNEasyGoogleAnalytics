//
//  BNEasyGoogleAnalyticsTests.m
//  BNEasyGoogleAnalyticsTests
//
//  Created by Ben Nicholas on 07/10/2014.
//  Copyright (c) 2014 Ben Nicholas. All rights reserved.
//

#import "objc/runtime.h"
#import <BNEasyGoogleAnalytics/BNEasyGoogleAnalyticsTracker.h>
#import <BNEasyGoogleAnalytics/BNEasyGoogleAnalyticsTracker_private.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

void SwizzleClassMethod(Class c, SEL orig, SEL new) {
    
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
    
    c = object_getClass((id)c);
    
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

GAI *sharedGAIMock;

@interface GAI (SharedInstanceTestSwizzle)

+(GAI *)xxx_sharedInstance;

@end

@implementation GAI (SharedInstanceTestSwizzle)

+ (GAI *)xxx_sharedInstance
{
    return sharedGAIMock;
}

@end

SpecBegin(TrackerSpec)

describe(@"Easy Google Analytics Tracker", ^{
    
    context(@"Mocked GAI", ^{
            beforeAll(^{
                // setup
                sharedGAIMock = mock([GAI class]);
                SwizzleClassMethod([GAI class], @selector(sharedInstance), @selector(xxx_sharedInstance));
            });
        
            context(@"Setup", ^{
                it(@"should call into the google analytics setup method", ^{
                    // exercise
                    [BNEasyGoogleAnalyticsTracker startWithTrackingId:@"tracking-hello"];
                
                    // verify
                    [verify(sharedGAIMock) trackerWithTrackingId:@"tracking-hello"];
                
                });
            });
            
            context(@"Manual syncing", ^{
                it(@"Should allow for manually syncing to Google Analytics", ^{
                    id<GAITracker> mockGAITracker = mockProtocol(@protocol(GAITracker));
                    BNEasyGoogleAnalyticsTracker *commonTracker = [[BNEasyGoogleAnalyticsTracker alloc] initWithTracker:mockGAITracker];
                    
                    [commonTracker sync];
                    
                    [(GAI *)verify(sharedGAIMock) dispatch];
                });
            });
            
            afterAll(^{
                // teardown
                SwizzleClassMethod([GAI class], @selector(sharedInstance), @selector(xxx_sharedInstance));
            });

    });
    
    context(@"Shared Instance", ^{
        it(@"Should return an instance", ^{
            expect([BNEasyGoogleAnalyticsTracker sharedTracker]).toNot.beNil();
        });
        
        it(@"Should return the same instance across calls", ^{
            expect([BNEasyGoogleAnalyticsTracker sharedTracker]).to.beIdenticalTo([BNEasyGoogleAnalyticsTracker sharedTracker]);
        });
    });
    
    context(@"Tracking", ^{
        
        BNEasyGoogleAnalyticsTracker *__block commonTracker;
        id<GAITracker> __block mockGAITracker;
        
        beforeEach(^{
            mockGAITracker = mockProtocol(@protocol(GAITracker));
            commonTracker = [[BNEasyGoogleAnalyticsTracker alloc] initWithTracker:mockGAITracker];
        });
        
        context(@"Events", ^{
            it(@"Should construct a Google Analytics event with the given values", ^{
                // setup
                NSDictionary *resultDict = [[GAIDictionaryBuilder createEventWithCategory:@"Category"
                                                                                   action:@"Action"
                                                                                    label:@"Label"
                                                                                    value:@42] build];
                
                // exercise
                [commonTracker trackEventWithCategory:@"Category"
                                            andAction:@"Action"
                                             andLabel:@"Label"
                                             andValue:@42];
                
                // verify
                [verify(mockGAITracker) send:resultDict];
                
                // teardown
            });
        });
        
        context(@"Exception", ^{
            it(@"Should construct a Google Analytics exception report with the given values", ^{
                NSDictionary *resultDict = [[GAIDictionaryBuilder createExceptionWithDescription:@"Message"
                                                                                       withFatal:@NO] build];
                
                [commonTracker trackExceptionWithMessage:@"Message" andFatal:NO];
                
                [verify(mockGAITracker) send:resultDict];
            });
        });
        
        context(@"Screen", ^{
            it(@"Should track a screen to Google Analytics", ^{
                NSDictionary *resultDict = [[GAIDictionaryBuilder createAppView] build];
                
                [commonTracker trackScreenNamed:@"Screen"];
                
                [verify(mockGAITracker) send:resultDict];
                [verify(mockGAITracker) set:kGAIScreenName value:@"Screen"];
            });
        });
        
        context(@"Social", ^{
            it(@"Should construct a Google Analytics social report with the given values", ^{
                NSDictionary *resultDict = [[GAIDictionaryBuilder createSocialWithNetwork:@"Network"
                                                                                   action:@"Action"
                                                                                   target:@"Target"] build];
                
                [commonTracker trackSocialActivityWithNetwork:@"Network"
                                                    andAction:@"Action"
                                                     toTarget:@"Target"];
                
                [verify(mockGAITracker) send:resultDict];
            });
            
            it(@"Should track tweets to Google Analytics", ^{
                NSDictionary *resultDict = [[GAIDictionaryBuilder createSocialWithNetwork:kTwitterSocialNetwork
                                                                                   action:kTweetSocialAction
                                                                                   target:@"Target"] build];
                
                [commonTracker trackTweetToTarget:@"Target"];
                
                [verify(mockGAITracker) send:resultDict];
            });
            
            it(@"Should track likes to Google Analytics", ^{
                NSDictionary *resultDict = [[GAIDictionaryBuilder createSocialWithNetwork:kFacebookSocialNetwork
                                                                                   action:kLikeSocialAction
                                                                                   target:@"Target"] build];
                
                [commonTracker trackLikeToTarget:@"Target"];
                
                [verify(mockGAITracker) send:resultDict];
            });
        });
        
        context(@"Timing", ^{
            it(@"Should track time taken when time is provided", ^{
                NSDictionary *resultDict = [[GAIDictionaryBuilder createTimingWithCategory:@"Category"
                                                                                  interval:@42.0
                                                                                      name:@"Name"
                                                                                     label:@"Label"] build];
                
                [commonTracker trackTimePeriod:@42.0 withCategory:@"Category" forName:@"Name" andLabel:@"Label"];
                
                [verify(mockGAITracker) send:resultDict];
            });
            it(@"Should track time taken when given a block", ^{
                [commonTracker trackTimeSpentInBlock:^{
                    [NSThread sleepForTimeInterval:1];
                }
                                        withCategory:@"Category"
                                             forName:@"Name"
                                            andLabel:@"Label"];
                
                MKTArgumentCaptor *argument = [[MKTArgumentCaptor alloc] init];
                [verify(mockGAITracker) send:[argument capture]];
                
                NSDictionary *returnDict = [argument value];
                expect([returnDict[kGAITimingValue] integerValue]).to.beCloseToWithin(1000, 100);
                expect(returnDict[kGAITimingCategory]).to.equal(@"Category");
                expect(returnDict[kGAITimingVar]).to.equal(@"Name");
                expect(returnDict[kGAITimingLabel]).to.equal(@"Label");
                expect(returnDict[kGAIHitType]).to.equal(kGAITiming);
            });
            it(@"Should track time spent in an asynchronous block", ^AsyncBlock {
                [commonTracker trackAsyncTimeSpentInBlock:^(void (^send)(void)) {
                    [NSThread sleepForTimeInterval:1];
                    send();
                    
                    MKTArgumentCaptor *argument = [[MKTArgumentCaptor alloc] init];
                    [verify(mockGAITracker) send:[argument capture]];
                    
                    NSDictionary *returnDict = [argument value];
                    expect([returnDict[kGAITimingValue] integerValue]).to.beCloseToWithin(1000, 100);
                    expect(returnDict[kGAITimingCategory]).to.equal(@"Category");
                    expect(returnDict[kGAITimingVar]).to.equal(@"Name");
                    expect(returnDict[kGAITimingLabel]).to.equal(@"Label");
                    expect(returnDict[kGAIHitType]).to.equal(kGAITiming);
                    done();
                }
                                             withCategory:@"Category"
                                                  forName:@"Name"
                                                 andLabel:@"Label"];
            });
        });
    });
    

    
});

SpecEnd
