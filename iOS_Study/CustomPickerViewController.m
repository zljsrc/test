//
//  CustomPickerViewController.m
//  iOS_Study
//
//  Created by zhangling on 13-1-7.
//  Copyright (c) 2013年 zljsrc. All rights reserved.
//

#import "CustomPickerViewController.h"

@interface CustomPickerViewController ()

@end

@implementation CustomPickerViewController

@synthesize selectedShowLabel = _selectedShowLabel;
@synthesize years = _years;
@synthesize months = _months;

- (void)dealloc{
    [_selectedShowLabel release];
    [_years release];
    [_months release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"自定义PickerViw";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //初始化数据year
    self.years = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 1900; i<2101; i++) {
        [self.years addObject:[NSString stringWithFormat:@"%d年",i]];
    }
    //初始化数据month
    self.months = [[[NSMutableArray alloc] init] autorelease];
    for (int y = 1; y<13; y++) {
        [self.months addObject:[NSString stringWithFormat:@"%d月",y]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回一共有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
        return [self.years count];
    }else if (component == 1) {
        return [self.months count];
    }
    return 0;
}
//以下是代理部分可以自定义视图
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 80;
}

//自定义指定列的每行的视图，即指定列的每行的视图一致
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //宽度
    CGFloat width = [self pickerView:pickerView widthForComponent:component];
    
    //高度
    CGFloat height = [self pickerView:pickerView rowHeightForComponent:component];
    
    UIView *cell = [[[UIView alloc] init]autorelease];
    cell.frame = CGRectMake(0, 0, width, height);
    UILabel *cellLabel = [[UILabel alloc] init];
    cellLabel.frame = cell.frame;
    [cellLabel setTextAlignment:NSTextAlignmentCenter];
    cellLabel.tag = 200;
    
    if(component == 0){
        NSString *year = [self.years objectAtIndex:row];
        cellLabel.text = year;
    }
    else if(component == 1){
        NSString *month = [self.months objectAtIndex:row];
        cellLabel.text = month;
    }
    [cell addSubview:cellLabel];
    [cellLabel release];
    return cell;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //选择第0列的哪一行
    int rowOfComponent0 = [pickerView selectedRowInComponent:0];
    //选择第1列的哪一行
    int rowOfComponent1 = [pickerView selectedRowInComponent:1];
    //取得所选列所选行的视图
    UIView *yearView = [pickerView viewForRow:rowOfComponent0 forComponent:0];
    UIView *monthView = [pickerView viewForRow:rowOfComponent1 forComponent:1];
    //取得子视图
    UILabel *yearLabel = (UILabel*)[yearView viewWithTag:200];
    UILabel *monthLabel = (UILabel*)[monthView viewWithTag:200];
    //将所选结果展示在label上
    NSLog(@"%@",yearLabel.text);
    [self.selectedShowLabel setText:[NSString stringWithFormat:@"您选择的是：%@ %@",yearLabel.text,monthLabel.text]];
}

@end
