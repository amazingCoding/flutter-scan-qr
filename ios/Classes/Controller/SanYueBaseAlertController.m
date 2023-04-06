//
//  SanYueBaseAlertController.m
//  AFNetworking
//
//  Created by 宋航 on 2020/3/19.
//

#import "SanYueBaseAlertController.h"
#import "SanYueAlertAnimation.h"

@interface SanYueBaseAlertController ()<UIViewControllerTransitioningDelegate>
@end

@implementation SanYueBaseAlertController
- (void)dealloc{
    _showAnimation = nil;
    _hideAnimation = nil;
}
- (void)viewDidLoad{
    self.transitioningDelegate = self;
    if (@available(iOS 13.0, *)) {
        if (_senseMode == 2) { [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark]; }
        else if (_senseMode == 1) { [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];}
    }
}
-(void)show:(NSTimeInterval)duration andCompletion:(void (^ __nullable)(BOOL finished))completion{}
-(void)dismiss:(NSTimeInterval)duration andCompletion:(void (^ __nullable)(BOOL finished))completion{}
# pragma mark - 懒加载属性
- (SanYueAlertAnimation *)showAnimation{
    if (_showAnimation == nil) { _showAnimation = [[SanYueAlertAnimation alloc] init]; }
    return _showAnimation;
}
- (SanYueAlertAnimation *)hideAnimation{
    if (_hideAnimation == nil) { _hideAnimation = [[SanYueAlertAnimation alloc] init]; }
    return _hideAnimation;
}
# pragma mark - UIViewControllerTransitioningDelegate代理事件
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.showAnimation;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self.hideAnimation;
}
@end
