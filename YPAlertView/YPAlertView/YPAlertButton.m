//
//  YPAlertButton.m
//  YPAlertView
//
//  Created by 喻平 on 2018/4/24.
//  Copyright © 2018年 com.yp. All rights reserved.
//

#import "YPAlertButton.h"

@interface YPAlertButton ()

@property (nonatomic, strong) NSMutableDictionary *colorDict;
@property (nonatomic, strong) NSMutableDictionary *fontDict;

@end

@implementation YPAlertButton

+ (instancetype)buttonWithTitle:(NSString *)title style:(YPAlertButtonStyle)style onPressed:(void (^)(void))onPressed {
    YPAlertButton *button = [YPAlertButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.style = style;
    button.onPressed = onPressed;
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    _colorDict = [NSMutableDictionary dictionaryWithDictionary:
                  @{@(YPAlertButtonStyleDefault) : [UIColor systemBlueColor],
                    @(YPAlertButtonStyleCancel) : [UIColor darkGrayColor],
                    @(YPAlertButtonStyleDestructive) : [UIColor colorWithRed:244 / 255.0f green:67 / 255.0f blue:54 / 255.0f alpha:1.0f],
                    @(YPAlertButtonStyleFocus) : [UIColor systemBlueColor],
                  }];
    
    _fontDict = [NSMutableDictionary dictionaryWithDictionary:
                 @{@(YPAlertButtonStyleFocus) : [UIFont boldSystemFontOfSize:17]}];
    
    _autoDismiss = YES;
    _style = YPAlertButtonStyleDefault;
    _cornerRadius = 5;
}

- (void)setColor:(UIColor *)color style:(YPAlertButtonStyle)style {
    self.colorDict[@(style)] = color;
}

- (void)setTitleFont:(UIFont *)font style:(YPAlertButtonStyle)style {
    self.fontDict[@(style)] = font;
}

- (void)update {
    self.titleLabel.font = self.fontDict[@(self.style)];
    if (self.isCorner) {
        self.layer.cornerRadius = self.cornerRadius;
        if (self.style == YPAlertButtonStyleDestructive ||
            self.style == YPAlertButtonStyleFocus) {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.backgroundColor = self.colorDict[@(self.style)];
        } else {
            [self setTitleColor:self.colorDict[@(self.style)] forState:UIControlStateNormal];
            self.layer.borderWidth = 1.0f / [UIScreen mainScreen].nativeScale;
            self.layer.borderColor = [self.colorDict[@(self.style)] CGColor];
        }
    } else {
        self.tintColor = self.colorDict[@(self.style)];
    }
}

@end
