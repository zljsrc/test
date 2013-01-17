//
//  EGORefreshPullUpTableHeaderView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//修改人：禚来强 iphone开发qq群：79190809 邮箱：zhuolaiqiang@gmail.com
//修改人：肖柏旭 babytree 修改了所有函数名称，增加PullUp ,目的为了与上拉刷新同时使用
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	EGOOPullUpRefreshPulling = 0,
	EGOOPullUpRefreshNormal,
	EGOOPullUpRefreshLoading,	
} EGOPullUpRefreshState;

@protocol EGORefreshPullUpTableHeaderDelegate;
@interface EGORefreshPullUpTableHeaderView : UIView {
	
	id _delegate;
	EGOPullUpRefreshState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	

}

@property(nonatomic,assign) id <EGORefreshPullUpTableHeaderDelegate> delegate;

- (void)refreshPullUpLastUpdatedDate;
- (void)egoRefreshPullUpScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshPullUpScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshPullUpScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol EGORefreshPullUpTableHeaderDelegate
- (void)egoRefreshPullUpTableHeaderDidTriggerRefresh:(EGORefreshPullUpTableHeaderView*)view;
- (BOOL)egoRefreshPullUpTableHeaderDataSourceIsLoading:(EGORefreshPullUpTableHeaderView*)view;
@optional
- (NSDate*)egoRefreshPullUpTableHeaderDataSourceLastUpdated:(EGORefreshPullUpTableHeaderView*)view;
@end
