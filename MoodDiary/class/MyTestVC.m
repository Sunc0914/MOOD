//
//  MyTestVC.m
//  Mood Diary
//
//  Created by Sunc on 15/7/10.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "MyTestVC.h"
#import "AdviceVC.h"
#import "upsetVC.h"
#import "depressVC.h"
#import "HollandTestVC.h"
#import "ResultVC.h"

@interface MyTestVC ()

@property (nonatomic) CGFloat height;

@end

@implementation MyTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的测评";
    
    _height = 60;
    
    [self initsettable];
}

- (void)initsettable{
    mytesttableview = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    mytesttableview.delegate = self;
    mytesttableview.dataSource = self;
    mytesttableview.tableFooterView = [[UIView alloc]init];
    
    CGRect frame = mytesttableview.tableHeaderView.frame;
    frame.size.height = 25;
    
    [self.view addSubview:mytesttableview];
    
}

#pragma mark - uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _height;
}

#pragma mark - uitableviewdelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"set";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//箭头
    }
    
    for (UIView *V in cell.contentView.subviews) {
        [V removeFromSuperview];
    }

    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 2, 200, _height-4)];
    
    if (indexPath.row == 0) {
        title.text = @"SCL90测评";
    }
    else if (indexPath.row == 1){
        title.text = @"霍兰德职业兴趣测评";
    }
    else if (indexPath.row == 2){
        title.text = @"焦虑测评";
    }
    else if (indexPath.row ==3){
        title.text = @"抑郁测评";
    }
    
    [cell.contentView addSubview:title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:info.testresult];
    
    if (indexPath.row ==0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的测试结果正常" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(indexPath.row == 1){
        
        //霍兰德
        NSString *result = [[NSString alloc]initWithFormat:@"%@",[dic objectForKey:@"holland"]];
        
        if (![result isEqualToString:@"(null)"]) {
            ResultVC *resultVc = [[ResultVC alloc]init];
            resultVc.detailStr = result;
            resultVc.isToRoot = NO;
            [self.navigationController pushViewController:resultVc animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，您号没有测试过，快给自己把把脉吧！" delegate:self cancelButtonTitle:@"好的"otherButtonTitles:@"取消", nil];
            alert.tag = 10000;
            [alert show];
        }
        
    }
    else if (indexPath.row == 2){
        
        //焦虑
        NSString *result = [[NSString alloc]initWithFormat:@"%@",[dic objectForKey:@"upset"]];
        
        if (![result isEqualToString:@"(null)"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:result delegate:self cancelButtonTitle:@"我自己能运功疗伤"otherButtonTitles:@"找咨询师给我把把脉",@"找找网上有啥解药", nil];
            alert.tag = 10087;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，您号没有测试过，快给自己把把脉吧！" delegate:self cancelButtonTitle:@"好的"otherButtonTitles:@"取消", nil];
            alert.tag = 10001;
            [alert show];
        }
        
    }
    else if (indexPath.row == 3){
        //抑郁
        NSString *result = [[NSString alloc]initWithFormat:@"%@",[dic objectForKey:@"depress"]];
        
        if (![result isEqualToString:@"(null)"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:result delegate:self cancelButtonTitle:@"我自己能运功疗伤"otherButtonTitles:@"找咨询师给我把把脉",@"找找网上有啥解药", nil];
            alert.tag = 10088;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，您号没有测试过，快给自己把把脉吧！" delegate:self cancelButtonTitle:@"好的"otherButtonTitles:@"取消", nil];
            alert.tag = 10002;
            [alert show];
        }
    }
    
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark- uialertviewdelgate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10086) {
//        if (buttonIndex == 1) {
//            HollandTestVC *advice = [[HollandTestVC alloc]init];
////            advice.advicetype = @"jiaolv5";
//            
//            [self.navigationController pushViewController:advice animated:YES];
//        }
//        else if(buttonIndex ==2){
//            HollandTestVC *advice = [[AdviceVC alloc]init];
//            advice.advicetype = @"kefujiaolvzhihu";
//            
//            [self.navigationController pushViewController:advice animated:YES];
//        }
    }
    else if (alertView.tag == 10000){
        if (buttonIndex == 0) {
            HollandTestVC *upset = [[HollandTestVC alloc]init];
            [self.navigationController pushViewController:upset animated:YES];
        }
    }
    else if (alertView.tag == 10087){
        if (buttonIndex == 1) {
            AdviceVC *advice = [[AdviceVC alloc]init];
            advice.advicetype = @"jiaolv5";
            
            [self.navigationController pushViewController:advice animated:YES];
        }
        else if(buttonIndex ==2){
            AdviceVC *advice = [[AdviceVC alloc]init];
            advice.advicetype = @"kefujiaolvzhihu";
            
            [self.navigationController pushViewController:advice animated:YES];
        }
    }
    else if (alertView.tag == 10000){
        if (buttonIndex == 0) {
            upsetVC *upset = [[upsetVC alloc]init];
            [self.navigationController pushViewController:upset animated:YES];
        }
    }
    else if (alertView.tag == 10088){
        if (buttonIndex == 1) {
            AdviceVC *advice = [[AdviceVC alloc]init];
            advice.advicetype = @"yiyu23";
            
            [self.navigationController pushViewController:advice animated:YES];
        }
        else if(buttonIndex ==2){
            AdviceVC *advice = [[AdviceVC alloc]init];
            advice.advicetype = @"zouchuyiyu";
            
            [self.navigationController pushViewController:advice animated:YES];
        }
    }
    else if (alertView.tag == 10002){
        if (buttonIndex == 0) {
            depressVC *depress = [[depressVC alloc]init];
            [self.navigationController pushViewController:depress animated:YES];
        }
    }
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
