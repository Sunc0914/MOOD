//
//  PicturePageVC.m
//  MoodDiary
//
//  Created by Sunc on 15/10/20.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "PicturePageVC.h"
#import "depressVC.h"
#import "upsetVC.h"

@interface PicturePageVC ()

@end

@implementation PicturePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initPic];
}

- (void)initPic{
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, upsideheight+20, SCREEN_WIDTH-20, (SCREEN_WIDTH-20)*0.7)];
    img.layer.masksToBounds = YES;
    img.layer.cornerRadius = 5;
    
    NSString *detailStr = [[NSString alloc]init];
    
    if([_testType isEqualToString:@"upset"])
    {
        img.image = [UIImage imageNamed:@"upsetpage.png"];
        detailStr = @"\u3000\u3000焦虑症，又称为焦虑性神经症，是神经症这一大类疾病中最常见的一种，以焦虑情绪体验为主要特征。\n注意区分正常的焦虑情绪，如焦虑严重程度与客观事实或处境明显不符，或持续时间过长，则可能为病理性的焦虑。\n\u3000\u3000敢不敢测一测自己是不是患上了焦虑症了？";
        self.title = @"焦虑";
    }
    else if ([_testType isEqualToString:@"depress"])
    {
        img.image = [UIImage imageNamed:@"depresspic.jpg"];
        detailStr = @"\u3000\u3000抑郁症又称抑郁障碍，以显著而持久的心境低落为主要临床特征，是心境障碍的主要类型。临床可见心境低落与其处境不相称，情绪的消沉可以从闷闷不乐到悲痛欲绝，自卑抑郁，部分病例有明显的焦虑和运动性激越；严重者可出现幻觉、妄想等精神病性症状。\n\u3000\u3000敢不敢测一测自己是不是患上了抑郁症？";
        self.title = @"抑郁";
    }
    
    [self.view addSubview:img];
    
    CGSize size = [self maxlabeisize:CGSizeMake(SCREEN_WIDTH-20, 999) fontsize:13 text:detailStr];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, img.frame.size.height+img.frame.origin.y+10, SCREEN_WIDTH-20, size.height)];
    label.font = [UIFont systemFontOfSize:13];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
    label.text = detailStr;
    
    [self.view addSubview:label];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, label.frame.size.height+label.frame.origin.y+30, SCREEN_WIDTH-30, 40)];
    [btn addTarget:self action:@selector(btnclicked) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor colorWithRed:71/255.0 green:228/255.0 blue:160/255.0 alpha:1.0];
    [btn setTitle:@"测   测   看" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)btnclicked{
    
    if ([_testType isEqualToString:@"upset"]) {
        [self pushtojiaolv];
    }
    else
    {
        [self pushtoyiyu];
    }
}

- (void)pushtojiaolv{
    upsetVC *upset = [[upsetVC alloc]init];
    upset.testname = @"upset";
    upset.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:upset animated:YES];
}

- (void)pushtoyiyu{
    depressVC *depress = [[depressVC alloc]init];
    depress.testname = @"depress";
    depress.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:depress animated:YES];
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
