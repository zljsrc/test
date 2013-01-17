//
//  DictionaryValue.m
//  Nurse
//
//  Created by zhangling on 13-1-5.
//  Copyright (c) 2013年 zhangling. All rights reserved.
//

#import "DictionaryValue.h"

@implementation DictionaryValue

+ (NSString *)getStringFrom:(NSDictionary *)dic withKey:(NSString *)key withDefaultValue:(NSString *)defaultValue
{
    NSString *value = [dic objectForKey:key];
    if (value==nil || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    return value;
}

+ (float)getFloatFrom:(NSDictionary *)dic withKey:(NSString *)key withDefaultValue:(float)defaultValue
{
    NSNumber *value = [dic objectForKey:key];
    if (value==nil || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    return [value floatValue];
}

+ (int)getIntFrom:(NSDictionary *)dic withKey:(NSString *)key withDefaultValue:(int)defaultValue
{
    NSNumber *value = [dic objectForKey:key];
    if (value==nil || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    return [value intValue];
}

@end
