#import "ScanQrPlugin.h"
#import "ScanViewController.h"
@interface ScanQrPlugin()<ScanViewControllerDelegate>
@property (nonatomic, strong)FlutterResult result;
@end
@implementation ScanQrPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"scan_qr"
            binaryMessenger:[registrar messenger]];
  ScanQrPlugin* instance = [[ScanQrPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"openScanQr" isEqualToString:call.method]) {
      NSString *color = [call.arguments objectForKey:@"color"];
      NSString *title = [call.arguments objectForKey:@"title"];
      NSString *content = [call.arguments objectForKey:@"content"];
      NSString *confirmText = [call.arguments objectForKey:@"confirmText"];
      NSString *cancelText = [call.arguments objectForKey:@"cancelText"];
      NSString *errQrText = [call.arguments objectForKey:@"errQrText"];
      
      FlutterViewController *flutterViewController = (FlutterViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
      UIViewController *viewController = flutterViewController.presentedViewController ? flutterViewController.presentedViewController : flutterViewController;
      ScanViewController *scanQRVc = [[ScanViewController alloc] init];
      scanQRVc.preVc = viewController;
      scanQRVc.mainColor = color;
      scanQRVc.confirmText = confirmText;
      scanQRVc.cancelText = cancelText;
      scanQRVc.errorTitle = title;
      scanQRVc.errorContent = content;
      scanQRVc.errQrText = errQrText;
      scanQRVc.modalPresentationStyle = UIModalPresentationFullScreen;
      scanQRVc.delegate = self;
      self.result = result;
      [viewController presentViewController:scanQRVc animated:YES completion:nil];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)getError:(nonnull NSString *)error {
    FlutterError *errorObj = [FlutterError errorWithCode:@"1" message:error details:nil];
    self.result(errorObj);
    self.result = nil;
}

- (void)getResult:(nonnull NSString *)result {
    self.result(result);
    self.result = nil;
}

@end
