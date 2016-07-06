//
//  Tool_GAnalytics.m
//  May31_Noon
//
//  Created by KyungwooPark on 2016. 4. 24..
//  Copyright © 2016년 Kyungwoo. All rights reserved.
//

#import "Tool_GAnalytics.h"
//#import <GoogleAnalytics/GAI.h>
//#import <GoogleAnalytics/GAIFields.h>
//#import <GoogleAnalytics/GAIDictionaryBuilder.h>

@implementation Tool_GAnalytics

+ (void)initTrackerWithTrackingId:(NSString*)pTrackingId{

    // Optional: automatically send uncaught exceptions to Google Analytics.
//    [GAI sharedInstance].trackUncaughtExceptions = YES;
//    
//    [GAI sharedInstance].dispatchInterval = 20;
//
//    // Initialize tracker.
//    [[GAI sharedInstance] trackerWithTrackingId:@""];
//    
//    #ifdef DEBUG
//    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
//    #endif
//    
//    [[[GAI sharedInstance] defaultTracker] setAllowIDFACollection:true];
    
}


+ (void)gaSendView:(NSString*)pAppScreenName{
    
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker set:kGAIScreenName value:pAppScreenName];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}

+ (void)gaSendEvent:(NSString*)category Action:(NSString*)action Label:(NSString*)label Value:(long)value{
    
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
//                                                          action:action
//                                                           label:label
//                                                           value:@((int)value)] build]];
    
}

@end
