//
//  NurseRequest.h
//  Nurse
//
//  Created by zhangling on 12-12-26.
//  Copyright (c) 2012年 zhangling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

const static NSString *API_HOST = @"http://mapi.babytree.com";

@interface NurseRequest : NSObject

+ (ASIFormDataRequest *)getList: (NSString *)start withLength: (NSString *)ength;
+ (ASIFormDataRequest *)withStart: (NSInteger)commentCount;

@end
