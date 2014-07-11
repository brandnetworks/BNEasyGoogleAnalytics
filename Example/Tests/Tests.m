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
    
    context(@"Setup", ^{
        it(@"should call into the google analytics setup method", ^{
            // setup
            sharedGAIMock = mock([GAI class]);
            SwizzleClassMethod([GAI class], @selector(sharedInstance), @selector(xxx_sharedInstance));
            
            // exercise
            [BNEasyGoogleAnalyticsTracker startWithTrackingId:@"tracking-hello"];
            
            // verify
            [verify(sharedGAIMock) trackerWithTrackingId:@"tracking-hello"];
            
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
            it(@"Should send a predictable dictionary to the tracker", ^{
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
            it(@"Should send a predictable dictionary to the tracker", ^{
                NSDictionary *resultDict = [[GAIDictionaryBuilder createExceptionWithDescription:@"Message"
                                                                                       withFatal:@NO] build];
                
                [commonTracker trackExceptionWithMessage:@"Message" andFatal:NO];
                
                [verify(mockGAITracker) send:resultDict];
            });
        });
    });
    
});

SpecEnd
