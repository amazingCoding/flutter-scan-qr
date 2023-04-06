//
//  HaoDanAppPanInteractiveTransition.h
//  miniApp
//
//  Created by 宋航 on 2019/1/9.
//  Copyright © 2019 宋航. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SanYuePanInteractiveTransitionDelegate <NSObject>
- (void)dismissCompletion;
@end
@interface SanYuePanInteractiveTransition : UIPercentDrivenInteractiveTransition
-(void)panToDismiss:(UIViewController<UIGestureRecognizerDelegate> *) viewController;
@property (nonatomic,weak) id <SanYuePanInteractiveTransitionDelegate> disMissdelegate;
@property (nonatomic, assign, readonly) BOOL isInteractive;
@end

NS_ASSUME_NONNULL_END
