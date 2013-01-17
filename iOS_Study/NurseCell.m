//
//  NurseCell.m
//  Nurse
//
//  Created by zhangling on 12-12-27.
//  Copyright (c) 2012年 zhangling. All rights reserved.
//

#import "NurseCell.h"

@implementation NurseCell

@synthesize nameLabel,nurseImageView,connectLabel,continerView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//初始化TableCell数据
- (void) setCellWithDictionary: (NSDictionary *)comentDictionary {
    
    //制作缓存容器
    [self.nameLabel setText:[comentDictionary objectForKey:@"name"]];
    NSURL *url = [NSURL URLWithString:[comentDictionary objectForKey:@"profile_img"]];
    if ( url!=nil && [url isEqual:[NSNull null]]) {
        [self.nurseImageView setImage:[UIImage imageNamed:@"avatar_default"]];
    }else {
        [self.nurseImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    }
    
    NSString *text = [comentDictionary objectForKey:@"introduction"];
    float height = [NurseCell getContentHeight:text];
    [self.connectLabel setFrame:CGRectMake(self.connectLabel.frame.origin.x, self.connectLabel.frame.origin.y, 240.0, MAX(height, 27.0f))];
    [self.connectLabel setText:[comentDictionary objectForKey:@"introduction"]];
    
    NSArray *views = [self.continerView subviews];
    
    //访问数据的过程中  请求不到数据时  注意判断和提示   例如此处可做if(![commentData objectForKey:@"skill"]){弹出动画，提示用户}
    NSArray *skillList = [comentDictionary objectForKey:@"skill"];
    
    
    //设置容器的显示信息
    [self.continerView setFrame:CGRectMake(80, self.connectLabel.frame.size.height + 50, 240, 21*[skillList count])];
    
    if ( [skillList count]>0 ) {
        for (int i=0; i<[skillList count]; i++) {
            UILabel *myLabel;
            if (i < [views count]) {
                myLabel = [views objectAtIndex:i];
            } else {
                myLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 21*i, 220, 21)] autorelease];
                [self.continerView addSubview:myLabel];
            }
            NSString *key = [[skillList objectAtIndex:i]  objectForKey:@"v"];
            // NSLog(@"%@",key);
            [myLabel setHidden:NO];
            if ([key intValue] == 0) {
                [myLabel setBackgroundColor:[UIColor redColor]];
                myLabel.text = [[skillList objectAtIndex:i ] objectForKey:@"k"];
            } else {
                [myLabel setBackgroundColor:[UIColor greenColor]];
                NSString *txt = [[skillList objectAtIndex:i ] objectForKey:@"k"];
                myLabel.text = txt;
            }
        }
    }
    
    if ([views count] > [skillList count]) {
        for (int i= [skillList count]; i < [views count]; i++) {
            UILabel *myLabel = [views objectAtIndex:i];
            [myLabel removeFromSuperview];
        }
    }
    
    return ;
}

+ (float)getContentHeight:(NSString *) content
{
    CGSize constraint = CGSizeMake(240.0, 20000.0f);
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

+ (float)getCellHeight:(NSDictionary *)commentDictionary
{
    NSString *text = [DictionaryValue getStringFrom:commentDictionary withKey:@"introduction" withDefaultValue:@""];
    float height = [NurseCell getContentHeight:text];
    NSArray *tempArray=[commentDictionary objectForKey:@"skill"];
    float counts = 21 * [tempArray count];
    return height + 75 + counts;
}

- (void)dealloc
{
    [self.nurseImageView release];
    [self.nameLabel release];
    [self.connectLabel release];
    [self.continerView release];
    [super dealloc];
}

@end
