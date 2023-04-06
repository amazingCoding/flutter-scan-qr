//
//  SanYueModalController.m
//  AFNetworking
//
//  Created by 宋航 on 2020/3/19.
//

#import "SanYueModalController.h"
#import "SanYueAlertItem.h"
#import "UIColor+SanYueExtension.h"
#import "SanYueLabelButton.h"

typedef void(^SelectBlock)(int index);
@interface SanYueModalController ()
@property (nonatomic,strong)SanYueAlertItem *item;
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,copy) SelectBlock selectBlock;
@property (nonatomic,weak)UIView *bgView;
@property (nonatomic,weak)UIView *mainView;
@end

@implementation SanYueModalController
-(instancetype)initWithItem:(SanYueAlertItem*)item andHandler:(void (^ __nullable)(int index))handler{
    self = [super init];
    if (self) {
        self.item = item;
        self.selectBlock = handler;
        self.senseMode = item.senseMode;
        [self setUpMainView];
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
}
#pragma mark UI
-(void)setUpMainView{
    CGFloat WIDTH = [UIScreen mainScreen].bounds.size.width;
    CGFloat HEIGHT = [UIScreen mainScreen].bounds.size.height;
    UIColor *mainBgColor = UIColor.whiteColor;
    UIColor *titleColor = UIColor.blackColor;
    UIColor *contentColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:200/255.0];
    UIColor *lineColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:25/255.0];
    // bg
    UIButton *bgView = [UIButton buttonWithType:UIButtonTypeCustom];
    bgView.tag = -1;
    bgView.frame = self.view.bounds;
    bgView.backgroundColor = UIColor.clearColor;
    [bgView addTarget:self action:@selector(backEvent:) forControlEvents:UIControlEventTouchUpInside];
    bgView.userInteractionEnabled = _item.backGroundCancel;
    [self.view addSubview:bgView];
    _bgView = bgView;
    // main
    CGFloat mainW = WIDTH - 100;
    UIView *mainView = [[UIView alloc] init];
    mainView.layer.masksToBounds = YES;
    mainView.layer.cornerRadius = 12;
    mainView.backgroundColor = mainBgColor;
    [self.view addSubview:mainView];
    _mainView = mainView;
    // title
    CGFloat titleW = mainW - 48;
    UILabel *titleView = [[UILabel alloc] init];
    titleView.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 22];
    CGFloat titleHeight = [_item.title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : titleView.font } context:nil].size.height;
    titleView.frame = CGRectMake(24, 32, titleW, titleHeight);
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = _item.title;
    titleView.numberOfLines = 0;
    titleView.textColor = titleColor;
    [_mainView addSubview:titleView];
    // content
    // 不限制行数
    UILabel *contentView = [[UILabel alloc] init];
    contentView.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    CGFloat contentHeight = [_item.content boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : contentView.font } context:nil].size.height;
    contentView.textAlignment = NSTextAlignmentCenter;
    contentView.text = _item.content;
    contentView.numberOfLines = 0;
    contentView.textColor = contentColor;
    contentView.frame = CGRectMake(24, CGRectGetMaxY(titleView.frame) + 16, titleW, contentHeight);
    [_mainView addSubview:contentView];
    // line
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame) + 32, WIDTH, 1)];
    horizontalLine.backgroundColor = lineColor;
    [_mainView addSubview:horizontalLine];
    // cancelBtn
    CGFloat btnW = (mainW - 1) * 0.5;
    CGFloat btnY = CGRectGetMaxY(horizontalLine.frame);
    if (_item.showCancel) {
        SanYueLabelButton *cancelBtn = [SanYueLabelButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setUpBtn:_item.cancelText andTextColor:_item.cancelColor andTextColorDark:_item.cancelColorDark andTag:0 andFrame:CGRectMake(0, btnY, btnW, 56) andIsSelect:NO];
        [cancelBtn addTarget:self action:@selector(backEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:cancelBtn];
        // line
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(btnW, btnY, 1, 56)];
        verticalLine.backgroundColor = lineColor;
        [_mainView addSubview:verticalLine];
    }
    else{
        btnW = mainW;
    }
    // okBtn
    SanYueLabelButton *okBtn = [SanYueLabelButton buttonWithType:UIButtonTypeCustom];
    [okBtn setUpBtn:_item.confirmText andTextColor:_item.confirmColor andTextColorDark:_item.confirmColorDark andTag:1 andFrame:CGRectMake(btnW == mainW ? 0 : btnW + 1, btnY, btnW, 56) andIsSelect:NO];
    [okBtn addTarget:self action:@selector(backEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:okBtn];
    
    CGFloat mainHeight = CGRectGetMaxY(okBtn.frame);
    _mainView.frame = CGRectMake(50, (HEIGHT - mainHeight) * 0.5, mainW, mainHeight);
    _mainView.transform = CGAffineTransformMakeScale(0.1,0.1);
    _mainView.alpha = 0.1;
}
# pragma mark - 展示 & 隐藏 事件
-(void)show:(NSTimeInterval)duration andCompletion:(void (^ __nullable)(BOOL finished))completion{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.mainView.transform = CGAffineTransformMakeScale(1,1);
        weakSelf.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        weakSelf.mainView.alpha = 1;
    } completion:^(BOOL finished) {
        completion(finished);
        weakSelf.isShow = YES;
    }];
}
-(void)dismiss:(NSTimeInterval)duration andCompletion:(void (^ __nullable)(BOOL finished))completion{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.mainView.transform = CGAffineTransformMakeScale(0.1,0.1);
        weakSelf.bgView.backgroundColor = UIColor.clearColor;
        weakSelf.mainView.alpha = 0.1;
    } completion:^(BOOL finished) {
        completion(finished);
        weakSelf.isShow = NO;
    }];
}
#pragma mark - 事件
- (void)backEvent:(UIView *)view{
    int index = (int)view.tag;
    self.selectBlock(index);
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
