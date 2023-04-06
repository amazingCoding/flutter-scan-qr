//
//  SanYueModalController.h
//  AFNetworking
//
//  Created by 宋航 on 2020/3/19.
//

#import <UIKit/UIKit.h>
#import "SanYueBaseAlertController.h"
@class SanYueAlertItem;
NS_ASSUME_NONNULL_BEGIN

@interface SanYueModalController : SanYueBaseAlertController
-(instancetype)initWithItem:(SanYueAlertItem*)item andHandler:(void (^ __nullable)(int index))handler;
@end

NS_ASSUME_NONNULL_END
