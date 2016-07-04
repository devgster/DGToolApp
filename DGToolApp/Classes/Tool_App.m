//
//  Tool_App.m
//  May31_Noon
//
//  Created by Kyungwoo Park on 2016. 4. 23..
//  Copyright © 2016년 Kyungwoo. All rights reserved.
//

#import "Tool_App.h"

@implementation Tool_App

@end

@implementation NSString (Size)

- (CGSize)sizewithfont:(UIFont*)font {
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName: font}];
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGSize)sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size{
    CGRect textRect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName: font}
                                         context:nil];
    return CGSizeMake(ceilf(textRect.size.width), ceilf(textRect.size.height));
}
@end

@implementation NSAttributedString (Size)

- (CGSize)size{
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return CGSizeMake(ceilf(textRect.size.width), ceilf(textRect.size.height));
}

- (CGSize)sizeWithConstrainedToSize:(CGSize)size{
    CGRect textRect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return CGSizeMake(ceilf(textRect.size.width), ceilf(textRect.size.height));
}

@end

@implementation UIFont (Custom)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (UIFont *)sdGothicNeo_BoldSystemFontOfSize:(CGFloat)fontSize {//볼드체
    return [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:fontSize];
}

+ (UIFont *)sdGothicNeo_SemiBoldSystemFontOfSize:(CGFloat)fontSize {//세미볼드체
    return [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:fontSize];
}

+ (UIFont *)sdGothicNeo_LightSystemFontOfSize:(CGFloat)fontSize {//옅은체
    return [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:fontSize];
}

+ (UIFont *)sdGothicNeo_RegularSystemFontOfSize:(CGFloat)fontSize {//일반체
    return [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:fontSize];
}

+ (UIFont *)sdGothicNeo_MediumSystemFontOfSize:(CGFloat)fontSize {//중간체
    return [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:fontSize];
}



//+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
//    return [UIFont fontWithName:@"NotoSans-Bold" size:fontSize];
//}
//
//+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
//    return [UIFont fontWithName:@"NotoSans" size:fontSize];
//}

#pragma clang diagnostic pop

@end

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithHexString:(NSString *)hexString {
    
    UIColor *color = [UIColor hx_colorWithHexString:hexString];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation UIColor (HexColorAddition)
+ (UIColor *)hx_colorWithHexString:(NSString *)hexString{
    return [[self class] hx_colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)hx_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    // We found an empty string, we are returning nothing
    if (hexString.length == 0) {
        return nil;
    }
    
    // Check for hash and add the missing hash
    if('#' != [hexString characterAtIndex:0]) {
        hexString = [NSString stringWithFormat:@"#%@", hexString];
    }
    
    // returning no object on wrong alpha values
    NSArray *validHexStringLengths = @[@4, @5, @7, @9];
    NSNumber *hexStringLengthNumber = [NSNumber numberWithUnsignedInteger:hexString.length];
    if ([validHexStringLengths indexOfObject:hexStringLengthNumber] == NSNotFound) {
        return nil;
    }
    
    // if the hex string is 5 or 9 we are ignoring the alpha value and we are using the value from the hex string instead
    CGFloat handedInAlpha = alpha;
    if (5 == hexString.length || 9 == hexString.length) {
        NSString * alphaHex = [hexString substringWithRange:NSMakeRange(1, 9 == hexString.length ? 2 : 1)];
        if (1 == alphaHex.length) alphaHex = [NSString stringWithFormat:@"%@%@", alphaHex, alphaHex];
        hexString = [NSString stringWithFormat:@"#%@", [hexString substringFromIndex:9 == hexString.length ? 3 : 2]];
        unsigned alpha_u = [[self class] hx_hexValueToUnsigned:alphaHex];
        handedInAlpha = ((CGFloat) alpha_u) / 255.0;
    }
    
    // check for 3 character HexStrings
    hexString = [hexString hx_hexStringTransformFromThreeCharacters];
    
    NSString *redHex    = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(1, 2)]];
    unsigned redInt = [[self class] hx_hexValueToUnsigned:redHex];
    
    NSString *greenHex  = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(3, 2)]];
    unsigned greenInt = [[self class] hx_hexValueToUnsigned:greenHex];
    
    NSString *blueHex   = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(5, 2)]];
    unsigned blueInt = [[self class] hx_hexValueToUnsigned:blueHex];
    
    UIColor *color = [UIColor hx_colorWith8BitRed:redInt green:greenInt blue:blueInt alpha:handedInAlpha];
    
    return color;
}


+ (UIColor *)hx_colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [[self class] hx_colorWith8BitRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)hx_colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha
{
    UIColor *color = nil;
#if (TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE)
    color = [UIColor colorWithRed:(float)red/255 green:(float)green/255 blue:(float)blue/255 alpha:alpha];
#else
    color = [UIColor colorWithCalibratedRed:(float)red/255 green:(float)green/255 blue:(float)blue/255 alpha:alpha];
#endif
    
    return color;
}

+ (unsigned)hx_hexValueToUnsigned:(NSString *)hexValue
{
    unsigned value = 0;
    
    NSScanner *hexValueScanner = [NSScanner scannerWithString:hexValue];
    [hexValueScanner scanHexInt:&value];
    
    return value;
}

@end

@implementation NSString (hx_StringTansformer)

- (NSString *)hx_hexStringTransformFromThreeCharacters;
{
    if(self.length == 4)
    {
        NSString * hexString = [NSString stringWithFormat:@"#%1$c%1$c%2$c%2$c%3$c%3$c",
                                [self characterAtIndex:1],
                                [self characterAtIndex:2],
                                [self characterAtIndex:3]];
        return hexString;
    }
    
    return self;
}

@end

