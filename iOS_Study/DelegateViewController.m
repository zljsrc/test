//
//  DelegateViewController.m
//  iOS_Study
//
//  Created by zhangling on 13-1-6.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import "DelegateViewController.h"

@interface DelegateViewController ()

@end

@implementation DelegateViewController

@synthesize delegate = _delegate;
@synthesize delegateButton = _delegateButton;
@synthesize alertButton = _alertButton;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeButtonText:(id)sender
{
    [self.delegate changeButtionText:@"代理模式修改文案"];
    
    if ([self.delegateButton respondsToSelector:@selector(changeViewTitle:)]) {
        [self.delegateButton changeViewTitle: @"代理模式修改Title"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showAlertView:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改Button上的文案？？？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [_alertButton setTitle:@"同意修改" forState:UIControlStateNormal];
    }
    else {
        [_alertButton setTitle:@"不同意修改" forState:UIControlStateNormal];
    }
}
@end
