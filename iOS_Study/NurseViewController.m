//
//  NurseViewController.m
//  Nurse
//
//  Created by zhangling on 12-12-26.
//  Copyright (c) 2012年 zhangling. All rights reserved.
//

#import "NurseViewController.h"

@interface NurseViewController ()

@end

@implementation NurseViewController

@synthesize commentsData, commentRequest, commentProgress, sectionArray, myTableView;
@synthesize refreshPullUpdateView, pullUpdate_reloading, refreshHeaderView, reloading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //初始化全局变量
        self.commentsData = [[[NSMutableArray alloc] init] autorelease];
        self.sectionArray = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化并绑定菊花
    //引用变量最好使用 .变量的方式 便于内存管理
    self.commentProgress = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.commentProgress setAnimationType:MBProgressHUDAnimationFade];
    NSLog(@"%d", self.commentProgress.retainCount);
    [self.view addSubview: self.commentProgress];
    
    //设置UI全局属性  最好在初始化界面里面
    [self.myTableView setSeparatorStyle: UITableViewCellSeparatorStyleSingleLine];
    [self reloadCommentData];
    
    if (self.refreshHeaderView == nil)
    {
        // 创建下拉视图
        EGORefreshTableHeaderView *updateview = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.frame.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
        updateview.delegate = self;
        [self.myTableView addSubview:updateview];
        self.refreshHeaderView = updateview;
    }
    
    // 更新时间
    [self.refreshHeaderView refreshLastUpdatedDate];
    //初始化上拉视图
    if (self.refreshPullUpdateView == nil) {
        //设置并绑定当前的视图
        EGORefreshPullUpTableHeaderView *pullUpView = [[EGORefreshPullUpTableHeaderView alloc] initWithFrame: CGRectMake(0.0, self.myTableView.bounds.size.height+2000, self.view.frame.size.width, self.myTableView.bounds.size.height)];
        pullUpView.delegate = self;
        [self.myTableView addSubview:pullUpView];
        self.refreshPullUpdateView = pullUpView;
        [pullUpView release];
    }
    [self.refreshPullUpdateView refreshPullUpLastUpdatedDate];
    
    
    //获取当前设备的版本号
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //4.3以前  由于生命周期的原因  必需延时调用
    if (version >= 4.3) {
        [self scrollToToday];
    } else {
        [self performSelector:@selector(scrollToToday) withObject:nil afterDelay:1];
    }

    self.navigationItem.title = @"专家列表";
    UIBarButtonItem *diquButtons = [[UIBarButtonItem alloc]initWithTitle:@"滚动"style:UIBarButtonItemStyleBordered target:self action:@selector(selectArea)];
    self.navigationItem.rightBarButtonItem = diquButtons;
    [diquButtons release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload
{
    self.commentProgress = nil;
    self.refreshPullUpdateView = nil;
    self.refreshHeaderView = nil;
    self.myTableView = nil;
    [self.commentRequest clearDelegatesAndCancel];
    self.commentRequest = nil;
}

-(void)selectArea
{
    //获取总的section
    int allSection;
    
    if ([self.commentsData count] % SECTION_ROW_COUNT != 0) {
        allSection= [self.commentsData count]/SECTION_ROW_COUNT + 1;
    }else {
        allSection= [self.commentsData count]/SECTION_ROW_COUNT;
    }
    //判断当前的section
    int section =  [self.commentsData count]%SECTION_ROW_COUNT != 0 ? [self.commentsData count]/SECTION_ROW_COUNT + 1 : [self.commentsData count]/SECTION_ROW_COUNT;
    if (section-1>0) {
        section = section-1;
    } else {
        section = 0;
    }
    //判断临界条件，设置回滚的值
    if (section==0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        if (section==allSection) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

- (void)scrollToToday
{
    if ([self.commentsData count]==0) {
        return;
    }
    int section = [self currentSection:[self.commentsData count]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:section];
    [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


//开启异步访问方法
- (void)reloadCommentData
{    //控制界面可否点击
    [commentProgress setLabelText:@"正在刷新"];
    [commentProgress show:YES];
    
    //调用API请求 开始连接
    [self.commentRequest clearDelegatesAndCancel];
    self.commentRequest = [NurseRequest getList: @"0" withLength: @"2"];
    [self.commentRequest setDelegate:self];
    [self.commentRequest setDidFinishSelector :@selector(reloadCommentFinished:)];
    [self.commentRequest setDidFailSelector: @selector(reloadCommentFailed:)];
    [self.commentRequest startAsynchronous];
}

//请求成功后，用SBjson解析
- (void)reloadCommentFinished:(ASIHTTPRequest *)request
{
    //控制绑定 不能点击
    [self.commentProgress setHidden:YES];
    NSString *responseString = [request responseString];
    
    //定义并初始化SBJson
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    
    //开始解析响应返回的字符串
    NSError *error = nil;
    NSDictionary *messageDictionary = [parser objectWithString:responseString error:&error];
    if (error) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"对不起，刷新失败" message:[error localizedDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
        return;
    }
    
    NSString *status = [messageDictionary objectForKey:@"status"];
    if ([status isEqual:@"0"]) {
        [self.commentsData removeAllObjects];
        if ([(NSMutableArray * )[messageDictionary objectForKey:@"nurses"] count] != 0) {
            [self.commentsData addObjectsFromArray:[messageDictionary objectForKey:@"nurses"]];
            NSLog(@"加载数据:%d条",[self.commentsData count]);
            //手动刷新TableViewData
            //[myTableView reloadData];
            [self doneLoadingTableViewData];
            
            //调用封装方法
            int section = [self currentSection:[self.commentsData count]];
            int     row = [self currentRow:[self.commentsData count] currentSection:section];
            
            //获取当前tableview的大小  第几个section上多少行
            CGRect tableViewRect = [self.myTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            NSLog(@"width=%f,height=%f",tableViewRect.size.width,tableViewRect.size.height);
            //判断当前tableView是否充满屏幕
            CGFloat cellHeight = MAX(tableViewRect.origin.y+tableViewRect.size.height, self.view.frame.size.height);
            NSLog(@"height===%f",cellHeight);
            //刷新下拉绑定的view
            [self.refreshPullUpdateView setFrame:CGRectMake(0, cellHeight, tableViewRect.size.width, tableViewRect.size.height)];
            
        } else {
            [self.refreshPullUpdateView setFrame:CGRectMake(self.myTableView.frame.origin.x, self.view.frame.size.height, self.myTableView.frame.size.width, myTableView.frame.size.height)];
        }
    } else {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"对不起，刷新失败" message:[messageDictionary objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
    
    //将reload置为NO;
    if(self.pullUpdate_reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
    }
}

// 刷新结束时调用
- (void)doneLoadingTableViewData
{
    NSLog(@"更新界面");
    [self.myTableView reloadData];
    reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
}


//返回当前section上的cell个数  在【0，4】之间
-(int)currentRow:(int)allRow currentSection: (int)section {
    if (section==0) {
        if (allRow % SECTION_ROW_COUNT == 0) {
            return 0;
        }else {
            return allRow - 1;
        }
    }else {
        if (allRow % SECTION_ROW_COUNT != 0) {
            return allRow % SECTION_ROW_COUNT - 1;
        }else {
            return 4;
        }
    }
}

//返回当前的section数
-(int)currentSection:(int)count{
    int section;
    if (count % SECTION_ROW_COUNT != 0) {
        section = count/SECTION_ROW_COUNT + 1;
    } else {
        section = count/SECTION_ROW_COUNT;
    }
    
    if (section-1>0) {
        return section-1;
    } else {
        return 0;
    }
}


/*TableView的代理方法
 +返回的是section列：numberOfSectionsInTableView:(UITableView *)tableView
 +返回的是section行：tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 +返回的是自定义的cell
 +自定义xib的cell：[[[NSBundle mainBundle] loadNibNamed:@"NurseCell" owner:self options:nil]
 objectAtIndex:0];
 +自定义代码的Cell：cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"NurseCell"] autorelease];
 +返回的是TableView的Cell高度
 */
#pragma mark -
#pragma mark Table Data Source Methods
//获取Table有多少secion
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 返回总共有多少个section
    // return ([commentData count])%5!=0?[commentData count]/5+1:[commentData count]/5;
    
    if ([self.commentsData count] % SECTION_ROW_COUNT != 0) {
        return [self.commentsData count]/SECTION_ROW_COUNT + 1;
    }else {
        return [self.commentsData count]/SECTION_ROW_COUNT;
    }
    
}
//获取对应section有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回的是当前section上应该有的cell个数，注意判断的逻辑和边界问题
    if([self.commentsData count] ==0){
        return 0;
    } else {
        if ([self.commentsData count] - section * SECTION_ROW_COUNT >= SECTION_ROW_COUNT) {
            return 5;
        }else {
            return [self.commentsData count] - section * SECTION_ROW_COUNT;
        }
    }
}

//按照索引设置当前的cell属性和值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *commentCellIdentifier = @"NurseCell";
    //获取自定义cell类型
    NurseCell *cell = [self.myTableView dequeueReusableCellWithIdentifier: commentCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NurseCell" owner:self options:nil] objectAtIndex:0];
    }
    
    //获取索引处cell的数据
    NSDictionary *commentDictionary = [self.commentsData objectAtIndex:indexPath.section*SECTION_ROW_COUNT + indexPath.row];
    //NSLog(@"%@",commentDictionary);
    [cell setCellWithDictionary:commentDictionary];
    
    return cell;
}
//自适应cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //索引的第几个section上第几个cell的高度
    NSDictionary *commentDictionary = [self.commentsData objectAtIndex:indexPath.section*SECTION_ROW_COUNT + indexPath.row];
    return [NurseCell getCellHeight:commentDictionary];
}

//设置tableview的section
//返回当前section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
//设置当前section的属性
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *headerView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 317, 30)] autorelease];
    [headerView setImage:[UIImage imageNamed:@"y_section_bar"]];
    UILabel *sectionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 20)] autorelease];
    [sectionLabel setBackgroundColor:[UIColor clearColor]];
    [sectionLabel setTextColor:[UIColor whiteColor]];
    [sectionLabel setFont:[UIFont systemFontOfSize:16]];
    [sectionLabel setText:[NSString stringWithFormat:@"从%d--%d", 5*section+1,5*section+5]];
    [headerView addSubview:sectionLabel];
    return headerView;
}
///////////////
#pragma mark -



//下拉方法
// 刷新开始时调用
- (void)reloadTableViewDataSource
{
    if(pullUpdate_reloading != YES && reloading != YES){
        reloading = YES;
        [self reloadCommentData];
    }else{
        if(pullUpdate_reloading==YES){
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
        }
    }
}
// 页面滚动时回调
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll");
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [self.refreshPullUpdateView egoRefreshPullUpScrollViewDidScroll:scrollView];
}
// 滚动结束时回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [self.refreshPullUpdateView egoRefreshPullUpScrollViewDidEndDragging:scrollView];
}
// 开始刷新时回调
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    //NSLog(@"egoRefreshTableHeaderDidTriggerRefresh");
    [self reloadTableViewDataSource];
}
// 下拉时回调
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    //NSLog(@"egoRefreshTableHeaderDataSourceIsLoading");
    return reloading; // should return if data source model is reloading
}
// 请求上次更新时间时调用
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    //NSLog(@"egoRefreshTableHeaderDataSourceLastUpdated");
    return [NSDate date]; // should return date data source was last changed
}
//下拉结束


//上拉方法
// 加载数据开始时回调
- (void)reloadPullUpTableViewDataSource
{
    if(reloading != YES && pullUpdate_reloading != YES){
        pullUpdate_reloading = YES;
        [self loadNextPageData];
    }else{
        if(reloading == YES){
            [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1];
        }
    }
}
//页面滑动时回调
- (void)doneLoadingPullUpTableViewData
{
    [myTableView reloadData];
    pullUpdate_reloading = NO;
    [self.refreshPullUpdateView egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:myTableView];
}
// 开始刷新时回调
- (void)egoRefreshPullUpTableHeaderDidTriggerRefresh:(EGORefreshPullUpTableHeaderView*)view
{
    [self reloadPullUpTableViewDataSource];
}
// 上拉拉时回调
- (BOOL)egoRefreshPullUpTableHeaderDataSourceIsLoading:(EGORefreshPullUpTableHeaderView*)view
{
    return pullUpdate_reloading; // should return if data source model is reloading
}
// 请求上次更新时间时调用
- (NSDate*)egoRefreshPullUpTableHeaderDataSourceLastUpdated:(EGORefreshPullUpTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}
//上拉方法结束

//上拉加载更多数据
-(void)loadNextPageData
{
    [self.commentProgress setLabelText:@"正在刷新"];
    [self.commentProgress show:YES];
    [self.commentRequest clearDelegatesAndCancel];
    self.commentRequest = [NurseRequest withStart:[self.commentsData count]];
    [self.commentRequest setDelegate:self];
    [self.commentRequest setDidFinishSelector:@selector(nextLoadDataFinished:)];
    [self.commentRequest setDidFailSelector:@selector(nextLoadDataFail:)];
    [self.commentRequest startAsynchronous];
}

//上拉后加载更多数据 更新tableView列表
- (void)nextLoadDataFinished:(ASIHTTPRequest *)request
{
    //请求时不能点击
    [self.commentProgress setHidden:YES];
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    NSError *error = nil;
    NSDictionary *nurseList = [parser objectWithString:responseString error:&error];
    NSString *status = [nurseList objectForKey:@"status"];
    if(error == nil){
        if ([status isEqual:@"0"]) {
            if ([(NSMutableArray * )[nurseList objectForKey:@"nurses"] count] != 0) {
                [self.commentsData addObjectsFromArray:[nurseList objectForKey:@"nurses"]];
                NSLog(@"commentdata====%d",[self.commentsData count]);
                //[myTableView reloadData];
                [self doneLoadingPullUpTableViewData];
                
                int section =  [self.commentsData count] % SECTION_ROW_COUNT != 0 ? [self.commentsData count]/SECTION_ROW_COUNT + 1 : [self.commentsData count]/SECTION_ROW_COUNT;
                if (section - 1 > 0) {
                    section = section - 1;
                }else {
                    section = 0;
                }
                int row = 0;
                if (section == 0) {
                    row = [self.commentsData count] == 0 ? 0 : [self.commentsData count]-1;
                }else {
                    row = [self.commentsData count] % SECTION_ROW_COUNT != 0 ? [self.commentsData count] % SECTION_ROW_COUNT - 1 : 4;
                }
                
                CGRect tableViewRect = [self.myTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                NSLog(@"pullwidth=%f,height=%f",tableViewRect.size.width,tableViewRect.size.height);
                CGFloat cellHeight = MAX(tableViewRect.origin.y+tableViewRect.size.height, self.view.frame.size.height);
                NSLog(@"pullheight===%f",cellHeight);
                [refreshPullUpdateView setFrame:CGRectMake(tableViewRect.origin.x, cellHeight, tableViewRect.size.width, tableViewRect.size.height)];
            }
        }
    }
    //加载完成去掉加载框
    if(pullUpdate_reloading==YES){
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1];
    }
}

- (void)nextLoadDataFail:(ASIHTTPRequest *)request
{
    [commentProgress hide:YES];
    
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"亲，您的网络不给力啊" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alertView show];
    
    //加载完成去掉加载框
    if(pullUpdate_reloading==YES){
        [self performSelector:@selector(doneLoadingPullUpTableViewData) withObject:nil afterDelay:0.1];
    }
    //加载完成去掉加载框
    if(reloading==YES){
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
    }
}


- (void)dealloc
{
    [self.myTableView release];
    [self.commentsData release];
    [self.commentProgress release];
    [self.commentRequest clearDelegatesAndCancel];
    [self.commentRequest release];
    [self.sectionArray release];
    [super dealloc];
}

@end
