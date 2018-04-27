//
//  YPAlertButton.m
//  YPAlertView
//
//  Created by 喻平 on 2018/4/24.
//  Copyright © 2018年 com.yp. All rights reserved.
//

#import "YPAlertButton.h"

@interface YPAlertButton ()



@end

@implementation YPAlertButton

+ (instancetype)buttonWithTitle:(NSString *)title style:(YPAlertButtonStyle)style handler:(void (^)(YPAlertButton *))handler {
    YPAlertButton *button = [YPAlertButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.style = style;
    button.handler = handler;
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _defaultBgColor = [[[self class] appearance] defaultBgColor] ?: [UIColor clearColor];
        _defaultTitleColor = [[[self class] appearance] defaultTitleColor] ?: [UIColor blackColor];
        _defaultTitleFont = [[[self class] appearance] defaultTitleFont] ?: [UIFont systemFontOfSize:17];
        _cancelBgColor = [[[self class] appearance] cancelBgColor] ?: [UIColor clearColor];
        _cancelTitleColor = [[[self class] appearance] cancelTitleColor] ?: [UIColor blackColor];
        _cancelTitleFont = [[[self class] appearance] cancelTitleFont] ?: [UIFont systemFontOfSize:17];
        _destructiveBgColor = [[[self class] appearance] destructiveBgColor] ?: [UIColor clearColor];
        _destructiveTitleColor = [[[self class] appearance] destructiveTitleColor] ?: [UIColor blackColor];
        _destructiveTitleFont = [[[self class] appearance] destructiveTitleFont] ?: [UIFont systemFontOfSize:17];
        
        self.style = YPAlertButtonStyleDefault;
    }
    return self;
}


- (void)setStyle:(YPAlertButtonStyle)style {
    _style = style;
    
    switch (style) {
        case YPAlertButtonStyleDefault:
            self.backgroundColor = self.defaultBgColor;
            self.titleLabel.font = self.defaultTitleFont;
            [self setTitleColor:self.defaultTitleColor forState:UIControlStateNormal];
            break;
        case YPAlertButtonStyleCancel:
            self.backgroundColor = self.cancelBgColor;
            self.titleLabel.font = self.cancelTitleFont;
            [self setTitleColor:self.cancelTitleColor forState:UIControlStateNormal];
            break;
        case YPAlertButtonStyleDestructive:
            self.backgroundColor = self.destructiveBgColor;
            self.titleLabel.font = self.destructiveTitleFont;
            [self setTitleColor:self.destructiveTitleColor forState:UIControlStateNormal];
            break;
    }
}

@end
