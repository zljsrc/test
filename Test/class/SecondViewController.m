//
//  SecondViewController.m
//  Test
//
//  Created by 岭 张 on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

@synthesize imageView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.backgroundColor = [UIColor orangeColor].CGColor;
    self.view.layer.cornerRadius = 20.0;
    self.view.layer.frame = CGRectInset(self.view.layer.frame, 50, 50);
    
    
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor blueColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(5, 5);
    sublayer.shadowRadius = 5.0;
    sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 0.8;
    sublayer.frame = CGRectMake(30, 30, 128, 192);
    sublayer.borderColor = [UIColor blackColor].CGColor;
    sublayer.borderWidth = 2.0;
    sublayer.cornerRadius = 10.0;
    [self.view.layer addSublayer:sublayer];
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = sublayer.bounds;
    imageLayer.cornerRadius = 10.0;
    imageLayer.contents = (id) [UIImage imageNamed:@"BattleMapSplashScreen.png"].CGImage;
    imageLayer.masksToBounds = YES;
    [sublayer addSublayer:imageLayer];
    
    /*
    UIImage *chatImage = [[UIImage imageNamed:@"talk_left.jpg"] stretchableImageWithLeftCapWidth:22 topCapHeight:12];
    CALayer *chatBackgroundImage = [CALayer layer];
    chatBackgroundImage.frame = CGRectMake(20, 300, 100, 40);
    chatBackgroundImage.contents = (id) chatImage.CGImage;
    //imageLayer.masksToBounds = YES;
    [self.view.layer addSublayer:chatBackgroundImage];
     */
    
    UIImage* image =[UIImage imageNamed:@"talk_left.jpg"];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 300, 100, 50)];
    [imageView setImage:[image stretchableImageWithLeftCapWidth:22 topCapHeight:12]];
    //[imageView setImage:image];
    imageView.userInteractionEnabled = YES;
    imageView.tag = 1;
    [self.view addSubview:imageView];
    [imageView release];
     
    /*
    //初始化label  
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    //设置自动行数与字符换行  
    //[label setNumberOfLines:0];  
    //label.lineBreakMode = UILineBreakModeTailTruncation;   
    // 测试字串  
    NSString *s = @"这是一个测试！！！adsfsaf时发生发勿忘我勿f忘我勿忘我勿忘ff我勿忘我阿阿阿aaa阿阿阿阿阿阿阿阿阿阿啊00000000阿什顿。。。";  
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];  
    //设置一个行高上限  
    CGSize size = CGSizeMake(280,500);  
    //计算实际frame大小，并将label的frame变成实际大小  
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    //初始化label  
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, labelsize.height)];
    label.text = s;
    [self.view addSubview:label];
     */
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    //NSLog(@"tag %@",touch);
    if (touch.view.tag==1) {
        NSLog(@"Image Touch");
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [imageView release];
    [super dealloc];
}

@end
