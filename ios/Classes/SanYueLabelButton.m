//
//  SanYueButton.m
//  SanYueWebApp
//
//  Created by 宋航 on 2020/3/19.
//

#import "SanYueLabelButton.h"
#import "UIColor+SanYueExtension.h"
@interface SanYueLabelButton()
@property (nonatomic,strong)UIColor *highLightColor;
@end
@implementation SanYueLabelButton
- (UIColor *)highLightColor{
    if (!_highLightColor) {
        UIColor *btnBg = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:25/255.0];
        if (@available(iOS 13.0, *)) {
            btnBg = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                if (traitCollection.userInterfaceStyle != UIUserInterfaceStyleDark) { return [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:25/255.0]; }
                else{ return [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:50/255.0]; }
            }];
        }
        _highLightColor = btnBg;
    }
    return _highLightColor;
}
- (void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        self.backgroundColor = self.highLightColor;
    }
    else{
        self.backgroundColor = self.normalBgColor ? self.normalBgColor : UIColor.clearColor;
    }
}
-(void)setUpBtn:(NSString *)text andTextColor:(NSString *)textColor andTextColorDark:(NSString *)textColorDark andTag:(int)tag andFrame:(CGRect)frame andIsSelect:(BOOL)isSelect{
    UIColor *color = [UIColor colorWithHexString:textColor];
    self.tag = tag;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, frame.size.width - 24, frame.size.height)];
    self.frame = frame;
    textLabel.textColor = color;
    textLabel.text = text;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont fontWithName:isSelect ? @"PingFangSC-Semibold" : @"PingFangSC-Regular" size: 17];
    textLabel.userInteractionEnabled = NO;
    [self addSubview:textLabel];
    _myTextLabel = textLabel;
}
@end
