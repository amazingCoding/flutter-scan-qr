//
//  ScanViewController.h
//  QuickpeWallet
//
//  Created by 宋航 on 2022/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ScanViewControllerDelegate<NSObject>
-(void)getResult:(NSString *)result;
-(void)getError:(NSString *)error;
@end
@interface ScanViewController : UIViewController
@property (nonatomic,weak)id<ScanViewControllerDelegate>delegate;
@property(nonatomic,weak) UIViewController *preVc;
@property(nonatomic,strong) NSString *confirmText;
@property(nonatomic,strong) NSString *cancelText;
@property(nonatomic,strong) NSString *errorTitle;
@property(nonatomic,strong) NSString *errorContent;
@property(nonatomic,strong) NSString *mainColor;
@property(nonatomic,strong) NSString *errQrText;
@end

NS_ASSUME_NONNULL_END
