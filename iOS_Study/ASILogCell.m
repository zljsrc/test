//
//  ASILogCell.m
//  iOS_Study
//
//  Created by zhangling on 13-1-24.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import "ASILogCell.h"

@implementation ASILogCell

@synthesize idLabel = _idLabel;
@synthesize actionTypeLabel = _actionTypeLabel;
@synthesize actionDescTextView = _actionDescTextView;
@synthesize extraInfoLabel = _extraInfoLabel;
@synthesize actionExtraInfoTextView = _actionExtraInfoTextView;
@synthesize actionTsLabel = _actionTsLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setData:(NSDictionary *)log
{
    NSString *logId = [log objectForKey:ID];
    self.idLabel.text = logId;
    NSString *actionType = [log objectForKey:ACTION_TYPE];
    self.actionTypeLabel.text = actionType;
    NSString *actionTs = [log objectForKey:ACTION_TS];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[actionTs intValue]];
    NSDateFormatter *f = [[[NSDateFormatter alloc]init]autorelease];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.actionTsLabel.text = [f stringFromDate:date];
    NSString *actionDesc = [log objectForKey:ACTION_DESCRIPTION];
    [self.actionDescTextView setText:actionDesc];
    float descHeight = MAX([ASILogCell getContentHeight:actionDesc], 20);
    [self.actionDescTextView setFrame:CGRectMake(self.actionDescTextView.frame.origin.x, self.actionDescTextView.frame.origin.y, self.actionDescTextView.frame.size.width, descHeight)];
    [self.extraInfoLabel setFrame:CGRectMake(self.extraInfoLabel.frame.origin.x, self.actionDescTextView.frame.origin.y + descHeight + 3, self.extraInfoLabel.frame.size.width, self.extraInfoLabel.frame.size.height)];
    
    NSString *actionExtraInfo = [log objectForKey:ACTION_EXTRA_INFO];
    [self.actionExtraInfoTextView setText:actionExtraInfo];
    float extraInfoHeight = MAX([ASILogCell getContentHeight:actionExtraInfo], 20);
    [self.actionExtraInfoTextView setFrame:CGRectMake(self.actionExtraInfoTextView.frame.origin.x, self.actionDescTextView.frame.origin.y + descHeight + 30, self.actionExtraInfoTextView.frame.size.width, extraInfoHeight)];
    
    [self setFrame:CGRectMake(0, 0, 320, [ASILogCell getHightWithLog:log])];
}

+ (float)getHightWithLog:(NSDictionary *)log
{
//    130
    NSString *actionDesc = [log objectForKey:ACTION_DESCRIPTION];
    NSString *actionExtraInfo = [log objectForKey:ACTION_EXTRA_INFO];
    float height = 130 + MAX(20, [ASILogCell getContentHeight:actionDesc]) + MAX(20, [ASILogCell getContentHeight:actionExtraInfo]);
    return height;
}

+ (float)getContentHeight:(NSString *) content
{
    CGSize constraint = CGSizeMake(280.0, 20000.0f);
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
