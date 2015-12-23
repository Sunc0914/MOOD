//
//  ResultVC.m
//  MoodDiary
//
//  Created by Sunc on 15/10/13.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "ResultVC.h"

@interface ResultVC ()
{
    UIScrollView *scorll;
    
    UILabel *label;
    
    UIBarButtonItem *left;
}

@end

@implementation ResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"测评结果";
    
    left = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.leftBarButtonItem = left;
    
    [self initScroll];
}

- (void)goBack
{
    if (_isToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initScroll{
    
    scorll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight)];
    
    CGSize size = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-20, 999) fontsize:13 text:_detailStr];
    
    scorll.contentSize  = CGSizeMake(SCREEN_WIDTH, size.height);
    scorll.backgroundColor = [UIColor whiteColor];
    
    if (size.height > SCREEN_HEIGHT-upsideheight+10) {
        scorll.contentSize  = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-upsideheight+10);
    }
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, size.height)];
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor whiteColor];
    label.text = _detailStr;
    label.numberOfLines = 0;
    
    [scorll addSubview:label];
    
    [self.view addSubview:scorll];
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
