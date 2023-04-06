//
//  HaoDanAppPanInteractiveTransition.m
//  miniApp
//
//  Created by 宋航 on 2019/1/9.
//  Copyright © 2019 宋航. All rights reserved.
//

#import "SanYuePanInteractiveTransition.h"
@interface SanYuePanInteractiveTransition()
@property (nonatomic,weak)UIViewController *presentVc;
@property (nonatomic,assign)CGFloat startTime;
@property (nonatomic, assign, readwrite) BOOL isInteractive;
@end
@implementation SanYuePanInteractiveTransition
-(void)panToDismiss:(UIViewController<UIGestureRecognizerDelegate> *)viewController{
    _presentVc = viewController;
    _isInteractive = NO;
    // 给这个 vc 添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
//    pan.edges = UIRectEdgeLeft;
    pan.delegate = viewController;
    [viewController.view addGestureRecognizer:pan];
}
-(CGFloat)getNowTs{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    return time;
}
-(void)panGestureAction:(UIPanGestureRecognizer *)pan{
    CGPoint transition = [pan translationInView:_presentVc.view];
    CGFloat persent = MIN(1.0, transition.x/[UIScreen mainScreen].bounds.size.width);
    self.isInteractive = YES;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            _startTime = [self getNowTs];
            __weak typeof(self) weakSelf = self;
            [_presentVc dismissViewControllerAnimated:YES completion:^{
                [weakSelf.disMissdelegate dismissCompletion];
            }];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            [self updateInteractiveTransition:persent];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            CGFloat overTime = [self getNowTs];
            CGFloat speed = [UIScreen mainScreen].bounds.size.width * persent / (overTime - _startTime);
            if (persent >= 0.5 || speed > 1.2) {
                [self finishInteractiveTransition];
            }
            else{
                [self cancelInteractiveTransition];
            }
            self.isInteractive = NO;
            break;
        }
        case UIGestureRecognizerStatePossible: {
            break;
        }
        case UIGestureRecognizerStateFailed: {
            break;
        }
        default:
            break;
    }
}
@end
