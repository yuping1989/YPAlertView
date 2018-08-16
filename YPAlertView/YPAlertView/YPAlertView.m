//
//  YPAlertView.m
//  YPAlertView
//
//  Created by 喻平 on 2018/4/24.
//  Copyright © 2018年 com.yp. All rights reserved.
//

#import "YPAlertView.h"
#import <Masonry/Masonry.h>

@interface YPAlertView ()

@property (nonatomic, strong, readwrite) UIImageView *maskView;

@property (nonatomic, strong, readwrite) UIView *titleView;
@property (nonatomic, strong, readwrite) UIImageView *titleBgImageView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@property (nonatomic, strong, readwrite) UIView *messageView;
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
    
    self.maskView.alpha = 0;
    self.alpha = 0;
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.maskView.alpha = 0.5f;
                         self.alpha = 1;
                     }];
}

- (void)dismiss {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.maskView.alpha = 0;
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.maskView removeFromSuperview];
                         [self removeFromSuperview];
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)setTitleBgImage:(UIImage *)titleBgImage {
    _titleBgImage = titleBgImage;
    self.titleBgImageView.image = titleBgImage;
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
    
    _separatorColor = [[[self class] appearance] separatorColor];
    if (!_separatorColor) {
        _separatorColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1];
    }
    
    _titleBgImage = [[[self class] appearance] titleBgImage];
    _titleBgColor = [[[self class] appearance] titleBgColor] ?: [UIColor clearColor];
    _titleColor = [[[self class] appearance] titleColor] ?: [UIColor blackColor];
    _titleFont = [[[self class] appearance] titleFont] ?: [UIFont boldSystemFontOfSize:18];
    
    _messageColor = [[[self class] appearance] messageColor] ?: [UIColor blackColor];
    _messageFont = [[[self class] appearance] messageFont] ?: [UIFont systemFontOfSize:16];
    
    [self initViews];
}

- (void)initViews {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    self.layer.cornerRadius = _alertCornerRadius;
    
    _maskView = [[UIImageView alloc] init];
    _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    _maskView.userInteractionEnabled = YES;
    
    _titleView = [[UIImageView alloc] init];
    _titleView.backgroundColor = _titleBgColor;
    [self addSubview:_titleView];
    
    if (_titleBgImage) {
        _titleBgImageView = [[UIImageView alloc] initWithImage:_titleBgImage];
        [_titleView addSubview:_titleBgImageView];
    }
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = _titleFont;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_titleLabel];
    
    _messageView = [[UIImageView alloc] init];
    [self addSubview:_messageView];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.numberOfLines = 0;
    _messageLabel.font = _messageFont;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [_messageView addSubview:_messageLabel];
    
    _buttonsView = [[UIView alloc] init];
    [self addSubview:_buttonsView];
}

- (UIImageView *)titleBgImageView {
    if (!_titleBgImageView) {
        _titleBgImageView = [[UIImageView alloc] init];
        [_titleView insertSubview:_titleBgImageView atIndex:0];
    }
    return _titleBgImageView;
}

- (void)layout {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(window);
    }];
    
    __weak typeof(self) weakSelf = self;
    [weakSelf mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(self) strongSelf = weakSelf;
        make.width.equalTo(@(strongSelf.alertViewWidth));
        make.center.equalTo(window);
    }];
    
    
    [weakSelf.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(self) strongSelf = weakSelf;
        make.left.right.top.equalTo(strongSelf);
    }];
    
    if (_titleBgImageView) {
        [weakSelf.titleBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(self) strongSelf = weakSelf;
            make.edges.equalTo(strongSelf.titleView);
        }];
    }
    
    [weakSelf.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(self) strongSelf = weakSelf;
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if (strongSelf.titleLabel.text) {
            insets = strongSelf.titleEdgeInsets;
        }
        make.edges.equalTo(strongSelf.titleView).insets(insets);
    }];
    
    [weakSelf.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(self) strongSelf = weakSelf;
        make.left.right.equalTo(strongSelf);
        make.top.equalTo(strongSelf.titleView.mas_bottom);
    }];
    
    [weakSelf.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(self) strongSelf = weakSelf;
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if (strongSelf.messageLabel.text) {
            insets = strongSelf.messageEdgeInsets;
        }
        make.edges.equalTo(strongSelf.messageView).insets(insets);
    }];
    
    UIView *buttonTopView = self.messageView;
    if (self.customView) {
        buttonTopView = self.customView;
        [weakSelf.customView mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(self) strongSelf = weakSelf;
            make.top.equalTo(strongSelf.messageView.mas_bottom);
            make.left.right.equalTo(strongSelf);
            if (strongSelf.customViewHeight > 0) {
                make.height.equalTo(@(strongSelf.customView.frame.size.height));
            }
        }];
    }
    
    CGFloat buttonViewHeight;
    if (self.buttons.count == 0) {
        buttonViewHeight = 0;
    } else if (self.buttons.count == 1) {
        buttonViewHeight = self.alertButtonHeight;
        UIButton *button = self.buttons.firstObject;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(self) strongSelf = weakSelf;
            make.edges.equalTo(strongSelf.buttonsView);
        }];
    } else if (self.buttons.count == 2) {
        buttonViewHeight = self.alertButtonHeight;
        [self.buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                                  withFixedSpacing:0
                                       leadSpacing:0
                                       tailSpacing:0];
        [weakSelf.buttons mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(self) strongSelf = weakSelf;
            make.top.bottom.equalTo(strongSelf.buttonsView);
        }];
    } else {
        buttonViewHeight = self.buttons.count * self.alertButtonHeight;
        [self.buttons mas_distributeViewsAlongAxis:MASAxisTypeVertical
                                  withFixedSpacing:0
                                       leadSpacing:0
                                       tailSpacing:0];
        [weakSelf.buttons mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(self) strongSelf = weakSelf;
            make.left.right.equalTo(strongSelf.buttonsView);
        }];
    }
    [weakSelf.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(self) strongSelf = weakSelf;
        make.left.right.bottom.equalTo(strongSelf);
        make.height.equalTo(@(buttonViewHeight));
        make.top.equalTo(buttonTopView.mas_bottom);
    }];
}

- (void)addSeperators {
    CGFloat onePixel = [YPAlertView onePixel];
    __weak typeof(self) weakSelf = self;
    for (UIButton *button in self.buttons) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = self.separatorColor;
        [button addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(button);
            make.height.equalTo(@(onePixel));
        }];
    }
    
    if (self.buttons.count == 2) {
        UIButton *button = self.buttons.firstObject;
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = self.separatorColor;
        [button addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(button);
            make.width.equalTo(@(onePixel));
        }];
    }
    
    if (self.messageLabel.text) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = self.separatorColor;
        [self.titleView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(self) strongSelf = weakSelf;
            make.left.bottom.right.equalTo(strongSelf.titleView);
            make.height.equalTo(@(onePixel));
        }];
    }
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
        [alert addButtonWithTitle:cancelButtonTitle
                            style:YPAlertButtonStyleCancel
                          handler:^(YPAlertButton *button) {
                              if (handler) {
                                  handler(NO);
                              }
                          }];
    }
    if (okButtonTitle) {
        [alert addButtonWithTitle:okButtonTitle
                            style:YPAlertButtonStyleDestructive
                          handler:^(YPAlertButton *button) {
                              if (handler) {
                                  handler(YES);
                              }
                          }];
    }
    [alert show];
    return alert;
}

@end
