//
//  TextViewDelegate.m
//  blog
//
//  Created by zhangling on 11-8-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TextViewDelegate.h"


@implementation TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	myTextView = textView;
	[self addHindKeyboardBar];
	if (beginSelectDelegate!=nil) {
		beginSelectAction(beginSelectDelegate,beginSelectMethod);
	}
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	if (endSelectDelegate!=nil) {
		endSelectAction(endSelectDelegate,endSelectMethod);
		endSelectDelegate = nil;
	}
	return YES;
}

- (void)addHindKeyboardBar
{
	UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
	[topView setBarStyle:UIBarStyleBlack];
	
	UIBarButtonItem *leftSpace = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
    leftSpace.width = 270.0f;
    
	UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissKeyBoard)] autorelease];
    rightButton.width = 40.0f;
	
	NSArray * buttonsArray = [NSArray arrayWithObjects:leftSpace,rightButton,nil];
	
	[topView setItems:buttonsArray animated:YES];
	[myTextView setInputAccessoryView:topView];
}

//点击完成隐藏键盘
- (IBAction)dismissKeyBoard
{
	if (endSelectDelegate!=nil) {
		endSelectAction(endSelectDelegate,endSelectMethod);
		endSelectDelegate = nil;
	}
	[myTextView resignFirstResponder];
}

//设置开始编辑时的动作
- (void)setBeginSelectedAction:(id)delegate method:(SEL)action
{
    beginSelectAction = (void(*)(id, SEL))[delegate methodForSelector:action];
    beginSelectDelegate = delegate;
    beginSelectMethod = action;
}

//设置结束编辑时的动作
- (void)setEndSelectedAction:(id)delegate method:(SEL)action
{
    endSelectAction = (void(*)(id, SEL))[delegate methodForSelector:action];
    endSelectDelegate = delegate;
    endSelectMethod = action;
}


- (void)dealloc
{
	[myTextView release];
	[super dealloc];
}

@end
