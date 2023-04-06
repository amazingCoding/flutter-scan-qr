//
//  ScanViewController.m
//  QuickpeWallet
//
//  Created by 宋航 on 2022/3/14.
//

#import "ScanViewController.h"
#import "SanYueDismissAnimation.h"
#import "SanYuePanInteractiveTransition.h"
#import "SanYueModalController.h"
#import "SanYueAlertItem.h"
#import <AVFoundation/AVFoundation.h>
#import "UIColor+SanYueExtension.h"
#include <sys/sysctl.h>
#import <PhotosUI/PhotosUI.h>
@interface ScanViewController ()<UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate,AVCaptureMetadataOutputObjectsDelegate,PHPickerViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)SanYuePanInteractiveTransition *panInteractiveTransition;
@property (nonatomic,strong)SanYueDismissAnimation *dismissAnimation;
@property (nonatomic,strong)AVCaptureDevice *device; //AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic,strong)AVCaptureDeviceInput *input;//当启动摄像头开始捕获输入
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
@property (nonatomic,strong)AVCaptureSession *session;//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;//图像预览层，实时显示捕获的图像
@property(nonatomic,assign)BOOL hasCheckAuth;
@property(nonatomic,assign)BOOL isSuccess;
@property(nonatomic,weak)UIView *videoView;
@property(nonatomic,weak)UIView *lineView;
@property(nonatomic,weak)UIView *errQRview;

@property (nonatomic, strong) UIImpactFeedbackGenerator *impactLight;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    self.transitioningDelegate = self;
    [self.panInteractiveTransition panToDismiss:self];
    [self setView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (BOOL)prefersStatusBarHidden{
    return NO;
}
-(void)applicationDidBecomeActive{
    if(self.lineView){
        [self lineStop];
        [self lineStart];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    if(!_hasCheckAuth){
        [self checkAuthStatus];
    }
    [super viewDidAppear:animated];
}
-(void)setView{
    UIColor *mainColor = [UIColor colorWithHexString:self.mainColor];
    // 相机
    UIView *videoView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:videoView];
    _videoView = videoView;
    int SANScreenH =  [UIScreen mainScreen].bounds.size.height;
    int SANScreenW = [UIScreen mainScreen].bounds.size.width;
    // 扫码边框
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SANScreenW, (SANScreenH - 200) * 0.5 )];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(topView.frame) + 200, SANScreenW, (SANScreenH - 200) * 0.5 )];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), (SANScreenW - 200) * 0.5, 200)];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) + 200, CGRectGetMaxY(topView.frame), (SANScreenW - 200) * 0.5, 200)];
    topView.backgroundColor = UIColor.blackColor;
    bottomView.backgroundColor = UIColor.blackColor;
    rightView.backgroundColor = UIColor.blackColor;
    leftView.backgroundColor = UIColor.blackColor;
    bottomView.alpha = 0.6;
    topView.alpha = 0.6;
    rightView.alpha = 0.6;
    leftView.alpha = 0.6;
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    [self.view addSubview:leftView];
    [self.view addSubview:rightView];
    UIView *topLeftView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), leftView.frame.origin.y, 40, 4)];
    UIView *topRightView = [[UIView alloc] initWithFrame:CGRectMake(rightView.frame.origin.x - 40, leftView.frame.origin.y, 40, 4)];
    UIView *bottomLeftView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), bottomView.frame.origin.y - 4, 40, 4)];
    UIView *bottomRightView = [[UIView alloc] initWithFrame:CGRectMake(rightView.frame.origin.x - 40, bottomView.frame.origin.y - 4, 40, 4)];
    UIView *leftTopView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), leftView.frame.origin.y, 4, 40)];
    UIView *rightTopView = [[UIView alloc] initWithFrame:CGRectMake(rightView.frame.origin.x - 4, leftView.frame.origin.y, 4, 40)];
    UIView *leftBottomView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), bottomView.frame.origin.y - 40, 4, 40)];
    UIView *rightBottomView = [[UIView alloc] initWithFrame:CGRectMake(rightView.frame.origin.x - 4, bottomView.frame.origin.y - 40, 4, 40)];
    topLeftView.backgroundColor = mainColor;
    topRightView.backgroundColor = mainColor;
    bottomLeftView.backgroundColor = mainColor;
    bottomRightView.backgroundColor = mainColor;
    leftTopView.backgroundColor = mainColor;
    rightTopView.backgroundColor = mainColor;
    leftBottomView.backgroundColor = mainColor;
    rightBottomView.backgroundColor = mainColor;
    [self.view addSubview:topLeftView];
    [self.view addSubview:topRightView];
    [self.view addSubview:bottomLeftView];
    [self.view addSubview:bottomRightView];
    [self.view addSubview:leftTopView];
    [self.view addSubview:rightTopView];
    [self.view addSubview:leftBottomView];
    [self.view addSubview:rightBottomView];
    // 扫码动画
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((SANScreenW - 170) * 0.5, leftView.frame.origin.y + 4, 170, 4)];
    line.alpha = 0.8;
    line.backgroundColor = mainColor;
    _lineView = line;
    [self.view addSubview:line];
    // close btn
    int SANStatusH = SANScreenH >= 812 ? 44 : 20;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20 + SANStatusH, 36, 36)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
    [imageView setImage:[UIImage imageNamed:@"close" inBundle:[self getBundle:self.classForCoder] compatibleWithTraitCollection:nil]];
    btn.backgroundColor = UIColor.whiteColor;
    btn.layer.cornerRadius = 18;
    [btn addSubview:imageView];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(backBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    // add image button
    UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake((SANScreenW - 50) * 0.5, bottomView.frame.origin.y + 40, 50, 50)];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    [imageView2 setImage:[UIImage imageNamed:@"images" inBundle:[self getBundle:self.classForCoder] compatibleWithTraitCollection:nil]];
    imageBtn.backgroundColor = UIColor.whiteColor;
    imageBtn.layer.cornerRadius = 25;
    [imageBtn addSubview:imageView2];
    [self.view addSubview:imageBtn];
    [imageBtn addTarget:self action:@selector(imageBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    // 错误提示
    // 创建 UIView
    UIView *errQRview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    errQRview.layer.cornerRadius = 18;
    errQRview.backgroundColor = UIColor.whiteColor;
    
    // 创建 UILabel
    UILabel *QRLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    QRLabel.text = self.errQrText;
    QRLabel.font = [UIFont systemFontOfSize:12];
    QRLabel.backgroundColor = [UIColor whiteColor];
    QRLabel.textColor = [UIColor blackColor];
    QRLabel.numberOfLines = 0; // 设置为 0 表示自动换行
    
    // 计算 UILabel 的大小并设置 frame
    CGSize maxSize = CGSizeMake(errQRview.bounds.size.width - 2 * 10, CGFLOAT_MAX);
    CGSize labelSize = [QRLabel sizeThatFits:maxSize];
    QRLabel.alpha = 0.54;
    QRLabel.frame = CGRectMake(10, 10, labelSize.width, labelSize.height);
    errQRview.frame = CGRectMake((SANScreenW - (CGRectGetWidth(QRLabel.frame)+ 20)) * 0.5, CGRectGetMaxY(imageBtn.frame) + 20, labelSize.width + 20, labelSize.height + 20);
    // 将 UILabel 添加到 UIView 上
    [errQRview addSubview:QRLabel];
    [self.view addSubview:errQRview];
    errQRview.alpha = 0;
    self.errQRview = errQRview;
    
}
-(void)showErrorView{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.errQRview.alpha = 1.0;
        [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.errQRview.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    });
}
-(NSBundle *)getBundle:(Class)aClass{
    NSBundle *bundle = [NSBundle bundleForClass:self.classForCoder];
    NSURL *bundleURL = [[bundle resourceURL] URLByAppendingPathComponent:@"LightWebCore.bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    return resourceBundle;
}
-(void)backBtnEvent{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imageBtnEvent{
    //拉起相册
    if (@available(iOS 14, *)) {
        PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
        configuration.preferredAssetRepresentationMode = PHPickerConfigurationAssetRepresentationModeCurrent;
        configuration.filter = [PHPickerFilter imagesFilter];
        PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:configuration];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        // iOS 11 之后不需要再请求权限，而APP 支持12，所以不请求权限了。
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
    
}
- (BOOL)isRunningOnSimulator {
    NSString *simulatorModelIdentifier = @"x86_64";
    NSString *modelIdentifier = [self getDeviceModelIdentifier];
    if ([modelIdentifier isEqualToString:simulatorModelIdentifier]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)getDeviceModelIdentifier {
    size_t size = 0;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *modelIdentifier = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return modelIdentifier;
}
-(void)checkAuthStatus{
    _hasCheckAuth = YES;
    if([self isRunningOnSimulator]){
        return;
    }
    // 判断权限
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        SanYueAlertItem *item = [[SanYueAlertItem alloc] initWithDict:@{
            @"senseMode":@1,
            @"title":self.errorTitle,
            @"content":self.errorContent,
            @"confirmText":self.confirmText,
            @"cancelText":self.cancelText,
            @"showCancel":@1,
        }];
        
        SanYueModalController *vc = [[SanYueModalController alloc] initWithItem:item andHandler:^(int index) {
            if(index != 0){
                [self.lineView.layer removeAllAnimations];
                NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Privacy&path=CAMERA"];
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
            [self backBtnEvent];
            [self.preVc dismissViewControllerAnimated:YES completion:nil];
        }];
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    else{
        // 相机可以用，设置 UI
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
        
        self.output = [[AVCaptureMetadataOutput alloc]init];
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        self.session = [[AVCaptureSession alloc]init];
        
        if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        }
        
        if ([self.session canAddInput:self.input]) {
            [self.session addInput:self.input];
        }
        
        if ([self.session canAddOutput:self.output]) {
            [self.session addOutput:self.output];
            self.output.metadataObjectTypes= @[AVMetadataObjectTypeQRCode];
        }
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
        
        self.previewLayer.frame = self.view.bounds;
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_videoView.layer addSublayer:self.previewLayer];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 在此处执行后台任务
            // 可以通过 dispatch_sync 将结果返回给主线程
            [self.session startRunning];
        });
        [self lineStart];
    }
}
-(void)lineStart{
    int SANScreenH =  [UIScreen mainScreen].bounds.size.height;
    int SANScreenW = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        self.lineView.frame = CGRectMake((SANScreenW - 170) * 0.5,(SANScreenH - 200) * 0.5 + 200 - 8, 170, 4);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)lineStop{
    int SANScreenH =  [UIScreen mainScreen].bounds.size.height;
    int SANScreenW = [UIScreen mainScreen].bounds.size.width;
    self.lineView.frame = CGRectMake((SANScreenW - 170) * 0.5,(SANScreenH - 200) * 0.5 + 4, 170, 4);
}
#pragma mark -- 懒加载
- (SanYuePanInteractiveTransition *)panInteractiveTransition{
    if(!_panInteractiveTransition) _panInteractiveTransition = [[SanYuePanInteractiveTransition alloc] init];
    return _panInteractiveTransition;
}
- (SanYueDismissAnimation *)dismissAnimation{
    if(!_dismissAnimation) _dismissAnimation = [[SanYueDismissAnimation alloc] init];
    return _dismissAnimation;
}
-(UIImpactFeedbackGenerator *)impactLight API_AVAILABLE(ios(10.0)){
    if (!_impactLight) {
        UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium];
        _impactLight = impactLight;
        [_impactLight prepare];
    }
    return _impactLight;
}
#pragma mark -- 进入退出的过渡动画
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context){
        UIView *view = [context viewForKey:UITransitionContextFromViewKey];
        view.alpha = 0.5;
        view.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.delegate && !self.isSuccess) {
        [self.delegate getError:@"User cancelled scan"];
    }
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context){
        UIView *view = [context viewForKey:UITransitionContextToViewKey];
        view.alpha = 1;
        view.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
}

#pragma mark - UIViewControllerTransitioningDelegate
-(id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissAnimation;
}
-(id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.panInteractiveTransition.isInteractive ? self.panInteractiveTransition : nil;
}
- (void)dealloc{
    _panInteractiveTransition = nil;
    _dismissAnimation = nil;
    _session = nil;
    _device = nil;
    _input = nil;
    _output = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
-(void)getResult:(NSString *)res{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isSuccess = true;
        [self.impactLight impactOccurred];
        [self.session stopRunning];
        [self.lineView.layer removeAllAnimations];
        if(self.delegate){
            [self.delegate getResult:res];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        NSString *data = metadataObject.stringValue;
        [self getResult:data];
    }
}

- (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxByte maxSideLength:(CGFloat)maxSideLength {
    CGSize imageSize = image.size;
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    CGSize targetSize;

    if (imageSize.width > imageSize.height) {
        targetSize = CGSizeMake(maxSideLength, maxSideLength / aspectRatio);
    } else {
        targetSize = CGSizeMake(maxSideLength * aspectRatio, maxSideLength);
    }

    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:targetSize];
    UIImage *newImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    }];

    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(newImage, compression);

    while (imageData.length > maxByte && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(newImage, compression);
    }

    return imageData;
}
-(void)checkQRFromUIImage:(UIImage *)image{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat maxImageSideLength = 640; // 设置图片最长边的长度
        NSData *imageData = [self compressImage:image toByte:1024*1024 maxSideLength:maxImageSideLength];
        // 检测二维码
        CIImage *ciImage = [CIImage imageWithData:imageData];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        NSArray *features = [detector featuresInImage:ciImage];
        if (features.count > 0) {
            CIQRCodeFeature *feature = features[0];
            NSString *qrString = feature.messageString;
            [self getResult:qrString];
        } else {
            [self showErrorView];
        }
    });

}
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)){
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (results.count != 0) {
        PHPickerResult *result = results.firstObject;
        NSItemProvider *itemProvider = result.itemProvider;
        
        //检测是否有二维码
        if ([itemProvider canLoadObjectOfClass:UIImage.class]) {
           [itemProvider loadObjectOfClass:UIImage.class completionHandler:^(id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error){
               if (error) {
                   [self showErrorView];
               }
               else{
                   UIImage *image = (UIImage *)object;
                   [self checkQRFromUIImage:image];
               }
           }];
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self checkQRFromUIImage:image];
    }];
    
}

@end
