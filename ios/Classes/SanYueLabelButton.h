//
//  SanYueButton.h
//  SanYueWebApp
//
//  Created by 宋航 on 2020/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SanYueLabelButton : UIButton
@property (nonatomic,strong)UIColor *normalBgColor;
-(void)setUpBtn:(NSString *)text andTextColor:(NSString *)textColor andTextColorDark:(NSString *)textColorDark andTag:(int)tag andFrame:(CGRect)frame andIsSelect:(BOOL)isSelect;
@property (nonatomic,weak)UILabel *myTextLabel;
@end

NS_ASSUME_NONNULL_END
