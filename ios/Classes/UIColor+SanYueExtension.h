//
//  UIColor+SanYueExtension.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/7.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (SanYueExtension)
+ (BOOL)isColorDeep:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorDynamicProviderWithHexString:(NSString *)color andDarkColor:(NSString *)darkColor;
+ (UIColor *)colorDynamicProviderWithHexString:(NSString *)color andDarkColor:(NSString *)darkColor widthMode:(NSString *)mode;
@end

NS_ASSUME_NONNULL_END
