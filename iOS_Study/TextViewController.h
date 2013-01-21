//
//  TextViewController.h
//  iOS_Study
//
//  Created by zhangling on 13-1-21.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextViewDelegate.h"

@interface TextViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) TextViewDelegate *textViewDelegate;

@end
