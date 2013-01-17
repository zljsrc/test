//
//  DictionaryValue.h
//  Nurse
//
//  Created by zhangling on 13-1-5.
//  Copyright (c) 2013年 zhangling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryValue : NSObject

+ (NSString *)getStringFrom:(NSDictionary *)dic withKey:(NSString *)key withDefaultValue:(NSString *)defaultValue;

+ (float)getFloatFrom:(NSDictionary *)dic withKey:(NSString *)key withDefaultValue:(float)defaultValue;

+ (int)getIntFrom:(NSDictionary *)dic withKey:(NSString *)key withDefaultValue:(int)defaultValue;

@end
