//
//  AdviceVC.m
//  Mood Diary
//
//  Created by Sunc on 15/7/10.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "AdviceVC.h"

@interface AdviceVC ()
{
    UIScrollView *scrollView;
    UILabel *textLabel;
    
    NSString *content;
}

@end

@implementation AdviceVC
@synthesize advicetype;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getdata];
    
    if ([advicetype isEqualToString:@"jiaolv5"]) {
        self.title = @"5个小技巧战胜焦虑";
    }
    else if ([advicetype isEqualToString:@"kefujiaolvzhihu"])
    {
        self.title = @"如何克服焦虑（知乎）";
    }
    else if ([advicetype isEqualToString:@"yiyu23"]){
        self.title = @"抑郁二三事";
    }
    else if ([advicetype isEqualToString:@"zouchuyiyu"]){
        self.title = @"走出抑郁";
    }
}

- (void)getdata{
    NSString *name = [NSString stringWithFormat:@"%@",advicetype];
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"json"];
    NSString *jsonString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *json = [jsonString stringByReplacingOccurrencesOfString:@";" withString:@","];
    NSDictionary *result = [json objectFromJSONString];
    content = [NSString stringWithFormat:@"%@",[result objectForKey:@"data"]];
    
    [self initsrcollview];
}

- (void)initsrcollview{
    
    CGSize size = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-20, 99999) fontsize:16 text:content];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, upsideheight+10, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight-10-10)];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, size.height);
    
    textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, size.height)];
    textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.text = content;
    
    [scrollView addSubview:textLabel];
    
    [self.view addSubview:scrollView];
    
}

- (void)leftitemclicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
