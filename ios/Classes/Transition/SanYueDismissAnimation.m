//
//  HaoDanAppDismissAnimation.m
//  miniApp
//
//  Created by 宋航 on 2019/1/9.
//  Copyright © 2019 宋航. All rights reserved.
//

#import "SanYueDismissAnimation.h"

@implementation SanYueDismissAnimation
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35f;
}
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *contrainerView = [transitionContext containerView];
    [contrainerView addSubview:toVc.view];
    [contrainerView addSubview:fromVc.view];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVc.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, fromVc.view.frame.size.width, fromVc.view.frame.size.width);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
@end
