//
//  UIColor+SanYueExtension.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/7.
//

#import "UIColor+SanYueExtension.h"


@implementation UIColor (SanYueExtension)
+ (BOOL)isColorDeep:(NSString *)stringToConvert{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return NO;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return NO;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    if(r*0.299 + g*0.578 + b*0.114 >= 192){
        return NO;
    }
    return YES;
}
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return UIColor.whiteColor;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return UIColor.whiteColor;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //SANLog(@"%u %u %u",r,g,b);
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorDynamicProviderWithHexString:(NSString *)colorStr andDarkColor:(NSString *)darkColorStr{
    UIColor *color;
    if (@available(iOS 13.0, *)) {
        color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor colorWithHexString:darkColorStr];
            }
            else{
                return [UIColor colorWithHexString:colorStr];
            }
        }];
    } else {
        color = [UIColor colorWithHexString:colorStr];
    }
    return color;
}
+ (UIColor *)colorDynamicProviderWithHexString:(NSString *)color andDarkColor:(NSString *)darkColor widthMode:(NSString *)mode{
    if ([mode isEqualToString:@"dark"]) {
        return [UIColor colorWithHexString:darkColor];
    }
    else if ([mode isEqualToString:@"light"]) {
        return [UIColor colorWithHexString:color];
    }
    else{
        return [UIColor colorDynamicProviderWithHexString:color andDarkColor:darkColor];
    }
}
@end
