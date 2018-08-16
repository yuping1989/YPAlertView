//
//  YPAlertButton.h
//  YPAlertView
//
//  Created by 喻平 on 2018/4/24.
//  Copyright © 2018年 com.yp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YPAlertButtonStyle) {
    YPAlertButtonStyleDefault = 0,
    YPAlertButtonStyleCancel,
    YPAlertButtonStyleDestructive
};

@interface YPAlertButton : UIButton

@property (nonatomic, strong) UIColor *defaultBgColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *defaultTitleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *defaultTitleFont UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *cancelBgColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *cancelTitleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *cancelTitleFont UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *destructiveBgColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *destructiveTitleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *destructiveTitleFont UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) YPAlertButtonStyle style;
@property (nonatomic, copy) void (^handler)(YPAlertButton *button);

@property (nonatomic, assign) BOOL autoDismiss;

@property (nonatomic, assign) NSInteger index;

+ (instancetype)buttonWithTitle:(NSString *)title style:(YPAlertButtonStyle)style handler:(void (^)(YPAlertButton *button))handler;

@end
