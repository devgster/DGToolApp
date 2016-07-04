//
//  Tool_App.h
//  May31_Noon
//
//  Created by Kyungwoo Park on 2016. 4. 23..
//  Copyright © 2016년 Kyungwoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool_App : NSObject

@end

@interface NSString (Size)
- (CGSize)sizewithfont:(UIFont*)font;
- (CGSize)sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size;
@end

@interface NSAttributedString (Size)
- (CGSize)sizeWithConstrainedToSize:(CGSize)size;
@end

@interface UIFont (Custom)
+ (UIFont *)sdGothicNeo_BoldSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)sdGothicNeo_SemiBoldSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)sdGothicNeo_LightSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)sdGothicNeo_RegularSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)sdGothicNeo_MediumSystemFontOfSize:(CGFloat)fontSize;
@end

@interface UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithHexString:(NSString *)hexString;
+ (UIImage *)imageWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
@end

@interface UIColor (HexColorAddition)
+ (UIColor *)hx_colorWithHexString:(NSString *)hexString;
+ (UIColor *)hx_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
@end

@interface NSString (hx_StringTansformer)
- (NSString *)hx_hexStringTransformFromThreeCharacters;
@end