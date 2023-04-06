//
//  SanYueAlertItem.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/11.
//

#import "SanYueAlertItem.h"

@implementation SanYueAlertItem
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _title = [self getStringByName:@"title" and:dict andDef:@"标题"];
        _content = [self getStringByName:@"content" and:dict andDef:@""];
        
        _confirmText = [self getStringByName:@"confirmText" and:dict andDef:@"确定"];
        _confirmColor = [self getStringByName:@"confirmColor" and:dict andDef:@"#353535"];
        
        _showCancel = [self getBoolByName:@"showCancel" and:dict];
        _backGroundCancel = [self getBoolByName:@"backGroundCancel" and:dict];
        
        NSString *senseMode = [self getStringByName:@"senseMode" and:dict andDef:@"auto"];
        if ([senseMode isEqualToString:@"light"]) { _senseMode = 1; }
        else if ([senseMode isEqualToString:@"dark"]) { _senseMode = 2; }
        else{ _senseMode = 0; }
        _confirmColorDark = [self getStringByName:@"confirmColorDark" and:dict andDef:@"#BBBBBB"];;
        
        if (_showCancel) {
            _cancelText = [self getStringByName:@"cancelText" and:dict andDef:@"取消"];
            _cancelColor = [self getStringByName:@"cancelColor" and:dict andDef:@"#e64340"];
            _cancelColorDark = [self getStringByName:@"cancelColorDark" and:dict andDef:@"#CD5C5C"];
        }
    }
    return self;
}
@end
