//
//  TextViewController.m
//  iOS_Study
//
//  Created by zhangling on 13-1-21.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()

@end

@implementation TextViewController

@synthesize textView = _textView;
@synthesize textViewDelegate = _textViewDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textViewDelegate = [[[TextViewDelegate alloc]init] autorelease];
    self.textView.delegate = self.textViewDelegate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
