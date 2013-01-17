//
//  TestProcotol.h
//  iOS_Study
//
//  Created by zhangling on 13-1-6.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestProcotol <NSObject>

- (void)changeButtionText:(id)data;

@optional
- (void)changeViewTitle:(id)data;

@end
