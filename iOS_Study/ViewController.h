//
//  ViewController.h
//  iOS_Study
//
//  Created by zhangling on 13-1-4.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NurseViewController.h"
#import "DelegateViewController.h"
#import "TestProcotol.h"
#import "PickerViewController.h"
#import "CustomPickerViewController.h"

@interface ViewController : UIViewController <TestProcotol> {
    NurseViewController *nurseViewController;
}

@property (strong, nonatomic) NurseViewController *nurseViewController;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *nurseViewButtion;
@property (strong, nonatomic) IBOutlet UIButton *delegateViewButton;
@property (strong, nonatomic) IBOutlet UIButton *pickerViewButton;
@property (strong, nonatomic) IBOutlet UIButton *customPickerViewButton;

- (IBAction)selectTableView: (id)sender;
- (IBAction)selectDelegateView:(id)sender;

@end
