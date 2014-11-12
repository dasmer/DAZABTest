DAZABTest
=========
[![Build Status](https://travis-ci.org/dasmer/DAZABTest.svg?branch=master)](https://travis-ci.org/dasmer/DAZABTest) 
[![Coverage Status](https://coveralls.io/repos/dasmer/DAZABTest/badge.png?branch=master)](https://coveralls.io/r/dasmer/DAZABTest?branch=master)

DAZABTest is a simple split-testing framework with a synchronous API.

Test conditions are persisted across sessions and launches using NSUserDefaults, ensuring that every user will have a consistent experience, no matter which testing bucket they end up in.

Installation
------------
The easiest way to get started is to use [CocoaPods](http://cocoapods.org/). Just add the following line to your Podfile:

```ruby
pod 'DAZABTest', '~> 1.0'
```

Usage
-----

### Split-test with equal weights
```objective-c
NSString *buttonText = [DAZABTest splitTestWithName:@"SampleEqualWeightTestName"
											 values:@[@"Log In", @"Sign In", @"Submit", @"Confirm"]];
```

### Split-test with unequal weights
```objective-c
NSDictionary *conditions = @{[UIColor redColor]: @(0.30),
                             [UIColor blueColor]: @(0.25),
                             [UIColor yellowColor]: @(0.25),
                             [UIColor greenColor]: @(0.20)};
UIColor *buttonColor = [DAZABTest splitTestWithName:@"SampleUnequalWeightTestName"
										 conditions:conditions];
```

Acknowledgement
---------------
This library was inspired by [SkyLab](https://github.com/mattt/SkyLab) in an effort to create a simpler, sans-block based API.


Contributing
------------

We'd love to see your ideas for improving this library! The best way to contribute is by submitting a pull request. We'll do our best to respond to your patch as soon as possible. You can also submit a [new GitHub issue](https://github.com/dasmer/DAZABTest/issues/new) if you find bugs or have questions. :octocat:

Please make sure to follow our general coding style and add test coverage for new features!
