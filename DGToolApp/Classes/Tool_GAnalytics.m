//
//  Tool_GAnalytics.m
//  May31_Noon
//
//  Created by KyungwooPark on 2016. 4. 24..
//  Copyright © 2016년 Kyungwoo. All rights reserved.
//

#import "Tool_GAnalytics.h"
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIFields.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>

@implementation Tool_GAnalytics

+ (void)initTrackerWithTrackingId:(NSString*)pTrackingId{

    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    [GAI sharedInstance].dispatchInterval = 20;

    // Initialize tracker.
    [[GAI sharedInstance] trackerWithTrackingId:@""];
    
    #ifdef DEBUG
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    #endif
    
    [[[GAI sharedInstance] defaultTracker] setAllowIDFACollection:true];
    
}


+ (void)gaSendView:(NSString*)pAppScreenName{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:pAppScreenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}

+ (void)gaSendEvent:(NSString*)category Action:(NSString*)action Label:(NSString*)label Value:(long)value{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:@((int)value)] build]];
    
}

/*
 * Called when a purchase is processed and verified.
 */
+ (void)gaSendPurchase{
    
    // Assumes a tracker has already been initialized with a property ID, otherwise
    // this call returns null.
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    
    
    [tracker send:[[GAIDictionaryBuilder createTransactionWithId:@"0_123456"             // (NSString) Transaction ID
                                                     affiliation:@"In-app Store"         // (NSString) Affiliation
                                                         revenue:@2.16F                  // (NSNumber) Order revenue (including tax and shipping)
                                                             tax:@0.17F                  // (NSNumber) Tax
                                                        shipping:@0                      // (NSNumber) Shipping
                                                    currencyCode:@"USD"] build]];        // (NSString) Currency code
    
    
    [tracker send:[[GAIDictionaryBuilder createItemWithTransactionId:@"0_123456"         // (NSString) Transaction ID
                                                                name:@"Space Expansion"  // (NSString) Product Name
                                                                 sku:@"L_789"            // (NSString) Product SKU
                                                            category:@"Game expansions"  // (NSString) Product category
                                                               price:@1.9F               // (NSNumber) Product price
                                                            quantity:@1                  // (NSInteger) Product quantity
                                                        currencyCode:@"USD"] build]];    // (NSString) Currency code
    
}

+ (void)gaSendSocialInteraction{
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    NSString *targetUrl = @"https://developers.google.com/analytics";
    
    [tracker send:[[GAIDictionaryBuilder createSocialWithNetwork:@"Twitter"
                                                          action:@"Tweet"
                                                          target:targetUrl] build]];
}

- (void)gaSendSignInWithUserID:(NSString*)pUserID {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // You only need to set User ID on a tracker once. By setting it on the tracker, the ID will be
    // sent with all subsequent hits.
    [tracker set:kGAIUserId
           value:pUserID];
    
    // This hit will be sent with the User ID value and be visible in User-ID-enabled views (profiles).
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"            // Event category (required)
                                                          action:@"User Sign In"  // Event action (required)
                                                           label:nil              // Event label
                                                           value:nil] build]];    // Event value
}

@end
