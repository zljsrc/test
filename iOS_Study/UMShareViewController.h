//
//  UMShareViewController.h
//  iOS_Study
//
//  Created by zhangling on 13-1-25.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"

@interface UMShareViewController : UIViewController<UMSocialDataDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) UMSocialControllerService *socialController;

@end
