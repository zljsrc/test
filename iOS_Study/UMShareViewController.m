//
//  UMShareViewController.m
//  iOS_Study
//
//  Created by zhangling on 13-1-25.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import "UMShareViewController.h"

@interface UMShareViewController ()

@end

@implementation UMShareViewController

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
    
    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"share_setting"];
    _socialController = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
    [_socialController.socialDataService setUMSocialDelegate:self];
    _socialController.soicalUIDelegate = self;
//    _locationManager = [[CLLocationManager alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareClicked:(id)sender
{
    NSString *shareText = [NSString stringWithFormat:@"我在宝宝树@快乐孕期 加入了圈子 想了解 滴准妈妈一起来吧。下载地址："];
    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"share_setting"];
    socialData.shareText = shareText;
    UINavigationController *shareEditController;
    shareEditController = [_socialController getSocialShareEditController:UMSocialSnsTypeSina];
    [self presentModalViewController:shareEditController animated:YES];
}

- (void)showUMShare
{
}

#pragma mark - UMSocialUIDelegate
- (void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"didCloseUIViewController with type is %d",fromViewControllerType);
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.viewControllerType == UMSViewControllerShareEdit) {
        NSLog(@"didFinishGetUMSocialDataInViewController is %@",response);
    }
}
#pragma mark -UMSocialDataDelegate
- (void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    UIAlertView *alertView;
    if (response.responseType == UMSResponseShareToSNS) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"发送成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        }
        else {
            NSString *msg = response.message;
            alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            
        }
        [alertView show];
        [alertView release];
    }
}
@end
