//
//  SpecificVC.m
//  Mood Diary
//
//  Created by Sunc on 15-4-9.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "SpecificVC.h"
#import "AboutusVC.h"
#import "NewTestVC.h"
#import "HollandTestVC.h"
#import "UpiVC.h"

@interface SpecificVC ()

@end

@implementation SpecificVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"测评说明"];
    [self initdetail];
    self.view.backgroundColor =[UIColor whiteColor];
}

- (void)hollandSetdone{
    hollanddone = YES;
}

- (void)setdone
{
    done = YES;
}

-(void)initdetail
{
    if (done&&[_testtype isEqualToString:@"SCL90"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已完成测评！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"关于我们",@"退出登录", nil];
        alert.tag = 0;
        [alert show];
        return;
    }
    
    if (hollanddone&&[_testtype isEqualToString:@"霍兰德"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已完成测评！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"关于我们",@"退出登录", nil];
        alert.tag = 0;
        [alert show];
        return;
    }
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, upsideheight+10, SCREEN_WIDTH-40, 100)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:13];
    label1.lineBreakMode = NSLineBreakByCharWrapping;
    label1.numberOfLines = 0;
    label1.text = _content1;
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, label1.frame.origin.y+100, SCREEN_WIDTH-40, 230)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:13];
    label2.lineBreakMode = NSLineBreakByCharWrapping;
    label2.numberOfLines = 0;
    label2.text = _content2;
    [self.view addSubview:label2];
    
    if ([_testtype isEqualToString:@"霍兰德"]) {
        label1.frame = CGRectMake(20, upsideheight+40, SCREEN_WIDTH-40, 100);
        [label1 removeFromSuperview];
        [self.view addSubview:label1];
    }
    
    confirmBt = [[UIButton alloc]initWithFrame:CGRectMake(20, label2.frame.origin.y+210+20, SCREEN_WIDTH-40, 40)];
    [confirmBt setTitle:@"确认" forState:UIControlStateNormal];
    
//    #warning 正式发布时，interaction改为no
    confirmBt.userInteractionEnabled = YES;
    confirmBt.layer.masksToBounds = YES;
    confirmBt.layer.cornerRadius = 5;
    confirmBt.backgroundColor = [UIColor lightGrayColor];
    [confirmBt addTarget:self action:@selector(confirmbtclicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBt];
    
    [self counttime];
}

-(void)confirmbtclicked
{
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    if ([userinfo.accountType isEqualToString:@"3"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您已完成%@测评",_testtype] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        alert.tag = 0;
        [alert show];
    }
    else
    {
        if ([_testtype isEqualToString:@"SCL90"]) {
            NewTestVC *test = [[NewTestVC alloc]init];
            [self.navigationController pushViewController:test animated:YES];
        }
        else if ([_testtype isEqualToString:@"霍兰德"]){
            HollandTestVC *test = [[HollandTestVC alloc]init];
            [self.navigationController pushViewController:test animated:YES];
        }
        else if ([_testtype isEqualToString:@"UPI"]){
            UpiVC *upi = [[UpiVC alloc]init];
            [self.navigationController pushViewController:upi animated:YES];
        }
        
    }
}

-(void)counttime
{
    __block int timeout=15; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                confirmBt.userInteractionEnabled = YES;
                confirmBt.backgroundColor = [UIColor colorWithRed:71/255.0 green:228/255.0 blue:160/255.0 alpha:1.0];
                confirmBt.titleLabel.font = [UIFont systemFontOfSize:16];
                [confirmBt setTitle:@"确认" forState:UIControlStateNormal];
            });
        }else{
            //            int minutes = timeout / 60;
            //            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"确认(%ds)", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                confirmBt.titleLabel.font = [UIFont systemFontOfSize:16];
                [confirmBt setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark -uialertviewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        AboutusVC *about = [[AboutusVC alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
    else
    {
        if (buttonIndex == 2) {
            [self.view showProgress:YES text:@"请等待..."];
            [AppWebService userLogoutWithAccount:nil success:^(id result) {
                NSLog(@"logout success");
                [self.view showProgress:NO];
                [NSUserDefaults setBool:NO forKey:IS_LOGIN];
                [[NSNotificationCenter defaultCenter]postNotificationName:GO_TO_CONTROLLER object:nil];
            } failed:^(NSError *error) {
                NSLog(@"fail");
                [self.view showProgress:NO];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.delegate = self;
                [alert show];
            }];
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
