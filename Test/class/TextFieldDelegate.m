//
//  TextFieldDelegate.m
//  blog
//
//  Created by zhangling on 11-8-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TextFieldDelegate.h"


@implementation TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	
	[textField resignFirstResponder];
	if (beginSelectDelegate!=nil) {
		beginSelectAction(beginSelectDelegate,beginSelectMethod);
	}
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	if (endSelectDelegate!=nil) {
		endSelectAction(endSelectDelegate,endSelectMethod);
	}
	return YES;
}

//软键盘收回
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (endSelectDelegate!=nil) {
		endSelectAction(endSelectDelegate,endSelectMethod);
	}
	[textField resignFirstResponder];
	return YES;
}

- (void)dealloc {
	[super dealloc];
}


- (void)setBeginSelectedAction:(id)delegate method:(SEL)action
{
    beginSelectAction = (void(*)(id, SEL))[delegate methodForSelector:action];
    beginSelectDelegate = delegate;
    beginSelectMethod = action;
}

- (void)setEndSelectedAction:(id)delegate method:(SEL)action
{
    endSelectAction = (void(*)(id, SEL))[delegate methodForSelector:action];
    endSelectDelegate = delegate;
    endSelectMethod = action;
}


@end
