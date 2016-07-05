//
//  Tool_GAnalytics.h
//  May31_Noon
//
//  Created by KyungwooPark on 2016. 4. 24..
//  Copyright © 2016년 Kyungwoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool_GAnalytics : NSObject
+ (void)initTrackerWithTrackingId:(NSString*)pTrackingId;
+ (void)gaSendView:(NSString*)pAppScreenName;
+ (void)gaSendEvent:(NSString*)category Action:(NSString*)action Label:(NSString*)label Value:(long)value;
@end
