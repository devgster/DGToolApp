//
//  Tool_App.m
//  May31_Noon
//
//  Created by Kyungwoo Park on 2016. 4. 23..
//  Copyright © 2016년 Kyungwoo. All rights reserved.
//

#import "Tool_App.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIDeviceIdentifier/UIDeviceHardware.h>
#import <StoreKit/StoreKit.h>
#import "NSData+AESAdditions.h"

@implementation Tool_App

+ (NSString*)cachePathWithFileName:(NSString*)fileName{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths firstObject] stringByAppendingPathComponent:fileName];
}

+ (BOOL)cacheWithData:(NSData*)data name:(NSString*)name key:(NSString*)key{
    NSError *error = nil;
    
    NSData *encryptedData = [data AES256EncryptWithKey:key];
    
    if (!error) {
        [encryptedData writeToFile:[self cachePathWithFileName:name] atomically:YES];
    } else {
        KKLogError(@"userCacheWithData Error :: %@", [error localizedDescription]);
        return false;
    }
    
    return true;
}

+ (NSData*)loadCacheWithName:(NSString*)name key:(NSString*)key period:(NSInteger)period dateFlags:(NSCalendarUnit)dateFlags{
    NSData *data = [NSData dataWithContentsOfFile:[self cachePathWithFileName:name]];
    
    
    if (data != nil) {
        
        NSError* error;
        NSDate *creationDate = [[NSFileManager defaultManager] attributesOfItemAtPath:[self cachePathWithFileName:name] error:&error].fileModificationDate;
        
        NSDate *now = [NSDate date];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comp = [cal components:dateFlags
                                        fromDate:creationDate
                                          toDate:now
                                         options:0];
        
        NSInteger value = 0;
        if (dateFlags == NSCalendarUnitMonth) {
            value = comp.month;
        }else if (dateFlags == NSCalendarUnitDay) {
            value = comp.day;
        }else if (dateFlags == NSCalendarUnitHour) {
            value = comp.hour;
        }else if (dateFlags == NSCalendarUnitMinute) {
            value = comp.minute;
        }else if (dateFlags == NSCalendarUnitSecond) {
            value = comp.second;
        }
        
        if (value > period) {
            return nil;
        }
        
        NSData *decriptedData = [data AES256DecryptWithKey:key];
        
        return decriptedData;
    }

    
    return nil;
}

+ (NSData*)loadCacheWithName:(NSString*)name key:(NSString*)key{
    NSData *data = [NSData dataWithContentsOfFile:[self cachePathWithFileName:name]];
    
    NSData *decriptedData = [data AES256DecryptWithKey:key];
    
    return decriptedData;
}

+ (BOOL)removeUserCacheWithName:(NSString*)name{
    return [[NSFileManager defaultManager] removeItemAtPath:[self cachePathWithFileName:name] error:nil];
}

#pragma mark - rootViewController;
+ (UIViewController *)rootViewController{
    return [self rootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)rootViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self rootViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self rootViewController:presentedViewController];
}

#pragma mark - hideKeyboard

+ (void)hideKeyboard
{
    UIWindow *tempWindow;
    
    for (int c = 0; c < [[[UIApplication sharedApplication] windows] count]; c++)
    {
        tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
        for (int i = 0; i < [tempWindow.subviews count]; i++)
        {
            [self hideKeyboardRecursion:[tempWindow.subviews objectAtIndex:i]];
        }
    }
}

+ (void)hideKeyboardRecursion:(UIView*)view
{
    if ([view conformsToProtocol:@protocol(UITextInputTraits)])
    {
        if ([view canResignFirstResponder]) {
            [view resignFirstResponder];
        }
        
    }
    if ([view.subviews count]>0)
    {
        for (int i = 0; i < [view.subviews count]; i++)
        {
            [self hideKeyboardRecursion:[view.subviews objectAtIndex:i]];
        }
    }
}

@end

@implementation NSString (Size)

- (CGSize)sizeWithFont:(UIFont*)font {
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

- (CGSize)sizeWithConstrainedToSize:(CGSize)size{
    CGRect textRect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         context:nil];
    return CGSizeMake(ceilf(textRect.size.width), ceilf(textRect.size.height));
}

@end

@implementation NSAttributedString (HTML)

- (NSAttributedString *)attributedStringFromHTMLString:(NSString *)htmlString{
    NSMutableAttributedString* htmlAttributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                      documentAttributes:nil error:nil];
    return htmlAttributedString;
}

- (NSAttributedString *)attributedStringFromHTMLString:(NSString *)htmlString textColor:(UIColor*)textColor textFont:(UIFont*)textFont TextAlignment:(NSTextAlignment)textAlignment{
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    
    if (textColor) {
        htmlString = [NSString stringWithFormat:@"<font color='%@' face='Helvetica'>%@</font>",[textColor hexString],htmlString];
    }
    
    NSMutableAttributedString* htmlAttributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                                       
                                                                                              options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                                   documentAttributes:nil
                                                                                                error:nil];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:textAlignment];
    [htmlAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, htmlAttributedString.length)];
    if (textFont) {
        [htmlAttributedString addAttribute:NSFontAttributeName value:textFont range:NSMakeRange(0, htmlAttributedString.length)];
    }
    
    return htmlAttributedString;
    
}

@end

@implementation UIFont (Custom)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (UIFont *)appleSDGothicNeo_BoldSystemFontOfSize:(CGFloat)fontSize {//볼드체
    return [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:fontSize];
}

+ (UIFont *)appleSDGothicNeo_SemiBoldSystemFontOfSize:(CGFloat)fontSize {//세미볼드체
    return [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:fontSize];
}

+ (UIFont *)appleSDGothicNeo_LightSystemFontOfSize:(CGFloat)fontSize {//옅은체
    return [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:fontSize];
}

+ (UIFont *)appleSDGothicNeo_RegularSystemFontOfSize:(CGFloat)fontSize {//일반체
    return [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:fontSize];
}

+ (UIFont *)appleSDGothicNeo_MediumSystemFontOfSize:(CGFloat)fontSize {//중간체
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
    return [self imageWithHexString:hexString alpha:1.0];
}

+ (UIImage *)imageWithHexString:(NSString *)hexString alpha:(CGFloat)alpha{
    
    UIColor *color = [UIColor hx_colorWithHexString:hexString alpha:alpha];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIColor *)averageColor{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                           green:((CGFloat)rgba[1])/255.0
                            blue:((CGFloat)rgba[2])/255.0
                           alpha:((CGFloat)rgba[3])/255.0];
}

@end

@implementation UIColor (HexColorAddition)

- (NSString*)hexString{
    CGColorSpaceModel colorSpace = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r, g, b, a;
    
    if (colorSpace == kCGColorSpaceModelMonochrome) {
        r = components[0];
        g = components[0];
        b = components[0];
        a = components[1];
    }
    else if (colorSpace == kCGColorSpaceModelRGB) {
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255),
            lroundf(a * 255)];
}

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

@implementation UIScrollView (DGTool)

- (int)currentPage{
    CGFloat pageWidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    return page;
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


@implementation UITextField (ColorPlaceholder)

- (void)setPlaceholder:(NSString*)placeholder color:(UIColor*)color{
    [self setPlaceholder:placeholder color:color font:self.font];
}

- (void)setPlaceholder:(NSString*)placeholder color:(UIColor*)color font:(UIFont*)font{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                 attributes:@{ NSForegroundColorAttributeName : color ,
                                                                               NSFontAttributeName : font}];
}

@end

@implementation UIDevice (DeviceInfo)

static NSString *sDebugLanguage = nil;
static NSString *sDbugCountry = nil;
static NSString *shotLanguage = nil;

+ (NSString *) platformString{
    return [UIDeviceHardware platformString];
}
+ (NSString *) platformStringSimple{
    return [UIDeviceHardware platformStringSimple];
}

+ (NSString *)country{
    if (sDbugCountry != nil) {
        return sDbugCountry;
    }
    NSString *deviceCountryISO = nil;
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    deviceCountryISO =  [[carrier isoCountryCode] uppercaseString];
    if (deviceCountryISO == nil) {
        deviceCountryISO = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    }
    return deviceCountryISO;
}

+ (NSString *)countryShort{
    NSString *deviceCountryISO = [self country];
    if (deviceCountryISO.length > 2) {
        deviceCountryISO = [deviceCountryISO substringToIndex:2];
    }
    return deviceCountryISO;
}

+ (NSString*)language{
    if (sDebugLanguage != nil) {
        return sDebugLanguage;
    }
    NSString *deviceLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    return deviceLanguage;
}

+ (NSString*)languageShort{
    if (shotLanguage == nil) {
        NSString *deviceLanguage = [self language];
        NSArray *cutLanguage = [deviceLanguage componentsSeparatedByString:@"-"];
        if(cutLanguage.count > 1){
            deviceLanguage = cutLanguage[0];
        }
        shotLanguage = [[NSString alloc] initWithString:deviceLanguage];
    }
    return shotLanguage;
}

+ (void)setDebugCountry:(NSString*)country{
    sDbugCountry = country;
}

+ (void)setDebugLanguage:(NSString*)language{
    shotLanguage = nil;
    sDebugLanguage = language;
}

@end

@implementation DGLocalizationHandler

+ (NSString *)localizedString:(NSString *)key comment:(NSString *)comment{
    NSString * localizedString = [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:nil];

    NSString *language = [[NSLocale preferredLanguages] firstObject];
    
    if (sDebugLanguage != nil) {
        localizedString = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[UIDevice language] ofType:@"lproj"]]
                           localizedStringForKey:key
                           value:@""
                           table:nil];
    }
    
    if ([language isEqualToString:@"en"] == false && [localizedString isEqualToString:key] == true) {
        localizedString = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"]]
                           localizedStringForKey:key
                           value:@""
                           table:nil];
    }
    
    if (localizedString == nil) {
        localizedString = key;
    }
    
    if ([localizedString isEqualToString:key]) {
        KKLogWarn(@"## NSLocalizedString NULL Error :: KEY >> '%@'",key);
    }
    
    localizedString = [localizedString stringByReplacingOccurrencesOfString:@"%s" withString:@"%@"];
    
    return localizedString;
    
}

@end


@implementation ModalAppStore

static ModalAppStore *sModalAppStore = nil;

+ (void)linkToAppstoreWithUrlString:(NSString*)urlString appId:(NSString*)appId{
    [self linkToAppstoreWithViewController:nil urlString:urlString appId:appId];
}

+ (void)linkToAppstoreWithViewController:(UIViewController*)viewController urlString:(NSString*)urlString appId:(NSString*)appId{
    if (sModalAppStore == nil) {
        sModalAppStore = [[ModalAppStore alloc] init];
    }
    [sModalAppStore linkToAppstoreWithViewController:viewController urlString:urlString appId:appId];
}

- (void)linkToAppstoreWithViewController:(UIViewController*)viewController urlString:(NSString*)urlString appId:(NSString*)appId{
    
    if(NSClassFromString(@"SKStoreProductViewController")) {
        
        SKStoreProductViewController *storeController = [[SKStoreProductViewController alloc] init];
        storeController.delegate = self;
        
        NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : appId };
        
        [storeController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                if (viewController) {
                    [viewController presentViewController:storeController animated:YES completion:nil];
                }else{
                    [[Tool_App rootViewController] presentViewController:storeController animated:YES completion:nil];
                }
                
            } else {
                [[[UIAlertView alloc] initWithTitle:@"오류발생"
                                            message:@"앱스토어 링크를 여는데 오류가 발생하였습니다."
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles: nil] show];
            }
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

#pragma mark SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^{
        if (sModalAppStore) {
            sModalAppStore = nil;
        }
    }];
}

@end

