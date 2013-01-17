//
//  PickerViewController.h
//  iOS_Study
//
//  Created by zhangling on 13-1-6.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import <UIKit/UIKit.h>

static const int PICKERVIEWCONTROLLER_START_YEAR = 1900;

@interface PickerViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *showLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end
