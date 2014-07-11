//
//  BNEasyGoogleAnalyticsTests.m
//  BNEasyGoogleAnalyticsTests
//
//  Created by Ben Nicholas on 07/10/2014.
//  Copyright (c) 2014 Ben Nicholas. All rights reserved.
//

#import "objc/runtime.h"
#import <BNEasyGoogleAnalytics/BNEasyGoogleAnalyticsTracker.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>

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
    
});

SpecEnd
