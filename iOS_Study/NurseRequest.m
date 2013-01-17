//
//  NurseRequest.m
//  Nurse
//
//  Created by zhangling on 12-12-26.
//  Copyright (c) 2012年 zhangling. All rights reserved.
//

#import "NurseRequest.h"

@implementation NurseRequest

+ (ASIFormDataRequest *)getList:(NSString *)start withLength:(NSString *)length
{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/nurse/get_nurses.php", API_HOST]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:start forKey:@"offset"];
    [request setPostValue:length forKey:@"length"];
    return request;
}

+ (ASIFormDataRequest *)withStart: (NSInteger)commentCount
{
    NSURL *url=[NSURL URLWithString: [NSString stringWithFormat: @"%@/nurse/get_nurses.php", API_HOST]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue: [NSString stringWithFormat:@"%d",commentCount] forKey:@"offset"];
    [request setPostValue:@"3" forKey:@"length"];
    return request;
}

@end