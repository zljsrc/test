//
//  PickerViewController.m
//  iOS_Study
//
//  Created by zhangling on 13-1-6.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()

@end

@implementation PickerViewController

@synthesize showLabel = _showLabel;
@synthesize pickerView = _pickerView;

- (void)dealloc
{
    [self.pickerView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"PickerView演示";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];[backButton setFrame:CGRectMake(0, 0, 44, 32)];
    [backButton setImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
    [backBarButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//PickerView显示控制
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //该方法来自协议<UIPickerViewDataSource>
    //该方法用来确定pickerView有几个component;
    return 2;
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //该方法来自协议<UIPickerViewDataSource>
    //该方法来确定每一个component中有多少个row，即多少行
    //可以理解为每一个竖排中有多少个横排。
    
    if (component==0) {
        return 200;
    } else {
        return 12;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //该方法来自协议<UIPickerViewDelegate>
    //三个参数，第一个参数表示确定是哪一个pickerView
    //第二个参数表示哪一行
    //第三个参数表示哪一个component。
    
    if (component==0) {
        NSString *str = [[[NSString alloc] initWithFormat:@"%d年", row+PICKERVIEWCONTROLLER_START_YEAR] autorelease];
        return str;
    }
    else {
        NSString *str = [[[NSString alloc] initWithFormat:@"%d月", row+1] autorelease];
        return str;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    int year = [self.pickerView selectedRowInComponent:0];
    int month = [self.pickerView selectedRowInComponent:1] + 1;
    [self.showLabel setText:[NSString stringWithFormat:@"%d年%d月", year+PICKERVIEWCONTROLLER_START_YEAR, month]];
}

@end
