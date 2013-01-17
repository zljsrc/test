//
//  DelegateViewController.h
//  iOS_Study
//
//  Created by zhangling on 13-1-6.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestProcotol.h"

@interface DelegateViewController : UIViewController <UIAlertViewDelegate>

@property(strong, nonatomic) IBOutlet UIButton *delegateButton;
@property(strong, nonatomic) IBOutlet UIButton *alertButton;

@property(assign) id<TestProcotol> delegate;

@end
