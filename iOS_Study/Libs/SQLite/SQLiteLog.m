//
//  SQLiteLog.m
//  iOS_Study
//
//  Created by zhangling on 13-1-22.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import "SQLiteLog.h"

@implementation SQLiteLog

+ (sqlite3 *)getConnection
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"test.db"];
    
    sqlite3 *db;
    int rs = sqlite3_open([dbPath UTF8String], &db);
    if (rs != SQLITE_OK) {
        NSLog(@"%@", @"打开数据库失败！");
        sqlite3_close(db);
        return false;
    }
    
    char *errorMsg;
    const char *createSQL = "CREATE TABLE IF NOT EXISTS TestLog (\
                ID INTEGER PRIMARY KEY AUTOINCREMENT,\
                ACTION_TYPE INTEGER,\
                ACTION_DESCRIPTION TEXT,\
                ACTION_EXTRA_INFO TEXT,\
                ACTION_TS INTEGER\
        )";
    rs = sqlite3_exec(db, createSQL, NULL, NULL, &errorMsg);
    if (rs != SQLITE_OK) {
        NSLog(@"%@ ErrorMsg:%s", @"检查数据表失败！", errorMsg);
        sqlite3_close(db);
        return false;
    }
    
    return db;
}

+ (BOOL)insertActionLogWithType:(int)type description:(NSString *)desc extraInfo:(NSString *)extraInfo
{
    sqlite3 *db = [SQLiteLog getConnection];
    
    NSString *current = [NSString stringWithFormat:@"%ld", time(NULL)];
    
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO TestLog('%@','%@','%@','%@') VALUES ('%@','%@','%@','%@')",
                     ACTION_TYPE, ACTION_DESCRIPTION, ACTION_EXTRA_INFO, ACTION_TS,
                     [NSString stringWithFormat:@"%d", type], desc, extraInfo, current];
    
    char *errorMsg;
    int rs = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg);
    if (rs != SQLITE_OK) {
        NSLog(@"%@ ErrorMsg:%s", @"检查数据表失败！", errorMsg);
        sqlite3_close(db);
        return false;
    }
    
    sqlite3_close(db);
    return YES;
}

+ (NSMutableArray *)getLog:(int)action_type limit:(int)count offset:(int)skip
{
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    sqlite3 *db = [SQLiteLog getConnection];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TestLog WHERE action_type = %d ORDER BY ID DESC LIMIT %d OFFSET %d", action_type, count, skip];
    sqlite3_stmt *statement;
    int rs = sqlite3_prepare_v2(db, [query UTF8String], -1, &statement, nil);
    if (rs != SQLITE_OK) {
        NSLog(@"%@", @"查询数据失败！");
        sqlite3_close(db);
        return result;
    }
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
        NSString *pk = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 0)];
        [row setObject:pk forKey:ID];
        NSString *action_type = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 1)];
        [row setObject:action_type forKey:ACTION_TYPE];
        NSString *action_description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        [row setObject:action_description forKey:ACTION_DESCRIPTION];
        NSString *action_extra_info = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        [row setObject:action_extra_info forKey:ACTION_EXTRA_INFO];
        NSString *action_ts = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 4)];
        [row setObject:action_ts forKey:ACTION_TS];
        [result addObject:row];
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    return result;
}

@end
