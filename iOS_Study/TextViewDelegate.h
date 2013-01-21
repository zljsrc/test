//
//  TextViewDelegate.h
//  blog
//
//  Created by zhangling on 11-8-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TextViewDelegate : NSObject <UITextViewDelegate> {
    UITextView *myTextView;
	
	id beginSelectDelegate;
	SEL beginSelectMethod;
    void (*beginSelectAction) (id, SEL);
	id endSelectDelegate;
	SEL endSelectMethod;
    void (*endSelectAction) (id, SEL);
}

- (void)addHindKeyboardBar;
- (IBAction)dismissKeyBoard;

- (void)setBeginSelectedAction:(id)delegate method:(SEL)action;
- (void)setEndSelectedAction:(id)delegate method:(SEL)action;

@end
