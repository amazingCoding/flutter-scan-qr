//
//  SanYuePickerHideAnimation.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/2/16.
//

#import "SanYueAlertAnimation.h"
#import "SanYueBaseAlertController.h"

@implementation SanYueAlertAnimation

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *contrainerView = [transitionContext containerView];
    
    if ([fromVc isKindOfClass:[SanYueBaseAlertController class]]) {
        [contrainerView addSubview:fromVc.view];
        SanYueBaseAlertController *vc = (SanYueBaseAlertController *)fromVc;
        [vc dismiss:[self transitionDuration:transitionContext] andCompletion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
    else if ([toVc isKindOfClass:[SanYueBaseAlertController class]]) {
        [contrainerView addSubview:toVc.view];
        SanYueBaseAlertController *vc = (SanYueBaseAlertController *)toVc;
        [vc show:[self transitionDuration:transitionContext] andCompletion:^(BOOL finished) {
           [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}

@end
