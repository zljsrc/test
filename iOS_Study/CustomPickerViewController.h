//
//  CustomPickerViewController.h
//  iOS_Study
//
//  Created by zhangling on 13-1-7.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPickerViewController : UIViewController

@property(strong,nonatomic) IBOutlet UILabel *selectedShowLabel;

@property(retain,nonatomic) NSMutableArray *years;

@property(retain,nonatomic) NSMutableArray *months;

@end
