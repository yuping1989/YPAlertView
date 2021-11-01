//
//  ViewController.m
//  YPAlertView
//
//  Created by 喻平 on 2018/4/24.
//  Copyright © 2018年 com.yp. All rights reserved.
//

#import "ViewController.h"
#import "YPAlertView.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UISegmentedControl *styleSegmentedControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)noTitle:(id)sender {
    YPAlertView *alert = [[YPAlertView alloc] initWithTitle:nil message:@"内容"];
    YPAlertButton *cancelButton = [YPAlertButton buttonWithTitle:@"取消" style:YPAlertButtonStyleCancel onPressed:^ {
        
    }];
    alert.mTapBgToDismiss = YES;
    alert.mStyle = self.styleSegmentedControl.selectedSegmentIndex;
    
    [alert mAddButton:cancelButton];
    
    if (alert.mStyle == YPAlertViewStyleCornerButton) {
        for (YPAlertButton *button in alert.buttons) {
            button.backgroundColor = [UIColor lightGrayColor];
        }
        alert.mButtonSpace = 8;
        alert.mButtonEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 10);
    }
    
    [alert mShow];
}

- (IBAction)noMessage:(id)sender {
    YPAlertView *alert = [[YPAlertView alloc] initWithTitle:@"标题" message:nil];
    YPAlertButton *cancelButton = [YPAlertButton buttonWithTitle:@"取消" style:YPAlertButtonStyleCancel onPressed:^ {
        
    }];
    alert.mTitleBgColor = [UIColor lightGrayColor];
    alert.mStyle = self.styleSegmentedControl.selectedSegmentIndex;
    
    [alert mAddButton:cancelButton];
    
    if (alert.mStyle == YPAlertViewStyleCornerButton) {
        for (YPAlertButton *button in alert.buttons) {
            button.backgroundColor = [UIColor lightGrayColor];
        }
        alert.mButtonSpace = 8;
        alert.mButtonEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    
    [alert mShow];
}

- (IBAction)oneButton:(id)sender {
    YPAlertView *alert = [[YPAlertView alloc] initWithTitle:@"标题" message:@"内容"];
    YPAlertButton *cancelButton = [YPAlertButton buttonWithTitle:@"取消" style:YPAlertButtonStyleCancel onPressed:^ {
        
    }];
    [alert mAddButton:cancelButton];
    
    alert.mStyle = self.styleSegmentedControl.selectedSegmentIndex;
    alert.mTapBgToDismiss = YES;
    [alert mShowInView:self.view];
}

- (IBAction)twoButton:(id)sender {
    YPAlert()
    .title(@"标题")
    .message(@"内容")
    .addCancelButton(@"取消", nil)
    .addFocusButton(@"确定", ^{
        
    })
    .style(self.styleSegmentedControl.selectedSegmentIndex)
    .show();
}


- (IBAction)threeButton:(id)sender {
    
    YPAlert()
    .attrTitleBlock(@"这是一个富文本标题", ^(NSMutableAttributedString *attr) {
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 3)];
    })
    .attrMessageBlock(@"这是一个富文本内容", ^(NSMutableAttributedString *attr) {
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(3, 3)];
    })
    .addCancelButton(@"取消", nil)
    .addButton(@"警告", YPAlertButtonStyleWarning, NO, ^{
        
    })
    .addFocusButton(@"确定", ^{
        
    })
    .buttonVertical(YES)
    .style(self.styleSegmentedControl.selectedSegmentIndex)
    .show();
    
}

@end
