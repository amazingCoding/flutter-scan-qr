//
//  SanYueAlertItem.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/11.
//

#import "SanYueBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SanYueAlertItem : SanYueBaseObject
@property(nonatomic,assign) BOOL showCancel;
@property(nonatomic,assign) BOOL backGroundCancel;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *confirmText;
@property(nonatomic,strong) NSString *cancelText;
@property(nonatomic,strong) NSString *cancelColor;
@property(nonatomic,strong) NSString *confirmColor;
@property(nonatomic,assign) int senseMode;
@property(nonatomic,strong) NSString *cancelColorDark;
@property(nonatomic,strong) NSString *confirmColorDark;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
