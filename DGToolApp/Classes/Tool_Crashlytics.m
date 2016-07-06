//
//  Tool_Crashlytics.m
//  Pods
//
//  Created by Kyungwoo Park on 2016. 7. 5..
//
//

#import "Tool_Crashlytics.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation Tool_Crashlytics

+ (void)initCrashlytics{
    [Fabric with:@[[Crashlytics class]]];
}

+ (void)crash{
    [CrashlyticsKit crash];
}

+ (void)throwException{
    [CrashlyticsKit throwException];
}

+ (void)userIdentifiers:(NSString*)userIdentifiers email:(NSString*)email name:(NSString*)name{
    if (userIdentifiers) {
        [CrashlyticsKit setUserIdentifier:userIdentifiers];
    }
    if (email) {
        [CrashlyticsKit setUserEmail:email];
    }
    if (name) {
        [CrashlyticsKit setUserName:name];
    }
}

@end
