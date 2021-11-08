//
//  YPAlertView.h
//  YPAlertView
//
//  Created by 喻平 on 2018/4/24.
//  Copyright © 2018年 com.yp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPAlertButton.h"

typedef NS_ENUM(NSInteger, YPAlertViewStyle) {
    YPAlertViewStyleSystem,
    YPAlertViewStyleCornerButton,
    YPAlertViewStyleActionSheet,
};

@interface YPAlertView : UIView

@property (nonatomic, strong, readonly) UIImageView *maskView;

@property (nonatomic, strong, readonly) UIImageView *titleBgImageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, readonly) UIButton *dismissButton;

@property (nonatomic, strong, readonly) NSMutableArray <YPAlertButton *> *buttons;

@property (nonatomic, copy) NSString *mTitle;
@property (nonatomic, copy) NSString *mMessage;

@property (nonatomic, copy) NSAttributedString *mAttributedTitle;
@property (nonatomic, copy) NSAttributedString *mAttributedMessage;

@property (nonatomic, assign) YPAlertViewStyle mStyle;

@property (nonatomic, assign) UIEdgeInsets mTitleEdgeInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets mMessageEdgeInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets mCustomViewEdgeInsets UI_APPEARANCE_SELECTOR;

// 以下2个属性仅在style == YPAlertViewStyleCornerButton时生效
@property (nonatomic, assign) UIEdgeInsets mButtonEdgeInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat mButtonSpace UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) BOOL mButtonVertical UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat mAlertViewWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat mAlertCornerRadius UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIImage *mTitleBgImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *mTitleBgColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *mTitleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *mTitleFont UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *mMessageColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *mMessageFont UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *mSeparatorColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *mTitleSeparatorHeight UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat mMarginKeyboard UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat mMoveFollowKeyboard UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) BOOL mTapBgToDismiss UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) BOOL mShowDismissButton UI_APPEARANCE_SELECTOR;
@property (nonatomic, copy) NSString *mDismissButtonTitle UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *mDismissButtonTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat mDismissButtonWidth UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIView *mCustomView;


+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message;

+ (instancetype)alertWithTitle:(NSString *)title
             attributedMessage:(NSAttributedString *)message;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message;

- (instancetype)initWithTitle:(NSString *)title
            attributedMessage:(NSAttributedString *)message;

- (void)setButtonHeight:(CGFloat)height forStyle:(YPAlertViewStyle)style UI_APPEARANCE_SELECTOR;
- (void)setDismissButtonImage:(UIImage *)image forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (void)addButton:(YPAlertButton *)button;
- (void)addButtonWithTitle:(NSString *)title
                     style:(YPAlertButtonStyle)style
                 onPressed:(void (^)(void))onPressed;
- (void)addDefaultButtonWithTitle:(NSString *)title
                        onPressed:(void (^)(void))onPressed;
- (void)addCancelButtonWithTitle:(NSString *)title
                       onPressed:(void (^)(void))onPressed;
- (void)addWarningButtonWithTitle:(NSString *)title
                        onPressed:(void (^)(void))onPressed;
- (void)addFocusButtonWithTitle:(NSString *)title
                      onPressed:(void (^)(void))onPressed;


- (void)setMCustomView:(UIView *)view height:(CGFloat)height;

- (void)mShow;
- (void)mShowInView:(UIView *)view;

- (void)dismiss;
- (void)dismissWithCompletion:(void (^)(void))completion;

@end


YPAlertView * YPAlert(void);

@interface YPAlertView (Add)

/// 以下4个快速方法将废弃
+ (instancetype)showWithTitle:(NSString *)title;

+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message;

+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
                okButtonTitle:(NSString *)okButtonTitle
              okButtonClicked:(void (^)(void))okButtonClicked;

+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
                okButtonTitle:(NSString *)okButtonTitle
                      onPressed:(void (^)(BOOL isOkButton))onPressed;

@end

/**
 * 此分类里的方法主要是采用链式语法进行Alert的初始化
 */
@interface YPAlertView (Chain)

- (YPAlertView *(^)(NSString *title))title;
- (YPAlertView *(^)(NSString *message))message;

- (YPAlertView *(^)(NSAttributedString *title))attributedTitle;
- (YPAlertView *(^)(NSAttributedString *message))attributedMessage;

/// 这两个方法是用来做快速自定义的
- (YPAlertView *(^)(NSString *title, void (^)(NSMutableAttributedString *attr)))attrTitleBlock;
- (YPAlertView *(^)(NSString *message, void (^)(NSMutableAttributedString *attr)))attrMessageBlock;

- (YPAlertView *(^)(YPAlertViewStyle style))style;

- (YPAlertView *(^)(UIEdgeInsets insets))titleEdgeInsets;
- (YPAlertView *(^)(UIEdgeInsets insets))messageEdgeInsets;
- (YPAlertView *(^)(UIEdgeInsets insets))customViewEdgeInsets;

// 按钮部分的insets，只在style == YPAlertViewStyleCornerButton时生效
- (YPAlertView *(^)(UIEdgeInsets insets))buttonEdgeInsets;
// 按钮间的间隔，只在style == YPAlertViewStyleCornerButton时生效
- (YPAlertView *(^)(CGFloat space))buttonSpace;
// 按钮排列方向
- (YPAlertView *(^)(BOOL b))buttonVertical;
- (YPAlertView *(^)(CGFloat height, UIControlState state))buttonHeight;

// 是否跟着键盘移动
- (YPAlertView *(^)(BOOL b))moveFollowKeyboard;
// 底部底部与键盘的距离
- (YPAlertView *(^)(CGFloat space))marginKeyboard;

- (YPAlertView *(^)(CGFloat width))alertViewWidth;
- (YPAlertView *(^)(CGFloat radius))alertCornerRadius;

- (YPAlertView *(^)(UIImage *image))titleBgImage;
- (YPAlertView *(^)(UIColor *color))titleBgColor;
- (YPAlertView *(^)(UIColor *color))titleColor;
- (YPAlertView *(^)(UIFont *font))titleFont;
- (YPAlertView *(^)(void (^)(UILabel *label)))configTitleLabel;

- (YPAlertView *(^)(UIColor *color))messageColor;
- (YPAlertView *(^)(UIFont *font))messageFont;
- (YPAlertView *(^)(void (^)(UILabel *label)))configMessageLabel;

// 按钮分割线颜色
- (YPAlertView *(^)(UIColor *color))separatorColor;

// 标题下方的分割线颜色
- (YPAlertView *(^)(NSNumber *num))titleSeparatorHeight;

// 点击背景部分关闭Alert，YPAlertViewStyleActionSheet默认为NO，其他为YES
- (YPAlertView *(^)(BOOL b))tapBgToDismiss;

// 右上角显示关闭按钮设置
- (YPAlertView *(^)(BOOL b))showDismissButton;
- (YPAlertView *(^)(NSString *))dismissButtonTitle;
- (YPAlertView *(^)(UIColor *))dismissButtonTintColor;
- (YPAlertView *(^)(CGFloat))dismissButtonWidth;
- (YPAlertView *(^)(UIImage *image, UIControlState state))dismissButtonImage;

- (YPAlertView *(^)(UIView *view))customView;
- (YPAlertView *(^)(UIView *view, CGFloat height))customViewWithHeight;

- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))addDefaultButton;
- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))addCancelButton;
- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))addWarningButton;
- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))addFocusButton;
- (YPAlertView *(^)(void(^config)(YPAlertButton *button)))addButton;

- (YPAlertView *(^)(void))show;
- (YPAlertView *(^)(UIView *view))showInView;

@end
