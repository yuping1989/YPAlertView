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


#define ChainSetterImp(_pType_, _pName_, _setter_)  \
- (YPAlertView * (^)(_pType_ _pName_))s_##_pName_ {  \
    return ^(_pType_ param) {  \
        [self _setter_:param]; \
        return self;  \
    };  \
}

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
@property (nonatomic, strong) NSMutableDictionary *buttonHeightDict;

@end

@implementation YPAlertView

#pragma mark - 外部方法

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
        
        self.title = title;
        self.message = message;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
            attributedMessage:(NSAttributedString *)message {
    self = [super init];
    if (self) {
        [self _setup];
        
        self.title = title;
        self.attributedMessage = message;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleLabel.text = title;
}

- (void)setMessage:(NSString *)message {
    _message = [message copy];
    self.messageLabel.text = message;
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    _attributedTitle = [attributedTitle copy];
    self.titleLabel.attributedText = attributedTitle;
}

- (void)setAttributedMessage:(NSAttributedString *)attributedMessage {
    _attributedMessage = [attributedMessage copy];
    self.messageLabel.attributedText = attributedMessage;
}

- (void)setAlertCornerRadius:(CGFloat)alertCornerRadius {
    _alertCornerRadius = alertCornerRadius;
    self.layer.cornerRadius = alertCornerRadius;
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

- (void)addButton:(YPAlertButton *)button {
    if (!button) {
        return;
    }
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons addObject:button];
    [self.buttonsView addSubview:button];
}

- (void)addDefaultButtonWithTitle:(NSString *)title
                        onPressed:(void (^)(void))onPressed {
    [self addButtonWithTitle:title
                       style:YPAlertButtonStyleDefault
                     onPressed:onPressed];
}

- (void)addCancelButtonWithTitle:(NSString *)title
                         onPressed:(void (^)(void))onPressed {
    [self addButtonWithTitle:title
                       style:YPAlertButtonStyleCancel
                     onPressed:onPressed];
}

- (void)addDestructiveButtonWithTitle:(NSString *)title
                              onPressed:(void (^)(void))onPressed {
    [self addButtonWithTitle:title
                       style:YPAlertButtonStyleDestructive
                     onPressed:onPressed];
}

- (void)addFocusButtonWithTitle:(NSString *)title
                      onPressed:(void (^)(void))onPressed {
    [self addButtonWithTitle:title
                       style:YPAlertButtonStyleFocus
                     onPressed:onPressed];
}

- (void)addButtonWithTitle:(NSString *)title
                     style:(YPAlertButtonStyle)style
                 onPressed:(void (^)(void))onPressed {
    YPAlertButton *button = [YPAlertButton buttonWithTitle:title style:style onPressed:onPressed];
    [self addButton:button];
}

- (void)setButtonHeight:(CGFloat)height forStyle:(YPAlertViewStyle)style {
    self.buttonHeightDict[@(style)] = @(height);
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [self showInView:window];
}

- (void)showInView:(UIView *)view {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [view addSubview:self.maskView];
    [view addSubview:self];
    
    for (YPAlertButton *button in self.buttons) {
        button.isCorner = self.style == YPAlertViewStyleCornerButton;
        [button update];
    }
    if (self.style != YPAlertViewStyleCornerButton) {
        self.buttonSpace = 0;
        self.buttonEdgeInsets = UIEdgeInsetsZero;
    }
    
    [self layout];
    [self addSeperators];
    
    if (self.style == YPAlertViewStyleActionSheet) {
        self.tapBgToDismiss = YES;
        self.alertCornerRadius = 0;
        
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
    
    _titleEdgeInsets = UIEdgeInsetsMake(10, 10, 11, 10);
    _messageEdgeInsets = UIEdgeInsetsMake(20, 15, 20, 15);
    
    _alertViewWidth = 300;
    _buttonSpace = 10;
    _buttonEdgeInsets = UIEdgeInsetsMake(0, 20, 10, 20);
    
    _separatorColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    _titleSeparatorHeight = @([YPAlertView onePixel]);
    
    NSDictionary *dict = @{@(YPAlertViewStyleSystem) : @44,
                           @(YPAlertViewStyleCornerButton) : @40,
                           @(YPAlertViewStyleActionSheet) : @55};
    _buttonHeightDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    [self initViews];
    
    self.titleFont = [UIFont boldSystemFontOfSize:18];
    self.messageFont = [UIFont systemFontOfSize:16];
}

- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    _titleEdgeInsets = titleEdgeInsets;
}

- (void)initViews {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.alertCornerRadius = 10;
    
    _maskView = [[UIImageView alloc] init];
    _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    _maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTapped)];
    [_maskView addGestureRecognizer:gesture];
    
    _titleView = [[UIImageView alloc] init];
    _titleView.userInteractionEnabled = YES;
    [self addSubview:_titleView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_titleLabel];
    
    _messageView = [[UIImageView alloc] init];
    _messageView.userInteractionEnabled = YES;
    [self addSubview:_messageView];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.numberOfLines = 0;
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
    
    if (self.showDismissButton) {
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
    
    if (self.buttons.count > 1) {
        if (self.buttonVertical || self.style == YPAlertViewStyleActionSheet) {
            [self.buttons mas_distributeViewsAlongAxis:MASAxisTypeVertical
                                      withFixedSpacing:self.buttonSpace
                                           leadSpacing:0
                                           tailSpacing:0];
            [self.buttons mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.buttonsView);
                make.height.equalTo(self.buttonHeightDict  [@(self.style)]);
            }];
        } else {
            [self.buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                                      withFixedSpacing:self.buttonSpace
                                           leadSpacing:0
                                           tailSpacing:0];
            [self.buttons mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.buttonsView);
                make.height.mas_equalTo(self.buttonHeightDict  [@(self.style)]);
            }];
        }
    } else {
        YPAlertButton *button = self.buttons.firstObject;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.buttonsView);
            make.height.mas_equalTo(self.buttonHeightDict  [@(self.style)]);
        }];
    }
    
    CGFloat bottom = 0;
    if (self.style == YPAlertViewStyleActionSheet && iPhoneXSeries) {
        bottom = -34;
    }
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(self.buttonEdgeInsets.left);
        make.top.equalTo(buttonTopView.mas_bottom).offset(self.buttonEdgeInsets.top);
        make.right.equalTo(self).offset(-self.buttonEdgeInsets.right);
        make.bottom.equalTo(self).offset(bottom - self.buttonEdgeInsets.bottom);
    }];
}

- (void)addSeperators {
    CGFloat onePixel = [YPAlertView onePixel];
    
    if (self.style != YPAlertViewStyleCornerButton) {
        for (YPAlertButton *button in self.buttons) {
            [self addLineInView:button layout:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(button);
                make.height.equalTo(@(onePixel));
            }];
            if (!self.buttonVertical && ![button isEqual:self.buttons.firstObject]) {
                [self addLineInView:button layout:^(MASConstraintMaker *make) {
                    make.left.top.bottom.equalTo(button);
                    make.width.equalTo(@(onePixel));
                }];
            }
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
    if (button.onPressed) {
        button.onPressed();
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
                       onPressed:nil];
}

+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
                okButtonTitle:(NSString *)okButtonTitle
              okButtonClicked:(void (^)(void))okButtonClicked {
    return [self showWithTitle:title
                       message:message
             cancelButtonTitle:@"取消"
                 okButtonTitle:okButtonTitle
                       onPressed:^(BOOL isOkButton) {
                           if (okButtonClicked && isOkButton) {
                               okButtonClicked();
                           }
                       }];
}

+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
                okButtonTitle:(NSString *)okButtonTitle
                    onPressed:(void (^)(BOOL))onPressed {
    YPAlertView *alert = [[YPAlertView alloc] initWithTitle:title message:message];
    if (cancelButtonTitle) {
        [alert addCancelButtonWithTitle:cancelButtonTitle onPressed:^{
            if (onPressed) {
                onPressed(NO);
            }
        }];
    }
    if (okButtonTitle) {
        [alert addDestructiveButtonWithTitle:okButtonTitle onPressed:^{
            if (onPressed) {
                onPressed(YES);
            }
        }];
    }
    [alert show];
    return alert;
}

@end


YPAlertView * YPAlert(void) {
    return [[YPAlertView alloc] init];
};

@implementation YPAlertView (Chain)

- (YPAlertView *(^)(NSString *, void (^)(NSMutableAttributedString *)))s_attrTitleBlock {
    return ^YPAlertView *(NSString *title, void (^block)(NSMutableAttributedString *)) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
        if (block) {
            block(attr);
        }
        self.attributedTitle = attr;
        return self;
    };
}

- (YPAlertView *(^)(NSString *, void (^)(NSMutableAttributedString *)))s_attrMessageBlock {
    return ^YPAlertView *(NSString *message, void (^block)(NSMutableAttributedString *)) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:message];
        if (block) {
            block(attr);
        }
        self.attributedMessage = attr;
        return self;
    };
}


ChainSetterImp(NSString *, title, setTitle)
ChainSetterImp(NSString *, message, setMessage)
ChainSetterImp(NSAttributedString *, attributedTitle, setAttributedTitle)
ChainSetterImp(NSAttributedString *, attributedMessage, setAttributedMessage)
ChainSetterImp(YPAlertViewStyle, style, setStyle)
ChainSetterImp(UIEdgeInsets, titleEdgeInsets, setTitleEdgeInsets)
ChainSetterImp(UIEdgeInsets, messageEdgeInsets, setMessageEdgeInsets)
ChainSetterImp(UIEdgeInsets, buttonEdgeInsets, setButtonEdgeInsets)
ChainSetterImp(CGFloat, buttonSpace, setButtonSpace)
ChainSetterImp(BOOL, buttonVertical, setButtonVertical)

ChainSetterImp(CGFloat, alertViewWidth, setAlertViewWidth)
ChainSetterImp(CGFloat, alertCornerRadius, setAlertCornerRadius)
ChainSetterImp(UIImage *, titleBgImage, setTitleBgImage)
ChainSetterImp(UIColor *, titleBgColor, setTitleBgColor)
ChainSetterImp(UIColor *, titleColor, setTitleColor)
ChainSetterImp(UIFont *, titleFont, setTitleFont)
ChainSetterImp(UIColor *, messageColor, setMessageColor)
ChainSetterImp(UIFont *, messageFont, setMessageFont)
ChainSetterImp(UIColor *, separatorColor, setSeparatorColor)
ChainSetterImp(NSNumber *, titleSeparatorHeight, setTitleSeparatorHeight)
ChainSetterImp(BOOL, tapBgToDismiss, setTapBgToDismiss)
ChainSetterImp(BOOL, showDismissButton, setShowDismissButton)
ChainSetterImp(UIView *, customView, setCustomView)


- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))s_addDefaultButton {
    return ^YPAlertView *(NSString *title, void (^onPressed)(void)) {
        [self addDefaultButtonWithTitle:title onPressed:onPressed];
        return self;
    };
}

- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))s_addCancelButton {
    return ^YPAlertView *(NSString *title, void (^onPressed)(void)) {
        [self addCancelButtonWithTitle:title onPressed:onPressed];
        return self;
    };
}

- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))s_addDestructiveButton {
    return ^YPAlertView *(NSString *title, void (^onPressed)(void)) {
        [self addDestructiveButtonWithTitle:title onPressed:onPressed];
        return self;
    };
}

- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))s_addFocusButton {
    return ^YPAlertView *(NSString *title, void (^onPressed)(void)) {
        [self addFocusButtonWithTitle:title onPressed:onPressed];
        return self;
    };
}

- (YPAlertView *(^)(NSString *, YPAlertButtonStyle, void (^)(void)))s_addButton {
    return ^YPAlertView *(NSString *title, YPAlertButtonStyle style, void (^onPressed)(void)) {
        YPAlertButton *button = [YPAlertButton buttonWithTitle:title style:style onPressed:onPressed];
        [self addButton:button];
        return self;
    };
}

- (YPAlertView *(^)(void))s_show {
    return ^YPAlertView *(void) {
        [self show];
        return self;
    };
}

- (YPAlertView *(^)(UIView *))s_showInView {
    return ^YPAlertView *(UIView *view) {
        [self showInView:view];
        return self;
    };
}

@end
