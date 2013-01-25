//
//  ViewController.m
//  iOS_Study
//
//  Created by zhangling on 13-1-4.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import "ViewController.h"
#import "TextViewController.h"
#import "MobClick.h"
#import "ASILogViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize scrollView = _scrollView;
@synthesize nurseViewController = _nurseViewController;
@synthesize nurseViewButtion = _nurseViewButtion;
@synthesize delegateViewButton = _delegateViewButton;
@synthesize pickerViewButton = _pickerViewButton;
@synthesize customPickerViewButton = _customPickerViewButton;

- (void)dealloc
{
    [self.nurseViewController release];
    [self.scrollView release];
    [self.nurseViewButtion release];
    [self.delegateViewButton release];
    [self.pickerViewButton release];
    [self.customPickerViewButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"功能选择";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg"] forBarMetrics:UIBarMetricsDefault];
    } else {
        CALayer *navLayer = self.navigationController.navigationBar.layer;
        navLayer.masksToBounds = NO;
        navLayer.shadowColor = [UIColor blackColor].CGColor;
        navLayer.shadowOffset = CGSizeMake(0.0, 1.0);
        navLayer.shadowOpacity = 0.35f;
        navLayer.shouldRasterize = YES;
    }
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    self.nurseViewController = [[[NurseViewController alloc] initWithNibName:@"NurseViewController" bundle:nil] autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload
{
    self.scrollView = nil;
    self.nurseViewController = nil;
    self.nurseViewButtion = nil;
    self.delegateViewButton = nil;
}

//切换到专家列表的TableView
- (IBAction)selectTableView: (id)sender
{
    [MobClick event:@"zljsrc001"];
    
    if (self.nurseViewController==nil) {
        self.nurseViewController = [[[NurseViewController alloc] initWithNibName:@"NurseViewController" bundle:nil] autorelease];
    }
    [self.navigationController pushViewController:self.nurseViewController animated:YES];
}

//切换到代理模式演示的View
- (IBAction)selectDelegateView:(id)sender
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"book", @"type", @"3", @"price", nil];
    [MobClick event:@"zljsrc002" attributes:dict];
    
    DelegateViewController *delegateViewController = [[[DelegateViewController alloc] initWithNibName:@"DelegateViewController" bundle:nil] autorelease];
    delegateViewController.delegate = self;
    [self.navigationController pushViewController:delegateViewController animated:YES];
}

//协议实现方法
- (void)changeButtionText:(id)data
{
    [MobClick event:@"zljsrc003" label:@"zljsrc"];
    
    [_delegateViewButton setTitle:data forState:UIControlStateNormal];
}

//切换到Picker View演示页面
- (IBAction)selectPickerView:(id)sender
{
    PickerViewController *pickerViewController = [[[PickerViewController alloc] initWithNibName:@"PickerViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:pickerViewController animated:YES];
}

//自定义pickerview演示页面
- (IBAction)selectCustomPickerView:(id)sender
{
    CustomPickerViewController *customPickerViewController = [[[CustomPickerViewController alloc] initWithNibName:@"CustomPickerViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:customPickerViewController animated:YES];
}

//textview代理演示页面
- (IBAction)selectTextView:(id)sender
{
    TextViewController *textViewController = [[[TextViewController alloc] initWithNibName:@"TextViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:textViewController animated:YES];
}

//友盟分享
- (IBAction)UMShare:(id)sender
{
//    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"your identifier"];
//    UMSocialBar *socialBar = [[UMSocialBar alloc] initWithUMSocialData:socialData withViewController:self];
//    socialBar.center = CGPointMake(160, 390);
//    [self.view addSubview:socialBar];
}

- (IBAction)selectASILog:(id)sender
{
    ASILogViewController *asiLogViewController = [[[ASILogViewController alloc] initWithNibName:@"ASILogViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:asiLogViewController animated:YES];
}

//
//-(void)viewWillAppear:(BOOL)animated{
//    [super.navigationController setNavigationBarHidden:NO animated:true];
//    [super viewWillDisappear:YES];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super.navigationController setNavigationBarHidden:NO animated:true];
//    [super viewWillDisappear:YES];
//}

@end
