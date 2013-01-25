//
//  SQLiteLog.h
//  iOS_Study
//
//  Created by zhangling on 13-1-22.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define ID @"id"
#define ACTION_TYPE @"action_type"
#define ACTION_DESCRIPTION @"action_description"
#define ACTION_EXTRA_INFO @"action_extra_info"
#define ACTION_TS @"action_ts"

#define ASI_DEBUG YES

@interface SQLiteLog : NSObject


+ (BOOL)insertActionLogWithType:(int)type description:(NSString *)desc extraInfo:(NSString *)extraInfo;

+ (NSMutableArray *)getLog:(int)action_type limit:(int)count offset:(int)skip;

@end
