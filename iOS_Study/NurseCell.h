//
//  NurseCell.h
//  Nurse
//
//  Created by zhangling on 12-12-27.
//  Copyright (c) 2012年 zhangling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "DictionaryValue.h"

@interface NurseCell : UITableViewCell
{
}

@property(nonatomic,strong)IBOutlet UIImageView *nurseImageView;
@property(nonatomic,strong)IBOutlet UILabel *nameLabel;
@property(nonatomic,strong)IBOutlet UILabel *connectLabel;
@property(nonatomic,strong)IBOutlet UIView *continerView;

- (void) setCellWithDictionary: (NSDictionary *)comentDictionary;
+ (float)getContentHeight:(NSString *) content;
+ (float)getCellHeight:(NSDictionary *)commentDictionary;

@end
