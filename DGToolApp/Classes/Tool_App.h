//
//  Tool_App.h
//  May31_Noon
//
//  Created by Kyungwoo Park on 2016. 4. 23..
//  Copyright © 2016년 Kyungwoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool_Prefix.h"


@interface Tool_App : NSObject

+ (BOOL)cacheWithData:(NSData*)data name:(NSString*)name key:(NSString*)key;
+ (NSData*)loadCacheWithName:(NSString*)name key:(NSString*)key period:(NSInteger)period dateFlags:(NSCalendarUnit)dateFlags;
+ (NSData*)loadCacheWithName:(NSString*)name key:(NSString*)key;
+ (BOOL)removeUserCacheWithName:(NSString*)name;


+ (UIViewController *)rootViewController;
+ (void)hideKeyboard;
@end

@interface NSString (Size)
- (CGSize)sizeWithFont:(UIFont*)font;
- (CGSize)sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size;
@end

@interface NSAttributedString (Size)
- (CGSize)sizeWithConstrainedToSize:(CGSize)size;
@end

@interface NSAttributedString (HTML)
- (NSAttributedString *)attributedStringFromHTMLString:(NSString *)htmlString;
- (NSAttributedString *)attributedStringFromHTMLString:(NSString *)htmlString
                                             textColor:(UIColor*)textColor
                                              textFont:(UIFont*)textFont
                                         TextAlignment:(NSTextAlignment)textAlignment;
@end

@interface UIFont (Custom)
+ (UIFont *)appleSDGothicNeo_BoldSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appleSDGothicNeo_SemiBoldSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appleSDGothicNeo_LightSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appleSDGothicNeo_RegularSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)appleSDGothicNeo_MediumSystemFontOfSize:(CGFloat)fontSize;
@end

@interface UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithHexString:(NSString *)hexString;
+ (UIImage *)imageWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
- (UIColor *)averageColor;//이미지의 평균 색상
@end

@interface UIColor (HexColorAddition)
- (NSString*)hexString;
+ (UIColor *)hx_colorWithHexString:(NSString *)hexString;
+ (UIColor *)hx_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
@end

@interface NSString (hx_StringTansformer)
- (NSString *)hx_hexStringTransformFromThreeCharacters;
@end

@interface UITextField (ColorPlaceholder)
- (void)setPlaceholder:(NSString*)placeholder color:(UIColor*)color;
- (void)setPlaceholder:(NSString*)placeholder color:(UIColor*)color font:(UIFont*)font;
@end

@interface UIDevice (DeviceInfo)
+ (NSString *)platformString;
+ (NSString *)platformStringSimple;
+ (NSString *)country;
+ (NSString *)countryShort;
+ (NSString *)language;
+ (NSString *)languageShort;
+ (void)setDebugCountry:(NSString*)country;
+ (void)setDebugLanguage:(NSString*)language;
@end

@interface DGLocalizationHandler : NSObject
+ (NSString *)localizedString:(NSString *)key comment:(NSString *)comment;
@end

@interface ModalAppStore : NSObject
+ (void)linkToAppstoreWithUrlString:(NSString*)urlString
                              appId:(NSString*)appId;
+ (void)linkToAppstoreWithViewController:(UIViewController*)viewController
                               urlString:(NSString*)urlString
                                   appId:(NSString*)appId;
@end
