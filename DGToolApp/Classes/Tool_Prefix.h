//
//  Header.h
//  Pods
//
//  Created by Kyungwoo Park on 2016. 7. 4..
//
//

#ifndef Header_h
#define Header_h

#endif /* Header_h */

#import "Tool_App.h"

#ifdef DEBUG
#define kIsDebug true
#else
#define kIsDebug false
#endif

#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define kScreenScale [UIScreen mainScreen].bounds.size.width/414.0

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#ifdef DEBUG
#define KKLogError(frmt, ...) NSLog((@"\n🚨***ERROR***🚨\n" frmt @"\n--------------------------------\n"), ##__VA_ARGS__)//에러 메시지
#define KKLogWarn(frmt, ...) NSLog((@"\n⚠️***WARNING***⚠️\n" frmt @"\n--------------------------------\n"), ##__VA_ARGS__)//경고 메시지
#define KKLogInfo(frmt, ...) NSLog((@"\n📢***INFOMATION***📢\n" frmt @"\n--------------------------------\n"), ##__VA_ARGS__)//협업자에게 전달 로그
#define KKLogDebug(frmt, ...) NSLog((@"\n🐛***DEBUG***🐛\n" frmt @"\n--------------------------------\n"), ##__VA_ARGS__)//디버깅시 사용!!
#else
#define KKLogError(frmt, ...)
#define KKLogWarn(frmt, ...)
#define KKLogInfo(frmt, ...)
#define KKLogDebug(frmt, ...)
#endif


#ifdef DEBUG
#define NSLog( s, ... ) NSLog( @"\nLine :: %d, %s in %@ ::: %@", __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog( s, ... )
#endif

#undef NSLocalizedString
#define NSLocalizedString(key,_comment) [DGLocalizationHandler localizedString:key  comment:_comment]
