//
//  NurseViewController.h
//  Nurse
//
//  Created by zhangling on 12-12-26.
//  Copyright (c) 2012年 zhangling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NurseRequest.h"
#import "NurseCell.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshPullUpTableHeaderView.h"

static const int SECTION_ROW_COUNT = 5;

@interface NurseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate, EGORefreshPullUpTableHeaderDelegate> {
    int counts;
    NSMutableArray *commentsData;
    ASIFormDataRequest *commentRequest;
    MBProgressHUD *commentProgress;
    NSMutableArray *sectionArray;
}

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) ASIFormDataRequest *commentRequest;
@property (strong, nonatomic) MBProgressHUD *commentProgress;
@property (nonatomic,retain) NSMutableArray *commentsData;
@property (nonatomic,retain) NSMutableArray *sectionArray;

//上拉刷新
@property (strong, nonatomic) EGORefreshPullUpTableHeaderView *refreshPullUpdateView;
@property (assign, nonatomic)BOOL pullUpdate_reloading;

//下拉刷新
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (assign, nonatomic)BOOL reloading;


//封装方法
-(int)currentRow:(int)allRow currentSection:(int) section;
-(int)currentSection:(int)count;

@end
