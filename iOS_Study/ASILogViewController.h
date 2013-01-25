//
//  ASILogViewController.h
//  iOS_Study
//
//  Created by zhangling on 13-1-23.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshPullUpTableHeaderView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define LOG_MAIL_SEND_TO @"zhangling@babytree-inc.com"

@interface ASILogViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate, EGORefreshPullUpTableHeaderDelegate, MFMailComposeViewControllerDelegate>{
    int page;
}

@property (nonatomic, strong) IBOutlet UITableView *logTable;

@property (assign) int page;
@property (nonatomic, strong) NSMutableArray *data;

//上拉刷新
@property (strong, nonatomic) EGORefreshPullUpTableHeaderView *refreshPullUpdateView;
@property (assign, nonatomic)BOOL pullUpdate_reloading;

//下拉刷新
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (assign, nonatomic)BOOL reloading;

@end
