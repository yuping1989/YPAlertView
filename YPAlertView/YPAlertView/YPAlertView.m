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


#define ChainSetterImp(_propertyType_, _propertyName_, _setter_)  \
- (YPAlertView * (^)(_propertyType_ _propertyName_))_propertyName_ {  \
    return ^(_propertyType_ param) {  \
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
        
        self.mTitle = title;
        self.mMessage = message;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
            attributedMessage:(NSAttributedString *)message {
    self = [super init];
    if (self) {
        [self _setup];
        
        self.mTitle = title;
        self.mAttributedMessage = message;
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

- (void)setMTitle:(NSString *)title {
    _mTitle = [title copy];
    self.titleLabel.text = title;
}

- (void)setMMessage:(NSString *)message {
    _mMessage = [message copy];
    self.messageLabel.text = message;
}

- (void)setMAttributedTitle:(NSAttributedString *)attributedTitle {
    _mAttributedTitle = [attributedTitle copy];
    self.titleLabel.attributedText = attributedTitle;
}

- (void)setMAttributedMessage:(NSAttributedString *)attributedMessage {
    _mAttributedMessage = [attributedMessage copy];
    self.messageLabel.attributedText = attributedMessage;
}

- (void)setMAlertCornerRadius:(CGFloat)alertCornerRadius {
    _mAlertCornerRadius = alertCornerRadius;
    self.layer.cornerRadius = alertCornerRadius;
}

- (void)setMTitleBgImage:(UIImage *)titleBgImage {
    _mTitleBgImage = titleBgImage;
    self.titleView.image = titleBgImage;
}

- (void)setMTitleBgColor:(UIColor *)titleBgColor {
    _mTitleBgColor = titleBgColor;
    self.titleView.backgroundColor = titleBgColor;
}

- (void)setMTitleColor:(UIColor *)titleColor {
    _mTitleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setMTitleFont:(UIFont *)titleFont {
    _mTitleFont = titleFont;
    if (!self.mAttributedTitle) {
        self.titleLabel.font = titleFont;
    }
}

- (void)setMMessageColor:(UIColor *)messageColor {
    _mMessageColor = messageColor;
    self.messageLabel.textColor = messageColor;
}

- (void)setMMessageFont:(UIFont *)messageFont {
    _mMessageFont = messageFont;
    if (!self.mAttributedMessage) {
        self.messageLabel.font = messageFont;
    }
}

- (void)setMDismissButtonTitle:(NSString *)dismissButtonTitle {
    _mDismissButtonTitle = dismissButtonTitle;
    self.dismissButton.titleLabel.text = dismissButtonTitle;
}

- (void)setMDismissButtonTintColor:(UIColor *)dismissButtonTintColor {
    _mDismissButtonTintColor = dismissButtonTintColor;
    self.dismissButton.tintColor = dismissButtonTintColor;
}

- (void)setDismissButtonImage:(UIImage *)image forState:(UIControlState)state {
    [self.dismissButton setImage:image forState:state];
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
                 onPressed:(void (^)(void))onPressed {
    YPAlertButton *button = [YPAlertButton buttonWithTitle:title style:style onPressed:onPressed];
    [self addButton:button];
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

- (void)addWarningButtonWithTitle:(NSString *)title
                        onPressed:(void (^)(void))onPressed {
    [self addButtonWithTitle:title
                       style:YPAlertButtonStyleWarning
                     onPressed:onPressed];
}

- (void)addFocusButtonWithTitle:(NSString *)title
                      onPressed:(void (^)(void))onPressed {
    [self addButtonWithTitle:title
                       style:YPAlertButtonStyleFocus
                     onPressed:onPressed];
}

- (void)setButtonHeight:(CGFloat)height forStyle:(YPAlertViewStyle)style {
    self.buttonHeightDict[@(style)] = @(height);
}

- (void)mShow {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [self mShowInView:window];
}

- (void)mShowInView:(UIView *)view {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (view == nil) {
        view = [UIApplication sharedApplication].windows.firstObject;
    }
    
    [view addSubview:self.maskView];
    [view addSubview:self];
    
    for (YPAlertButton *button in self.buttons) {
        button.isCorner = self.mStyle == YPAlertViewStyleCornerButton;
        [button update];
    }
    if (self.mStyle != YPAlertViewStyleCornerButton) {
        self.mButtonSpace = 0;
        self.mButtonEdgeInsets = UIEdgeInsetsZero;
    }
    
    [self layout];
    [self addSeperators];
    
    if (self.mStyle == YPAlertViewStyleActionSheet) {
        self.mTapBgToDismiss = YES;
        self.mAlertCornerRadius = 0;
        
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
    
    if (self.mStyle == YPAlertViewStyleActionSheet) {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.superview);
            make.top.equalTo(self.superview.mas_bottom);
        }];
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.maskView.alpha = 0;
        if (self.mStyle == YPAlertViewStyleActionSheet) {
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

- (void)setMCustomView:(UIView *)view height:(CGFloat)height {
    self.mCustomView = view;
    self.customViewHeight = height;
}

- (void)setMCustomView:(UIView *)customView {
    _mCustomView = customView;
    [self addSubview: customView];
}

#pragma mark - 内部方法

- (void)_setup {
    _buttons = [NSMutableArray array];
    
    _mTitleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    _mMessageEdgeInsets = UIEdgeInsetsMake(20, 15, 20, 15);
    _mCustomViewEdgeInsets = UIEdgeInsetsZero;
    
    _mAlertViewWidth = 300;
    _mButtonSpace = 10;
    _mButtonEdgeInsets = UIEdgeInsetsMake(0, 20, 10, 20);
    
    _mSeparatorColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    _mTitleSeparatorHeight = @([YPAlertView onePixel]);
    _mMarginKeyboard = 10;
    
    NSDictionary *dict = @{@(YPAlertViewStyleSystem) : @44,
                           @(YPAlertViewStyleCornerButton) : @40,
                           @(YPAlertViewStyleActionSheet) : @60};
    _buttonHeightDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    _mDismissButtonWidth = 44;
    
    [self initViews];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.messageLabel.font = [UIFont systemFontOfSize:16];
    
    [self addKeyboardObserver];
}

- (void)setMTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    _mTitleEdgeInsets = titleEdgeInsets;
}

- (void)initViews {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.mAlertCornerRadius = 10;
    
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
    if (self.mTapBgToDismiss) {
        [self dismiss];
    }
}

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _dismissButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_dismissButton setTitle:self.mDismissButtonTitle forState:UIControlStateNormal];
        [_titleView addSubview:_dismissButton];
    }
    return _dismissButton;
}

- (void)layout {
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.superview);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.mStyle == YPAlertViewStyleActionSheet) {
            make.left.right.equalTo(self.superview);
            make.top.equalTo(self.superview.mas_bottom);
        } else {
            make.width.equalTo(@(self.mAlertViewWidth));
            make.center.equalTo(self.superview);
        }
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if (self.titleLabel.text) {
            insets = self.mTitleEdgeInsets;
        }
        if (self.showDismissButton) {
            insets.left += self.mDismissButtonWidth + 10;
            insets.right += self.mDismissButtonWidth + 10;
        }
        make.edges.equalTo(self.titleView).insets(insets);
    }];
    
    if (self.mShowDismissButton) {
        [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.width.mas_equalTo(self.mDismissButtonWidth);
            CGFloat titleTextHeight = [self heightForString:@"标题" font:self.titleLabel.font];
            make.height.mas_equalTo(titleTextHeight + self.mTitleEdgeInsets.top + self.mTitleEdgeInsets.bottom);
        }];
    }
    
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom).offset(self.mTitleSeparatorHeight.floatValue);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if (self.messageLabel.text) {
            insets = self.mMessageEdgeInsets;
        }
        make.edges.equalTo(self.messageView).insets(insets);
    }];
    
    UIView *buttonTopView = self.messageView;
    if (self.mCustomView) {
        buttonTopView = self.mCustomView;
        [self.mCustomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.messageView.mas_bottom).offset(self.mCustomViewEdgeInsets.top);
            make.left.equalTo(self).offset(self.mCustomViewEdgeInsets.left);
            make.right.equalTo(self).offset(-self.mCustomViewEdgeInsets.right);
            if (self.customViewHeight > 0) {
                make.height.mas_equalTo(self.customViewHeight);
            }
        }];
    }
    
    if (self.buttons.count > 1) {
        if (self.mButtonVertical || self.mStyle == YPAlertViewStyleActionSheet) {
            [self.buttons mas_distributeViewsAlongAxis:MASAxisTypeVertical
                                      withFixedSpacing:self.mButtonSpace
                                           leadSpacing:0
                                           tailSpacing:0];
            [self.buttons mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.buttonsView);
                make.height.equalTo(self.buttonHeightDict  [@(self.mStyle)]);
            }];
        } else {
            [self.buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                                      withFixedSpacing:self.mButtonSpace
                                           leadSpacing:0
                                           tailSpacing:0];
            [self.buttons mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.buttonsView);
                make.height.mas_equalTo(self.buttonHeightDict  [@(self.mStyle)]);
            }];
        }
    } else {
        YPAlertButton *button = self.buttons.firstObject;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.buttonsView);
            make.height.mas_equalTo(self.buttonHeightDict  [@(self.mStyle)]);
        }];
    }
    
    CGFloat bottom = 0;
    if (self.mStyle == YPAlertViewStyleActionSheet && iPhoneXSeries) {
        bottom = -34;
    }
    CGFloat top = self.mButtonEdgeInsets.top;
    if (self.customView) {
        top += self.mCustomViewEdgeInsets.bottom;
    }
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(self.mButtonEdgeInsets.left);
        make.top.equalTo(buttonTopView.mas_bottom).offset(top);
        make.right.equalTo(self).offset(-self.mButtonEdgeInsets.right);
        make.bottom.equalTo(self).offset(bottom - self.mButtonEdgeInsets.bottom);
    }];
}

- (void)addSeperators {
    CGFloat onePixel = [YPAlertView onePixel];
    
    if (self.mStyle != YPAlertViewStyleCornerButton) {
        for (YPAlertButton *button in self.buttons) {
            [self addLineInView:button layout:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(button);
                make.height.equalTo(@(onePixel));
            }];
            if (!self.mButtonVertical && ![button isEqual:self.buttons.firstObject]) {
                [self addLineInView:button layout:^(MASConstraintMaker *make) {
                    make.left.top.bottom.equalTo(button);
                    make.width.equalTo(@(onePixel));
                }];
            }
        }
    }
    
    if (self.mTitleSeparatorHeight.floatValue > 0) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = self.mSeparatorColor;
        [self.titleView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.titleView);
            make.height.equalTo(@(self.mTitleSeparatorHeight.floatValue));
        }];
    }
}

- (void)addLineInView:(UIView *)view layout:(void(NS_NOESCAPE ^)(MASConstraintMaker *make))block {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = self.mSeparatorColor;
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

- (void)addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.mMoveFollowKeyboard) return;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration;
    [durationValue getValue:&duration];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.mAlertViewWidth));
        make.centerX.equalTo(self.superview);
        make.bottom.equalTo(self.superview).offset(-keyboardRect.size.height - self.mMarginKeyboard);
    }];
    [UIView animateWithDuration:duration animations:^{
        [self.superview layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (!self.mMoveFollowKeyboard) return;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration;
    [animationDurationValue getValue:&duration];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.mAlertViewWidth));
        make.center.equalTo(self.superview);
    }];
    [UIView animateWithDuration:duration animations:^{
        [self.superview layoutIfNeeded];
    }];
}

- (void)dealloc {
    [self removeKeyboardObserver];
}

- (CGFloat)heightForString:(NSString *)string font:(UIFont *)font {
    if (!font) {
        return 0;
    }
    NSMutableDictionary *attr = [[NSMutableDictionary alloc] init];
    attr[NSFontAttributeName] = font;
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attr context:nil];
    return rect.size.height;
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
        [alert addButtonWithTitle:cancelButtonTitle style:YPAlertButtonStyleCancel onPressed:^{
            if (onPressed) {
                onPressed(NO);
            }
        }];
    }
    if (okButtonTitle) {
        [alert addButtonWithTitle:okButtonTitle style:YPAlertButtonStyleFocus onPressed:^{
            if (onPressed) {
                onPressed(YES);
            }
        }];
    }
    [alert mShow];
    return alert;
}

@end


YPAlertView * YPAlert(void) {
    return [[YPAlertView alloc] init];
};

@implementation YPAlertView (Chain)

- (YPAlertView *(^)(NSString *, void (^)(NSMutableAttributedString *)))attrTitleBlock {
    return ^YPAlertView *(NSString *title, void (^block)(NSMutableAttributedString *)) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
        if (block) {
            block(attr);
        }
        self.mAttributedTitle = attr;
        return self;
    };
}

- (YPAlertView *(^)(NSString *, void (^)(NSMutableAttributedString *)))attrMessageBlock {
    return ^YPAlertView *(NSString *message, void (^block)(NSMutableAttributedString *)) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:message];
        if (block) {
            block(attr);
        }
        self.mAttributedMessage = attr;
        return self;
    };
}


ChainSetterImp(NSString *, title, setMTitle)
ChainSetterImp(NSString *, message, setMMessage)
ChainSetterImp(NSAttributedString *, attributedTitle, setMAttributedTitle)
ChainSetterImp(NSAttributedString *, attributedMessage, setMAttributedMessage)
ChainSetterImp(YPAlertViewStyle, style, setMStyle)
ChainSetterImp(UIEdgeInsets, titleEdgeInsets, setMTitleEdgeInsets)
ChainSetterImp(UIEdgeInsets, messageEdgeInsets, setMMessageEdgeInsets)
ChainSetterImp(UIEdgeInsets, customViewEdgeInsets, setMCustomViewEdgeInsets)
ChainSetterImp(UIEdgeInsets, buttonEdgeInsets, setMButtonEdgeInsets)
ChainSetterImp(CGFloat, buttonSpace, setMButtonSpace)
ChainSetterImp(BOOL, buttonVertical, setMButtonVertical)
ChainSetterImp(BOOL, moveFollowKeyboard, setMMoveFollowKeyboard)
ChainSetterImp(CGFloat, marginKeyboard, setMMarginKeyboard)

ChainSetterImp(CGFloat, alertViewWidth, setMAlertViewWidth)
ChainSetterImp(CGFloat, alertCornerRadius, setMAlertCornerRadius)
ChainSetterImp(UIImage *, titleBgImage, setMTitleBgImage)
ChainSetterImp(UIColor *, titleBgColor, setMTitleBgColor)
ChainSetterImp(UIColor *, titleColor, setMTitleColor)
ChainSetterImp(UIFont *, titleFont, setMTitleFont)
ChainSetterImp(UIColor *, messageColor, setMMessageColor)
ChainSetterImp(UIFont *, messageFont, setMMessageFont)
ChainSetterImp(UIColor *, separatorColor, setMSeparatorColor)
ChainSetterImp(NSNumber *, titleSeparatorHeight, setMTitleSeparatorHeight)
ChainSetterImp(BOOL, tapBgToDismiss, setMTapBgToDismiss)
ChainSetterImp(BOOL, showDismissButton, setMShowDismissButton)
ChainSetterImp(NSString *, dismissButtonTitle, setMDismissButtonTitle)
ChainSetterImp(UIColor *, dismissButtonTintColor, setMDismissButtonTintColor)
ChainSetterImp(CGFloat, dismissButtonWidth, setMDismissButtonWidth)
ChainSetterImp(UIView *, customView, setMCustomView)

- (YPAlertView *(^)(void (^)(UILabel *)))configTitleLabel {
    return ^YPAlertView *(void (^block)(UILabel *)) {
        if (block) {
            block(self.titleLabel);
        }
        return self;
    };
}

- (YPAlertView *(^)(void (^)(UILabel *)))configMessageLabel {
    return ^YPAlertView *(void (^block)(UILabel *)) {
        if (block) {
            block(self.messageLabel);
        }
        return self;
    };
}

- (YPAlertView *(^)(CGFloat, UIControlState))buttonHeight {
    return ^YPAlertView *(CGFloat height, UIControlState state) {
        [self setButtonHeight:height forStyle:state];
        return self;
    };
}

- (YPAlertView *(^)(UIImage *, UIControlState))dismissButtonImage {
    return ^YPAlertView *(UIImage *image, UIControlState state) {
        [self setDismissButtonImage:image forState:state];
        return self;
    };
}

- (YPAlertView *(^)(UIView *, CGFloat))customViewWithHeight {
    return ^YPAlertView *(UIView *view, CGFloat height) {
        [self setMCustomView:view height:height];
        return self;
    };
}

- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))addDefaultButton {
    return ^YPAlertView *(NSString *title, void (^onPressed)(void)) {
        [self addButtonWithTitle:title style:YPAlertButtonStyleDefault onPressed:onPressed];
        return self;
    };
}

- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))addCancelButton {
    return ^YPAlertView *(NSString *title, void (^onPressed)(void)) {
        [self addButtonWithTitle:title style:YPAlertButtonStyleCancel onPressed:onPressed];
        return self;
    };
}

- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))addWarningButton {
    return ^YPAlertView *(NSString *title, void (^onPressed)(void)) {
        [self addButtonWithTitle:title style:YPAlertButtonStyleWarning onPressed:onPressed];
        return self;
    };
}

- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))addFocusButton {
    return ^YPAlertView *(NSString *title, void (^onPressed)(void)) {
        [self addButtonWithTitle:title style:YPAlertButtonStyleFocus onPressed:onPressed];
        return self;
    };
}

- (YPAlertView *(^)(NSString *, YPAlertButtonStyle, BOOL autoDismiss, void (^)(void)))addButton {
    return ^YPAlertView *(NSString *title, YPAlertButtonStyle style, BOOL autoDismiss, void (^onPressed)(void)) {
        YPAlertButton *button = [YPAlertButton buttonWithTitle:title style:style onPressed:onPressed];
        button.autoDismiss = autoDismiss;
        [self addButton:button];
        return self;
    };
}

- (YPAlertView *(^)(void))show {
    return ^YPAlertView *(void) {
        [self mShow];
        return self;
    };
}

- (YPAlertView *(^)(UIView *))showInView {
    return ^YPAlertView *(UIView *view) {
        [self mShowInView:view];
        return self;
    };
}

@end
