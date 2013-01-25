//
//  ASILogViewController.m
//  iOS_Study
//
//  Created by zhangling on 13-1-23.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import "ASILogViewController.h"
#import "SQLiteLog.h"
#import "ASILogCell.h"

#define LOG_PAGE_SIZE 2

@interface ASILogViewController ()

@end

@implementation ASILogViewController

@synthesize logTable = _logTable;
@synthesize page = _page;
@synthesize data = _data;
@synthesize refreshPullUpdateView = _refreshPullUpdateView;
@synthesize pullUpdate_reloading = _pullUpdate_reloading;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize reloading = _reloading;


- (void)dealloc
{
    [self.logTable release];
    [self.data release];
    [super dealloc];
}

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
    _page = 1;
    
    [self loadData];
    
    if (self.refreshHeaderView == nil)
    {
        // 创建下拉视图
        EGORefreshTableHeaderView *updateview = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.logTable.frame.size.height, self.view.frame.size.width, self.logTable.bounds.size.height)];
        updateview.delegate = self;
        [self.logTable addSubview:updateview];
        self.refreshHeaderView = updateview;
    }
    
    // 更新时间
    [self.refreshHeaderView refreshLastUpdatedDate];
    //初始化上拉视图
    if (self.refreshPullUpdateView == nil) {
        //设置并绑定当前的视图
        EGORefreshPullUpTableHeaderView *pullUpView = [[EGORefreshPullUpTableHeaderView alloc] initWithFrame: CGRectMake(0.0, self.logTable.bounds.size.height+2000, self.view.frame.size.width, self.logTable.bounds.size.height)];
        pullUpView.delegate = self;
        [self.logTable addSubview:pullUpView];
        self.refreshPullUpdateView = pullUpView;
        [pullUpView release];
    }
    [self.refreshPullUpdateView refreshPullUpLastUpdatedDate];
    [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1];
}

//SECTION COUNT
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//row count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}
//按照索引设置当前的cell属性和值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *commentCellIdentifier = @"ASILogCell";
    //获取自定义cell类型
    ASILogCell *cell = [_logTable dequeueReusableCellWithIdentifier: commentCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ASILogCell" owner:self options:nil] objectAtIndex:0];
    }
    
    //获取索引处cell的数据
    NSDictionary *log = [_data objectAtIndex:indexPath.row];
    [cell setData:log];
    
    return cell;
}
//自适应cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *log = [_data objectAtIndex:indexPath.row];
    return [ASILogCell getHightWithLog:log];
}
//设置tableview的section
//返回当前section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)loadData
{
    NSMutableArray *logData = [SQLiteLog getLog:0 limit:LOG_PAGE_SIZE offset:(_page - 1) * LOG_PAGE_SIZE ];
    if (_page==1) {
        self.data = logData;
    } else {
        [self.data addObjectsFromArray:logData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *log = [_data objectAtIndex:indexPath.row];
    
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil) {
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) {
			[self displayComposerSheet:log];
		} else {
            NSLog(@"error");
        }
	} else {
		NSLog(@"error");
	}
    
    [self.logTable deselectRowAtIndexPath:indexPath animated:YES];
}

//下拉方法
// 刷新开始时调用
- (void)reloadTableViewDataSource
{
    if(_pullUpdate_reloading != YES && _reloading != YES){
        _reloading = YES;
        _page = 1;
        [self loadData];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
    }
}
// 页面滚动时回调
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [self.refreshPullUpdateView egoRefreshPullUpScrollViewDidScroll:scrollView];
}
// 滚动结束时回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [self.refreshPullUpdateView egoRefreshPullUpScrollViewDidEndDragging:scrollView];
}
// 开始刷新时回调
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
}
// 下拉时回调
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    //NSLog(@"egoRefreshTableHeaderDataSourceIsLoading");
    return _reloading; // should return if data source model is reloading
}
// 请求上次更新时间时调用
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    //NSLog(@"egoRefreshTableHeaderDataSourceLastUpdated");
    return [NSDate date]; // should return date data source was last changed
}
// 刷新结束时调用
- (void)doneLoadingTableViewData
{
    [self.logTable reloadData];
    _reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.logTable];
}
//下拉结束

//上拉方法
// 加载数据开始时回调
- (void)reloadPullUpTableViewDataSource
{
    if(_reloading != YES && _pullUpdate_reloading != YES){
        _pullUpdate_reloading = YES;
        _page ++;
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1];
    }
}
//页面滑动时回调
- (void)doneLoadingPullUpTableViewData
{
    [self loadData];
    [self.logTable reloadData];
    _pullUpdate_reloading = NO;
    [self.refreshPullUpdateView egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:self.logTable];
    
    if ([_data count]>0) {
        //获取当前tableview的大小  第几个section上多少行
        CGRect tableViewRect = [self.logTable rectForRowAtIndexPath:[NSIndexPath indexPathForRow:[_data count]-1 inSection:0]];
        //判断当前tableView是否充满屏幕
        CGFloat cellHeight = MAX(tableViewRect.origin.y+tableViewRect.size.height, self.view.frame.size.height);
        //刷新下拉绑定的view
        [self.refreshPullUpdateView setFrame:CGRectMake(0, cellHeight, tableViewRect.size.width, tableViewRect.size.height)];
    } else {
        //刷新下拉绑定的view
        [self.refreshPullUpdateView setFrame:CGRectMake(0, self.view.frame.size.height, 0, self.view.frame.size.height)];
    }
}
// 开始刷新时回调
- (void)egoRefreshPullUpTableHeaderDidTriggerRefresh:(EGORefreshPullUpTableHeaderView*)view
{
    [self reloadPullUpTableViewDataSource];
}
// 上拉拉时回调
- (BOOL)egoRefreshPullUpTableHeaderDataSourceIsLoading:(EGORefreshPullUpTableHeaderView*)view
{
    return _pullUpdate_reloading; // should return if data source model is reloading
}
// 请求上次更新时间时调用
- (NSDate*)egoRefreshPullUpTableHeaderDataSourceLastUpdated:(EGORefreshPullUpTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}
//上拉方法结束

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark Compose Mail
// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet:(NSDictionary *)log
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"[API调试log]"];
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:LOG_MAIL_SEND_TO];
	
	[picker setToRecipients:toRecipients];
    
	// Fill out the email body text
    NSString *actionType = [log objectForKey:ACTION_TYPE];
    NSString *actionDesc = [log objectForKey:ACTION_DESCRIPTION];
    NSString *actionExtraInfo = [log objectForKey:ACTION_EXTRA_INFO];
    NSString *actionTs = [log objectForKey:ACTION_TS];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[actionTs intValue]];
    NSDateFormatter *f = [[[NSDateFormatter alloc]init]autorelease];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *emailBody = [NSString stringWithFormat:@"ACTION_TYPE:[%@]\nACTION_DESC:[%@]\nACTION_EXTRA_INFO:[%@]\nACTION_TS:[%@(%@)]", actionType, actionDesc, actionExtraInfo, [f stringFromDate:date], actionTs];
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
//	message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Result: saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Result: sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Result: failed");
			break;
		default:
			NSLog(@"Result: not sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

@end
