//
//  TextFieldDelegate.h
//  blog
//
//  Created by zhangling on 11-8-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TextFieldDelegate : NSObject <UITextFieldDelegate> {
	
	id beginSelectDelegate;
	SEL beginSelectMethod;
    void (*beginSelectAction) (id, SEL);
	id endSelectDelegate;
	SEL endSelectMethod;
    void (*endSelectAction) (id, SEL);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;

- (void)setBeginSelectedAction:(id)delegate method:(SEL)action;
- (void)setEndSelectedAction:(id)delegate method:(SEL)action;

@end
