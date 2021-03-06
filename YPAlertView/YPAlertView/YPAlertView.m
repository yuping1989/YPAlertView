//
//  YPAlertView.m
//  YPAlertView
//
//  Created by 喻平 on 2018/4/24.
//  Copyright © 2018年 com.yp. All rights reserved.
//

#import "YPAlertView.h"
#import <Masonry/Masonry.h>

#define iPhoneXSeries \
({BOOL isIPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isIPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isIPhoneX);})

@interface YPAlertView ()

@property (nonatomic, strong, readwrite) UIImageView *maskView;

@property (nonatomic, strong, readwrite) UIImageView *titleView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UIButton *dismissButton;

@property (nonatomic, strong, readwrite) UIImageView *messageView;
@property (nonatomic, strong, readwrite) UILabel *messageLabel;

@property (nonatomic, strong, readwrite) UIView *buttonsView;

@property (nonatomic, assign) CGFloat customViewHeight;

@property (nonatomic, strong, readwrite) NSMutableArray *buttons;

@end

@implementation YPAlertView

#pragma mark - 外部方法

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setup];
    }
    return self;
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message {
    return [[self alloc] initWithTitle:title message:message];
}

+ (instancetype)alertWithTitle:(NSString *)title
             attributedMessage:(NSAttributedString *)message {
    return [[self alloc] initWithTitle:title attributedMessage:message];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message {
    self = [super init];
    if (self) {
        [self _setup];
        
        _titleLabel.text = title;
        _messageLabel.text = message;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
            attributedMessage:(NSAttributedString *)message {
    self = [super init];
    if (self) {
        [self _setup];
        
        _titleLabel.text = title;
        _messageLabel.attributedText = message;
    }
    return self;
}

- (void)addButton:(YPAlertButton *)button {
    if (!button) {
        return;
    }
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons addObject:button];
    [self.buttonsView addSubview:button];
}

- (void)addDefaultButtonWithTitle:(NSString *)title
                          handler:(void (^)(YPAlertButton *))handler {
    [self addButtonWithTitle:title
                       style:YPAlertButtonStyleDefault
                     handler:handler];
}

- (void)addCancelButtonWithTitle:(NSString *)title
                         handler:(void (^)(YPAlertButton *))handler {
    [self addButtonWithTitle:title
                       style:YPAlertButtonStyleCancel
                     handler:handler];
}

- (void)addDestructiveButtonWithTitle:(NSString *)title
                              handler:(void (^)(YPAlertButton *))handler {
    [self addButtonWithTitle:title
                       style:YPAlertButtonStyleDestructive
                     handler:handler];
}

- (void)addButtonWithTitle:(NSString *)title
                     style:(YPAlertButtonStyle)style
                   handler:(void (^)(YPAlertButton *))handler {
    YPAlertButton *button = [YPAlertButton buttonWithTitle:title style:style handler:handler];
    [self addButton:button];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [self showInView:window];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self.maskView];
    [view addSubview:self];
    [self layout];
    [self addSeperators];
    
    if (self.style == YPAlertViewStyleActionSheet) {
        self.maskView.alpha = 0;
        [self.superview layoutIfNeeded];
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.superview);
            make.bottom.equalTo(self.superview);
        }];
        [UIView animateWithDuration:0.25f animations:^{
            [self.superview layoutIfNeeded];
            self.maskView.alpha = 0.5f;
        }];
    } else {
        self.maskView.alpha = 0;
        self.alpha = 0;
        [UIView animateWithDuration:0.25f animations:^{
            self.maskView.alpha = 0.5f;
            self.alpha = 1;
        }];
    }
}

- (void)dismiss {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    
    if (self.style == YPAlertViewStyleActionSheet) {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.superview);
            make.top.equalTo(self.superview.mas_bottom);
        }];
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.maskView.alpha = 0;
        if (self.style == YPAlertViewStyleActionSheet) {
            [self.superview layoutIfNeeded];
        } else {
            self.alpha = 0;
        }
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

- (void)setStyle:(YPAlertViewStyle)style {
    _style = style;
    if (style == YPAlertViewStyleActionSheet) {
        self.tapBgToDismiss = YES;
        self.layer.cornerRadius = 0;
    }
}

- (void)setTitleBgImage:(UIImage *)titleBgImage {
    _titleBgImage = titleBgImage;
    self.titleView.image = titleBgImage;
}

- (void)setTitleBgColor:(UIColor *)titleBgColor {
    _titleBgColor = titleBgColor;
    self.titleView.backgroundColor = titleBgColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setMessageColor:(UIColor *)messageColor {
    _messageColor = messageColor;
    self.messageLabel.textColor = messageColor;
}

- (void)setMessageFont:(UIFont *)messageFont {
    _messageFont = messageFont;
    self.messageLabel.font = messageFont;
}

- (void)setCustomView:(UIView *)view height:(CGFloat)height {
    self.customView = view;
    self.customViewHeight = height;
}

- (void)setCustomView:(UIView *)customView {
    _customView = customView;
    [self addSubview: customView];
}

#pragma mark - 内部方法

- (void)_setup {
    _buttons = [NSMutableArray array];
    
    _titleEdgeInsets = [[[self class] appearance] titleEdgeInsets];
    if (UIEdgeInsetsEqualToEdgeInsets(_titleEdgeInsets, UIEdgeInsetsZero)) {
        _titleEdgeInsets = UIEdgeInsetsMake(10, 10, 11, 10);
    }
    
    _messageEdgeInsets = [[[self class] appearance] messageEdgeInsets];
    if (UIEdgeInsetsEqualToEdgeInsets(_messageEdgeInsets, UIEdgeInsetsZero)) {
        _messageEdgeInsets = UIEdgeInsetsMake(20, 15, 20, 15);
    }
    
    _buttonsEdgeInsets = [[[self class] appearance] buttonsEdgeInsets];
    _buttonSpace = [[[self class] appearance] buttonSpace];
    
    _alertViewWidth = [[[self class] appearance] alertViewWidth];
    if (_alertViewWidth == 0) {
        _alertViewWidth = 300;
    }
    
    _alertButtonHeight = [[[self class] appearance] alertButtonHeight];
    if (_alertButtonHeight == 0) {
        _alertButtonHeight = 44;
    }
    
    _alertCornerRadius = [[[self class] appearance] alertCornerRadius];
    if (_alertCornerRadius == 0) {
        _alertCornerRadius = 10;
    }
    
    _separatorColor = [[[self class] appearance] separatorColor] ?: [UIColor colorWithWhite:0.85f alpha:1.0f];
    _titleSeparatorHeight = [[[self class] appearance] titleSeparatorHeight] ?: @([YPAlertView onePixel]);
    
    _titleBgImage = [[[self class] appearance] titleBgImage];
    _titleBgColor = [[[self class] appearance] titleBgColor] ?: [UIColor clearColor];
    _titleColor = [[[self class] appearance] titleColor] ?: [UIColor blackColor];
    _titleFont = [[[self class] appearance] titleFont] ?: [UIFont boldSystemFontOfSize:18];
    
    _messageColor = [[[self class] appearance] messageColor] ?: [UIColor blackColor];
    _messageFont = [[[self class] appearance] messageFont] ?: [UIFont systemFontOfSize:16];
    
    _tapBgToDismiss = [[[self class] appearance] tapBgToDismiss];
    _dismissButtonAppear = [[[self class] appearance] dismissButtonAppear];

    [self initViews];
}

- (void)initViews {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    self.layer.cornerRadius = _alertCornerRadius;
    
    _maskView = [[UIImageView alloc] init];
    _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    _maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTapped)];
    [_maskView addGestureRecognizer:gesture];
    
    _titleView = [[UIImageView alloc] init];
    _titleView.backgroundColor = _titleBgColor;
    _titleView.userInteractionEnabled = YES;
    [self addSubview:_titleView];
    
    if (_titleBgImage) {
        _titleView.image = _titleBgImage;
    }
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = _titleFont;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_titleLabel];
    
    _messageView = [[UIImageView alloc] init];
    _messageView.userInteractionEnabled = YES;
    [self addSubview:_messageView];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.numberOfLines = 0;
    _messageLabel.font = _messageFont;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [_messageView addSubview:_messageLabel];
    
    _buttonsView = [[UIView alloc] init];
    [self addSubview:_buttonsView];
}

- (void)maskViewTapped {
    if (self.tapBgToDismiss) {
        [self dismiss];
    }
}

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _dismissButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _dismissButton.hidden = YES;
        [_dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_dismissButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_titleView addSubview:_dismissButton];
    }
    return _dismissButton;
}

- (void)layout {
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.superview);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.style == YPAlertViewStyleActionSheet) {
            make.left.right.equalTo(self.superview);
            make.top.equalTo(self.superview.mas_bottom);
        } else {
            make.width.equalTo(@(self.alertViewWidth));
            make.center.equalTo(self.superview);
        }
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if (self.titleLabel.text) {
            insets = self.titleEdgeInsets;
        }
        make.edges.equalTo(self.titleView).insets(insets);
    }];
    
    if (self.dismissButtonAppear) {
        [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.titleView);
            make.width.mas_equalTo(44);
        }];
    }
    
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if (self.messageLabel.text) {
            insets = self.messageEdgeInsets;
        }
        make.edges.equalTo(self.messageView).insets(insets);
    }];
    
    UIView *buttonTopView = self.messageView;
    if (self.customView) {
        buttonTopView = self.customView;
        [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.messageView.mas_bottom);
            make.left.right.equalTo(self);
            if (self.customViewHeight > 0) {
                make.height.mas_equalTo(self.customViewHeight);
            }
        }];
    }
    
    if (self.style == YPAlertViewStyleSystem && self.buttons.count == 2) {
        [self.buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                                  withFixedSpacing:0
                                       leadSpacing:0
                                       tailSpacing:0];
        [self.buttons mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.buttonsView);
            make.height.mas_equalTo(self.alertButtonHeight);
        }];
    } else {
        YPAlertButton *topButton;
        for (int i = 0; i < self.buttons.count; i++) {
            YPAlertButton *button = self.buttons[i];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.buttonsView);
                make.height.mas_equalTo(self.alertButtonHeight);
                if (i == 0) {
                    make.top.equalTo(self.buttonsView);
                } else {
                    if (i == self.buttons.count - 1) {
                        make.bottom.equalTo(self.buttonsView);
                        if (self.style == YPAlertViewStyleActionSheet) {
                            make.top.equalTo(topButton.mas_bottom).offset(self.buttonSpace);
                        } else {
                           make.top.equalTo(topButton.mas_bottom).offset(self.style == YPAlertViewStyleCornerButton ? self.buttonSpace : 0);
                        }
                    } else {
                        make.top.equalTo(topButton.mas_bottom).offset(self.style == YPAlertViewStyleCornerButton ? self.buttonSpace : 0);
                    }
                }
                if (self.buttons.count == 1) {
                    make.bottom.equalTo(self.buttonsView);
                }
            }];
            topButton = button;
        }
    }
    
    CGFloat bottom = 0;
    if (self.style == YPAlertViewStyleActionSheet && iPhoneXSeries) {
        bottom = -34;
    }
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(self.buttonsEdgeInsets.left);
        make.top.equalTo(buttonTopView.mas_bottom).offset(self.buttonsEdgeInsets.top);
        make.right.equalTo(self).offset(-self.buttonsEdgeInsets.right);
        make.bottom.equalTo(self).offset(bottom - self.buttonsEdgeInsets.bottom);
    }];
}

- (void)addSeperators {
    CGFloat onePixel = [YPAlertView onePixel];
    
    if (self.style == YPAlertViewStyleSystem) {
        for (YPAlertButton *button in self.buttons) {
            [self addLineInView:button layout:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(button);
                make.height.equalTo(@(onePixel));
            }];
        }
        
        if (self.buttons.count == 2) {
            YPAlertButton *button = self.buttons.firstObject;
            [self addLineInView:button layout:^(MASConstraintMaker *make) {
                make.top.right.bottom.equalTo(button);
                make.width.equalTo(@(onePixel));
            }];
        }
    } else if (self.style == YPAlertViewStyleActionSheet) {
        for (int i = 0; i < self.buttons.count; i++) {
            YPAlertButton *button = self.buttons[i];
            if (i == self.buttons.count - 1) {
                if (button.style == YPAlertButtonStyleCancel && self.buttons.count > 1) {
                    UIView *line = [[UIView alloc] init];
                    line.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
                    [self.buttonsView addSubview:line];
                    [line mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.equalTo(button);
                        make.height.mas_equalTo(self.buttonSpace);
                        make.bottom.equalTo(button.mas_top);
                    }];
                    break;
                }
            }
            [self addLineInView:button layout:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(button);
                make.height.equalTo(@(onePixel));
            }];
        }
        if (iPhoneXSeries) {
            YPAlertButton *button = [self.buttons lastObject];
            [self addLineInView:self.buttonsView layout:^(MASConstraintMaker *make) {
                make.left.right.equalTo(button);
                make.top.equalTo(button.mas_bottom);
                make.height.equalTo(@(onePixel));
            }];
        }
    }
    
    if (self.titleSeparatorHeight.floatValue > 0) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = self.separatorColor;
        [self.titleView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.titleView);
            make.height.equalTo(@(self.titleSeparatorHeight.floatValue));
        }];
    }
}

- (void)addLineInView:(UIView *)view layout:(void(NS_NOESCAPE ^)(MASConstraintMaker *make))block {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = self.separatorColor;
    [view addSubview:line];
    [line mas_makeConstraints:block];
}

- (void)buttonClicked:(YPAlertButton *)button {
    if (button.handler) {
        button.handler(button);
    }
    if (button.autoDismiss) {
        [self dismiss];
    }
}

+ (CGFloat)onePixel {
    UIScreen* mainScreen = [UIScreen mainScreen];
    if ([mainScreen respondsToSelector:@selector(nativeScale)]) {
        return 1.0f / mainScreen.nativeScale;
    } else {
        return 1.0f / mainScreen.scale;
    }
}

@end

@implementation YPAlertView (Add)

+ (instancetype)showWithTitle:(NSString *)title {
    return [self showWithTitle:title message:nil];
}

+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message {
    return [self showWithTitle:title
                       message:message
             cancelButtonTitle:nil
                 okButtonTitle:@"我知道了"
                       handler:nil];
}

+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
                okButtonTitle:(NSString *)okButtonTitle
              okButtonClicked:(void (^)(void))okButtonClicked {
    return [self showWithTitle:title
                       message:message
             cancelButtonTitle:@"取消"
                 okButtonTitle:okButtonTitle
                       handler:^(BOOL isOkButton) {
                           if (okButtonClicked && isOkButton) {
                               okButtonClicked();
                           }
                       }];
}

+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
                okButtonTitle:(NSString *)okButtonTitle
                      handler:(void (^)(BOOL))handler {
    YPAlertView *alert = [[YPAlertView alloc] initWithTitle:title message:message];
    if (cancelButtonTitle) {
        [alert addCancelButtonWithTitle:cancelButtonTitle handler:^(YPAlertButton *button) {
            if (handler) {
                handler(NO);
            }
        }];
    }
    if (okButtonTitle) {
        [alert addDestructiveButtonWithTitle:okButtonTitle handler:^(YPAlertButton *button) {
            if (handler) {
                handler(YES);
            }
        }];
    }
    [alert show];
    return alert;
}

@end
