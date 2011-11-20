//
//  TextViewController.h
//  Test
//
//  Created by 岭 张 on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldDelegate.h"
#import "TextViewDelegate.h"

@interface TextViewController : UIViewController
{
    UITextField *title;
    UITextView *content;
    UIButton *submit;
    TextFieldDelegate *textFieldDelegate;
    TextViewDelegate *textViewDelegate;
}

@property (nonatomic,retain) IBOutlet UITextField *title;
@property (nonatomic,retain) IBOutlet UITextView *content;
@property (nonatomic,retain) IBOutlet UIButton *submit;

@end
