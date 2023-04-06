//
//  SanYueBaseObject.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/11.
//

#import "SanYueBaseObject.h"

@implementation SanYueBaseObject
-(BOOL)getBoolByName:(NSString *)name and:(NSDictionary *)dict{
    return [self getIntByName:name and:dict andDef:0] != 0;
}
-(int)getIntByName:(NSString *)name and:(NSDictionary *)dict andDef:(int) def{
    if([dict[name] isEqual:[NSNull null]] || dict[name] == nil ){ return def; }
    else{ return [dict[name] intValue]; }
}
-(CGFloat)getFloatByName:(NSString *)name and:(NSDictionary *)dict andDef:(CGFloat) def{
    if([dict[name] isEqual:[NSNull null]] || dict[name] == nil ){ return def; }
    else{ return [dict[name] floatValue]; }
}
-(NSString *)getStringByName:(NSString *)name and:(NSDictionary *)dict andDef:(nullable NSString *)def{
    if([dict[name] isEqual:[NSNull null]] || dict[name] == nil ){ return def; }
    else{ return [NSString stringWithFormat:@"%@",dict[name]]; }
}
-(NSArray<NSString *> *)getArrayByName:(NSString *)name and:(NSDictionary *)dict andDef:(nullable NSArray<NSString *> *)def{
    if([dict[name] isEqual:[NSNull null]] || dict[name] == nil ){ return def; }
    else{ return dict[name]; }
}
-(NSArray<NSNumber *> *)getNumberArrayByName:(NSString *)name and:(NSDictionary *)dict andDef:(nullable NSArray<NSNumber *> *)def{
    if([dict[name] isEqual:[NSNull null]] || dict[name] == nil ){ return def; }
    else{ return dict[name];}
}
@end
