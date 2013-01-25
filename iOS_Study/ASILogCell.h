//
//  ASILogCell.h
//  iOS_Study
//
//  Created by zhangling on 13-1-24.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteLog.h"

@interface ASILogCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *idLabel;
@property (nonatomic, strong) IBOutlet UILabel *actionTypeLabel;
@property (nonatomic, strong) IBOutlet UITextView *actionDescTextView;
@property (nonatomic, strong) IBOutlet UILabel *extraInfoLabel;
@property (nonatomic, strong) IBOutlet UITextView *actionExtraInfoTextView;
@property (nonatomic, strong) IBOutlet UILabel *actionTsLabel;

- (void)setData:(NSDictionary *)log;
+ (float)getHightWithLog:(NSDictionary *)log;
+ (float)getContentHeight:(NSString *) content;

@end
