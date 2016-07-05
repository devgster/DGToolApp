//
//  Tool_Crashlytics.h
//  Pods
//
//  Created by Kyungwoo Park on 2016. 7. 5..
//
//

#import <Foundation/Foundation.h>

@interface Tool_Crashlytics : NSObject

+ (void)initCrashlytics;
+ (void)crash;
+ (void)throwException;
+ (void)userIdentifiers:(NSString*)userIdentifiers email:(NSString*)email name:(NSString*)name;

@end
