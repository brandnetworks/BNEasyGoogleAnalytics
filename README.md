# BNEasyGoogleAnalytics

[![CI Status](http://img.shields.io/travis/brandnetworks/BNEasyGoogleAnalytics.svg?style=flat)](https://travis-ci.org/Ben Nicholas/BNEasyGoogleAnalytics)
[![Version](https://img.shields.io/cocoapods/v/BNEasyGoogleAnalytics.svg?style=flat)](http://cocoadocs.org/docsets/BNEasyGoogleAnalytics)
[![License](https://img.shields.io/cocoapods/l/BNEasyGoogleAnalytics.svg?style=flat)](http://cocoadocs.org/docsets/BNEasyGoogleAnalytics)
[![Platform](https://img.shields.io/cocoapods/p/BNEasyGoogleAnalytics.svg?style=flat)](http://cocoadocs.org/docsets/BNEasyGoogleAnalytics)

An improved interface to Google Analytics

## Introduction

Google's Analytics products are wonderful, but the iOS SDK doesn't have a very native feeling Objective C api. This library intends to create a much more enjoyable interface to that same trusted functionality underneath.

## Setup

[CocoaPods](https://github.com/CocoaPods/CocoaPods) is the only distrobution method supported, but if you need to use it otherwise, the code shouldn't be too hard to integrate manually. Otherwise, add this line to your podfile and you should be all set:

```ruby
pod 'BNEasyGoogleAnalytics'
```

Once you've got the code in place, getting tracking in place is as easy as calling one method in your app delegate's didFinishLaunching method, as described below:

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize Google Analytics tracking
    [BNEasyGoogleAnalyticsTracker startWithTrackingId:@"<#Tracking ID#>"];

    ...The rest of your customizations...
}
```

Don't forget to fill in your tracking ID as provided by Google. This should be placed towards the top of the didFinishLaunching method, as any other operation using the tracker requires this initial setup before being called.

## Usage

Where needed, get the shared tracker and track whatever has just happened. For example, a common use case is tracking a screen hit when viewWillAppear is called.

```objc
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[BNEasyGoogleAnalyticsTracker sharedTracker] trackScreenNamed:@"My Screen"];
}
```

There is currently also support for tracking custom events, exceptions, social interactions and timings. For now, reference the tests to see how to use these methods.

## Contribution

Development and issues are tracked here on Github. Pull requests are welcomed.

### Contribution Guidelines

* Please use spaces when indenting, 4 at a time.
* Test whatever seems reasonable when adding functionality.
* Pull requests should be developed on a feature branch. 
* Add yourself to the contributors list if this if your first contribution to the project.

## Credits

BNEasyGoogleAnalytics is brought to you by Brand Networks, Inc. and the contributors listed below.

### Contributors

* [Ben Nicholas](https://github.com/bmnick)

## License

BNEasyGoogleAnalytics is available under the [apache 2 license](https://github.com/brandnetworks/BNEasyGoogleAnalytics/blob/master/LICENSE).

