//
//  YPAlertView.h
//  YPAlertView
//
//  Created by 喻平 on 2018/4/24.
//  Copyright © 2018年 com.yp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPAlertButton.h"

@interface YPAlertView : UIView

@property (nonatomic, strong, readonly) UIImageView *maskView;

@property (nonatomic, strong, readonly) UIImageView *titleBgImageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;

@property (nonatomic, strong, readonly) NSMutableArray <YPAlertButton *> *buttons;

@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets messageEdgeInsets UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat alertViewWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat alertButtonHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat alertCornerRadius UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIImage *titleBgImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleBgColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *messageColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *separatorColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIView *customView;


+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message;

+ (instancetype)alertWithTitle:(NSString *)title
             attributedMessage:(NSAttributedString *)message;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message;

- (instancetype)initWithTitle:(NSString *)title
            attributedMessage:(NSAttributedString *)message;

- (void)addButton:(YPAlertButton *)button;
- (void)addButtonWithTitle:(NSString *)title
                     style:(YPAlertButtonStyle)style
                   handler:(void (^)(YPAlertButton *button))handler;

- (void)setCustomView:(UIView *)view height:(CGFloat)height;

- (void)show;
- (void)showInView:(UIView *)view;

- (void)dismiss;
- (void)dismissWithCompletion:(void (^)(void))completion;

@end

@interface YPAlertView (Add)

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
                      handler:(void (^)(BOOL isOkButton))handler;

@end
