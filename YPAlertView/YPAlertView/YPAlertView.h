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

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSAttributedString *attributedTitle;
@property (nonatomic, copy) NSAttributedString *attributedMessage;

@property (nonatomic, assign) YPAlertViewStyle style;

@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets messageEdgeInsets UI_APPEARANCE_SELECTOR;

// 以下2个属性仅在style == YPAlertViewStyleCornerButton时生效
@property (nonatomic, assign) UIEdgeInsets buttonEdgeInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat buttonSpace UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) BOOL buttonVertical UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat alertViewWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat alertCornerRadius UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIImage *titleBgImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleBgColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *messageColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *separatorColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *titleSeparatorHeight UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) BOOL tapBgToDismiss UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) BOOL showDismissButton UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIView *customView;


+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message;

+ (instancetype)alertWithTitle:(NSString *)title
             attributedMessage:(NSAttributedString *)message;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message;

- (instancetype)initWithTitle:(NSString *)title
            attributedMessage:(NSAttributedString *)message;

- (void)setButtonHeight:(CGFloat)height forStyle:(YPAlertViewStyle)style UI_APPEARANCE_SELECTOR;

- (void)addButton:(YPAlertButton *)button;
- (void)addDefaultButtonWithTitle:(NSString *)title
                        onPressed:(void (^)(void))onPressed;
- (void)addDestructiveButtonWithTitle:(NSString *)title
                            onPressed:(void (^)(void))onPressed;
- (void)addCancelButtonWithTitle:(NSString *)title
                       onPressed:(void (^)(void))onPressed;
- (void)addFocusButtonWithTitle:(NSString *)title
                      onPressed:(void (^)(void))onPressed;
- (void)addButtonWithTitle:(NSString *)title
                     style:(YPAlertButtonStyle)style
                 onPressed:(void (^)(void))onPressed;

- (void)setCustomView:(UIView *)view height:(CGFloat)height;

- (void)show;
- (void)showInView:(UIView *)view;

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

- (YPAlertView *(^)(NSString *title))s_title;
- (YPAlertView *(^)(NSString *message))s_message;

- (YPAlertView *(^)(NSAttributedString *title))s_attributedTitle;
- (YPAlertView *(^)(NSAttributedString *message))s_attributedMessage;

/// 这两个方法是用来做快速自定义的
- (YPAlertView *(^)(NSString *title, void (^)(NSMutableAttributedString *attr)))s_attrTitleBlock;
- (YPAlertView *(^)(NSString *message, void (^)(NSMutableAttributedString *attr)))s_attrMessageBlock;

- (YPAlertView *(^)(YPAlertViewStyle style))s_style;

- (YPAlertView *(^)(UIEdgeInsets insets))s_titleEdgeInsets;
- (YPAlertView *(^)(UIEdgeInsets insets))s_messageEdgeInsets;

// 按钮部分的insets，只在style == YPAlertViewStyleCornerButton时生效
- (YPAlertView *(^)(UIEdgeInsets insets))s_buttonEdgeInsets;
// 按钮间的间隔，只在style == YPAlertViewStyleCornerButton时生效
- (YPAlertView *(^)(CGFloat num))s_buttonSpace;

// 按钮排列方向
- (YPAlertView *(^)(BOOL b))s_buttonVertical;

- (YPAlertView *(^)(CGFloat num))s_alertViewWidth;
- (YPAlertView *(^)(CGFloat num))s_alertCornerRadius;

- (YPAlertView *(^)(UIImage *image))s_titleBgImage;
- (YPAlertView *(^)(UIColor *color))s_titleBgColor;
- (YPAlertView *(^)(UIColor *color))s_titleColor;
- (YPAlertView *(^)(UIFont *font))s_titleFont;

- (YPAlertView *(^)(UIColor *color))s_messageColor;
- (YPAlertView *(^)(UIFont *font))s_messageFont;

// 按钮分割线颜色
- (YPAlertView *(^)(UIColor *color))s_separatorColor;

// 标题下方的分割线颜色
- (YPAlertView *(^)(NSNumber *num))s_titleSeparatorHeight;

// 点击背景部分关闭Alert，YPAlertViewStyleActionSheet默认为NO，其他为YES
- (YPAlertView *(^)(BOOL b))s_tapBgToDismiss;

// 是否在右上角显示关闭按钮
- (YPAlertView *(^)(BOOL b))s_showDismissButton;

- (YPAlertView *(^)(UIView *view))s_customView;

- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))s_addDefaultButton;
- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))s_addCancelButton;
- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))s_addDestructiveButton;
- (YPAlertView *(^)(NSString *title, void (^onPressed)(void)))s_addFocusButton;
- (YPAlertView *(^)(NSString *title, YPAlertButtonStyle style, void (^onPressed)(void)))s_addButton;

- (YPAlertView *(^)(void))s_show;
- (YPAlertView *(^)(UIView *view))s_showInView;

@end
