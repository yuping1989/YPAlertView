//
//  YPAlertButton.h
//  YPAlertView
//
//  Created by 喻平 on 2018/4/24.
//  Copyright © 2018年 com.yp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YPAlertButtonStyle) {
    YPAlertButtonStyleDefault,
    YPAlertButtonStyleCancel,
    YPAlertButtonStyleWarning,
    YPAlertButtonStyleFocus
};

@interface YPAlertButton : UIButton

// 进isCorner为YES时生效
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) YPAlertButtonStyle style;
@property (nonatomic, assign) BOOL isCorner;
@property (nonatomic, copy) void (^onPressed)(void);
@property (nonatomic, assign) BOOL autoDismiss;

@property (nonatomic, assign) NSInteger index;

+ (instancetype)button;
+ (instancetype)buttonWithTitle:(NSString *)title
                          style:(YPAlertButtonStyle)style
                      onPressed:(void (^)(void))onPressed;

- (void)setColor:(UIColor *)color forStyle:(YPAlertButtonStyle)style UI_APPEARANCE_SELECTOR;
- (void)setTitleFont:(UIFont *)font forStyle:(YPAlertButtonStyle)style UI_APPEARANCE_SELECTOR;

- (void)update;

@end
