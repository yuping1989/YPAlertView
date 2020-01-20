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
    YPAlertButton *cancelButton = [YPAlertButton buttonWithTitle:@"取消" style:YPAlertButtonStyleCancel handler:^(YPAlertButton *button) {
        
    }];
    alert.tapBgToDismiss = YES;
    alert.style = self.styleSegmentedControl.selectedSegmentIndex;
    [alert addButton:cancelButton];
    [alert show];
}

- (IBAction)noMessage:(id)sender {
    YPAlertView *alert = [[YPAlertView alloc] initWithTitle:@"标题" message:nil];
    YPAlertButton *cancelButton = [YPAlertButton buttonWithTitle:@"取消" style:YPAlertButtonStyleCancel handler:^(YPAlertButton *button) {
        
    }];
    alert.titleBgColor = [UIColor lightGrayColor];
    alert.style = self.styleSegmentedControl.selectedSegmentIndex;
    [alert addButton:cancelButton];
    [alert show];
}

- (IBAction)oneButton:(id)sender {
    YPAlertView *alert = [[YPAlertView alloc] initWithTitle:@"标题" message:@"内容"];
    YPAlertButton *cancelButton = [YPAlertButton buttonWithTitle:@"取消" style:YPAlertButtonStyleCancel handler:^(YPAlertButton *button) {
        
    }];
    [alert addButton:cancelButton];
    
    alert.style = self.styleSegmentedControl.selectedSegmentIndex;
    
    alert.buttonSpace = 8;
    alert.buttonsEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 10);
    for (YPAlertButton *button in alert.buttons) {
        button.backgroundColor = [UIColor lightGrayColor];
    }
    alert.tapBgToDismiss = YES;
    [alert show];
}

- (IBAction)twoButton:(id)sender {
    YPAlertView *alert = [[YPAlertView alloc] initWithTitle:@"标题" message:@"内容"];
    YPAlertButton *cancelButton = [YPAlertButton buttonWithTitle:@"取消" style:YPAlertButtonStyleCancel handler:^(YPAlertButton *button) {
        
    }];
    YPAlertButton *okButton = [YPAlertButton buttonWithTitle:@"确定" style:YPAlertButtonStyleDestructive handler:^(YPAlertButton *button) {
        
    }];
//    okButton.backgroundColor = [UIColor lightGrayColor];
    [alert addButton:cancelButton];
    [alert addButton:okButton];
    
    alert.buttonSpace = 8;
    alert.buttonsEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 10);
    alert.buttonCornerRadius = 5;
    
    alert.style = self.styleSegmentedControl.selectedSegmentIndex;
    [alert show];
}


- (IBAction)threeButton:(id)sender {
    YPAlertView *alert = [[YPAlertView alloc] initWithTitle:@"标题" message:@"内容"];
    alert.dismissButton.hidden = NO;
    YPAlertButton *okButton = [YPAlertButton buttonWithTitle:@"确定" style:YPAlertButtonStyleDestructive handler:^(YPAlertButton *button) {

    }];
    YPAlertButton *otherButton = [YPAlertButton buttonWithTitle:@"其他" style:YPAlertButtonStyleDefault handler:^(YPAlertButton *button) {

    }];
    YPAlertButton *cancelButton = [YPAlertButton buttonWithTitle:@"取消" style:YPAlertButtonStyleCancel handler:^(YPAlertButton *button) {
        
    }];
    
    [alert addButton:okButton];
    [alert addButton:otherButton];
    [alert addButton:cancelButton];
    
    for (YPAlertButton *button in alert.buttons) {
        button.backgroundColor = [UIColor lightGrayColor];
    }
    alert.buttonSpace = 8;
    alert.buttonsEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 10);
    
    alert.dismissButtonAppear = YES;
    alert.style = self.styleSegmentedControl.selectedSegmentIndex;
    
    [alert show];
}

@end
