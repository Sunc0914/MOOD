//
//  MyVC.m
//  Mood Diary
//
//  Created by Sunc on 15/6/17.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "MyVC.h"
#import "PersonalInfoVC.h"
#import "QueryVC.h"
#import "AboutusVC.h"
#import "AlertPwdViewController.h"
#import "MyCollectionsViewController.h"
#import "MyTestVC.h"

@interface MyVC ()

@property (nonatomic) CGFloat height;

@end

@implementation MyVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 120, 50)];
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=[UIColor whiteColor];
    [titleText setFont:[UIFont systemFontOfSize:15.0]];
    [titleText setText:@"个人信息"];
    self.navigationItem.titleView=titleText;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _height = 60;
    [self initsettable];
}

- (void)initsettable{
    settable = [[UITableView alloc]initWithFrame:CGRectMake(0, upsideheight, SCREEN_WIDTH, SCREEN_HEIGHT-49-upsideheight)];
    settable.delegate = self;
    settable.dataSource = self;
    
    settable.tableFooterView = [[UIView alloc]init];
    
    CGRect frame = settable.tableHeaderView.frame;
    frame.size.height = 25;
    
    [self.view addSubview:settable];
    
}

- (void)logoutbtclicked{
    [AppWebService logoutsuccess:^(id result) {
        
        [NSUserDefaults setBool:NO forKey:IS_LOGIN];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_TO_CONTROLLER object:nil];
        
    } failed:^(NSError *error) {
        
        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

#pragma mark - uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 70;
    }
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
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 6, _height-12, _height-12)];
    imgview.layer.masksToBounds = YES;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(imgview.frame.origin.x + imgview.frame.size.width +10, 2, 200, _height-4)];
    
    if (indexPath.row == 0) {
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"set1"];
        title.text = @"账户设置";
    }
    else if (indexPath.row == 1){
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"set2"];
        title.text = @"密码设置";
    }
    else if (indexPath.row ==2){
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"set3"];
        title.text = @"测评记录";
    }
    else if (indexPath.row == 3){
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"set4"];
        title.text = @"心理咨询";
    }
    else if (indexPath.row == 4){
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"set5"];
        title.text = @"我的收藏";
    }
    else if (indexPath.row == 5){
        imgview.backgroundColor = [UIColor clearColor];
        imgview.image = [UIImage imageNamed:@"set6"];
        title.text = @"关      于";
    }
    
    [cell.contentView  addSubview:imgview];
    [cell.contentView addSubview:title];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        view.backgroundColor = [UIColor clearColor];
        
        UIButton *logoutBt = [[UIButton alloc]initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH-60, _height-20)];
        [logoutBt addTarget:self action:@selector(logoutbtclicked) forControlEvents:UIControlEventTouchUpInside];
        logoutBt.layer.masksToBounds = YES;
        logoutBt.layer.cornerRadius = 5;
        
        logoutBt.backgroundColor = [UIColor colorWithRed:200/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        [logoutBt setTitle:@"注  销  登  陆" forState:UIControlStateNormal];
        [logoutBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
//        line.backgroundColor = [UIColor lightGrayColor];
        
        [view addSubview:line];
        
        [view addSubview:logoutBt];
        
        return view;
    }
    
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (indexPath.row ==0) {
        
        if (![NSUserDefaults boolForKey:IS_LOGIN]) {
            //没有登录
            [self showLoginWindow];
            return;
        }
        
        PersonalInfoVC *personal = [[PersonalInfoVC alloc]init];
        personal.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personal animated:YES];
    }
    else if(indexPath.row == 3){
        QueryVC *query = [[QueryVC alloc]init];
        query.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:query animated:YES];
    }
    else if (indexPath.row == 5){
        AboutusVC *about = [[AboutusVC alloc]init];
        about.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:about animated:YES];
    }
    else if (indexPath.row == 1){
        
        if (![NSUserDefaults boolForKey:IS_LOGIN]) {
            //没有登录
            [self showLoginWindow];
            return;
        }
        
        AlertPwdViewController *changepwd = [[AlertPwdViewController alloc]init];
        changepwd.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changepwd animated:YES];
    }
    else if (indexPath.row == 4){
        
        if (![NSUserDefaults boolForKey:IS_LOGIN]) {
            //没有登录
            [self showLoginWindow];
            return;
        }
        
        MyCollectionsViewController *myCollectionsViewController=[[MyCollectionsViewController alloc]init];
        myCollectionsViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myCollectionsViewController animated:YES];
    }
    else if (indexPath.row == 2){
        
        if (![NSUserDefaults boolForKey:IS_LOGIN]) {
            //没有登录
            [self showLoginWindow];
            return;
        }
        
        MyTestVC *mytest=[[MyTestVC alloc]init];
         mytest.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mytest animated:YES];
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
