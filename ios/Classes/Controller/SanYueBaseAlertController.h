//
//  SanYueBaseAlertController.h
//  AFNetworking
//
//  Created by 宋航 on 2020/3/19.
//

#import <UIKit/UIKit.h>
@class SanYueAlertAnimation;
NS_ASSUME_NONNULL_BEGIN

@interface SanYueBaseAlertController : UIViewController
@property (nonatomic,assign)int senseMode;
-(void)show:(NSTimeInterval)duration andCompletion:(void (^ __nullable)(BOOL finished))completion;
-(void)dismiss:(NSTimeInterval)duration andCompletion:(void (^ __nullable)(BOOL finished))completion;
@property (nonatomic,strong)SanYueAlertAnimation *showAnimation;
@property (nonatomic,strong)SanYueAlertAnimation *hideAnimation;
@end

NS_ASSUME_NONNULL_END
