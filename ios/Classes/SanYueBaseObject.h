//
//  SanYueBaseObject.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SanYueBaseObject : NSObject
-(BOOL)getBoolByName:(NSString *)name and:(NSDictionary *)dict;
-(int)getIntByName:(NSString *)name and:(NSDictionary *)dict andDef:(int) def;
-(CGFloat)getFloatByName:(NSString *)name and:(NSDictionary *)dict andDef:(CGFloat) def;
-(NSString *)getStringByName:(NSString *)name and:(NSDictionary *)dict andDef:(nullable NSString *)def;
-(NSArray<NSString *> *)getArrayByName:(NSString *)name and:(NSDictionary *)dict andDef:(nullable NSArray<NSString *> *)def;
-(NSArray<NSNumber *> *)getNumberArrayByName:(NSString *)name and:(NSDictionary *)dict andDef:(nullable NSArray<NSNumber *> *)def;
@end

NS_ASSUME_NONNULL_END
