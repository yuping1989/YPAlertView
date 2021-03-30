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
    alert.tapBgToDismiss = YES;
    alert.style = self.styleSegmentedControl.selectedSegmentIndex;
    
    [alert addButton:cancelButton];
    
    if (alert.style == YPAlertViewStyleCornerButton) {
        for (YPAlertButton *button in alert.buttons) {
            button.backgroundColor = [UIColor lightGrayColor];
        }
        alert.buttonSpace = 8;
        alert.buttonEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 10);
    }
    
    [alert show];
}

- (IBAction)noMessage:(id)sender {
    YPAlertView *alert = [[YPAlertView alloc] initWithTitle:@"标题" message:nil];
    YPAlertButton *cancelButton = [YPAlertButton buttonWithTitle:@"取消" style:YPAlertButtonStyleCancel onPressed:^ {
        
    }];
    alert.titleBgColor = [UIColor lightGrayColor];
    alert.style = self.styleSegmentedControl.selectedSegmentIndex;
    
    [alert addButton:cancelButton];
    
    if (alert.style == YPAlertViewStyleCornerButton) {
        for (YPAlertButton *button in alert.buttons) {
            button.backgroundColor = [UIColor lightGrayColor];
        }
        alert.buttonSpace = 8;
        alert.buttonEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    
    [alert show];
}

- (IBAction)oneButton:(id)sender {
    YPAlertView *alert = [[YPAlertView alloc] initWithTitle:@"标题" message:@"内容"];
    YPAlertButton *cancelButton = [YPAlertButton buttonWithTitle:@"取消" style:YPAlertButtonStyleCancel onPressed:^ {
        
    }];
    [alert addButton:cancelButton];
    
    alert.style = self.styleSegmentedControl.selectedSegmentIndex;
    alert.tapBgToDismiss = YES;
    [alert showInView:self.view];
}

- (IBAction)twoButton:(id)sender {
    YPAlert()
    .s_title(@"标题")
    .s_message(@"内容")
    .s_addCancelButton(@"取消", nil)
    .s_addFocusButton(@"确定", ^{
        
    })
    .s_style(self.styleSegmentedControl.selectedSegmentIndex)
    .s_show();
}


- (IBAction)threeButton:(id)sender {
    
    YPAlert()
    .s_title(@"标题")
    .s_message(@"内容")
    .s_addCancelButton(@"取消", nil)
    .s_addDestructiveButton(@"警告", ^{
        
    })
    .s_addFocusButton(@"确定", ^{
        
    })
    .s_buttonVertical(YES)
    .s_style(self.styleSegmentedControl.selectedSegmentIndex)
    .s_show();
    
}

@end
