//
//  AlertPwdViewController.m
//  FlowMng
//
//  Created by tysoft on 14-3-13.
//  Copyright (c) 2014年 key. All rights reserved.
//

#import "AlertPwdViewController.h"
#import "AppWebService.h"
#import "UserInfo.h"

@interface AlertPwdViewController ()

@end

@implementation AlertPwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"密码设置";
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [self initView];
    
    // Do any additional setup after loading the view.
}
-(void)initView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(70,  15, SCREEN_WIDTH - 80, 39)];
    NSLog(@"%f",bgView.frame.size.height);
    if (IS_IOS_7) {
        bgView.frame=CGRectMake(70, 94, SCREEN_WIDTH - 80, 39);
    }
    
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6;
    bgView.layer.borderWidth = 0;
    [self.view addSubview:bgView];
    
    
    UILabel* textFieldLable=[[UILabel alloc]initWithFrame:CGRectMake(5, bgView.frame.origin.y, 70, 39)];
    textFieldLable.text=@"旧 密 码:";
    textFieldLable.backgroundColor =[UIColor clearColor];
    textFieldLable.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:textFieldLable];
    textFieldLable.font= [UIFont systemFontOfSize:14];
    
    
    
    orPwdTx = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, bgView.frame.size.width - 20, 39)];
    orPwdTx.textColor = [UIColor blackColor];
    orPwdTx.delegate = self;
    orPwdTx.placeholder = @"请输入旧密码";
    orPwdTx.font = [UIFont systemFontOfSize:14];
    orPwdTx.clearButtonMode = UITextFieldViewModeAlways;
    orPwdTx.returnKeyType = UIReturnKeyNext;
    orPwdTx.keyboardType= UIKeyboardTypeNumbersAndPunctuation;
    orPwdTx.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    orPwdTx.backgroundColor = [UIColor clearColor];
    [orPwdTx becomeFirstResponder];
    orPwdTx.secureTextEntry = YES;
    [bgView addSubview:orPwdTx];
    
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(70, 65, SCREEN_WIDTH - 80, 39)];
    if (IS_IOS_7) {
        bgView.frame=CGRectMake(70, 89 + 64,  SCREEN_WIDTH - 80, 39);
    }
    
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6;
    bgView.layer.borderWidth = 0;
    [self.view addSubview:bgView];
    
    textFieldLable=[[UILabel alloc]initWithFrame:CGRectMake(5, bgView.frame.origin.y, 70, 39)];
    textFieldLable.text=@"新 密 码:";
    textFieldLable.backgroundColor=[UIColor clearColor];
    textFieldLable.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:textFieldLable];
    textFieldLable.font= [UIFont systemFontOfSize:14];
    
    newPwdTx = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, bgView.frame.size.width - 20, 39)];
    newPwdTx.textColor = [UIColor blackColor];
    newPwdTx.delegate = self;
    newPwdTx.placeholder = @"请输入新密码";
    newPwdTx.font = [UIFont systemFontOfSize:14];
    newPwdTx.clearButtonMode = UITextFieldViewModeAlways;
    newPwdTx.returnKeyType = UIReturnKeyNext;
    newPwdTx.keyboardType= UIKeyboardTypeNumbersAndPunctuation;
    newPwdTx.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newPwdTx.backgroundColor = [UIColor clearColor];
    newPwdTx.secureTextEntry = YES;
    [bgView addSubview:newPwdTx];
    
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(70, 115, SCREEN_WIDTH - 80, 39)];
    
    if (IS_IOS_7) {
        bgView.frame=CGRectMake(70, 148 + 64, SCREEN_WIDTH - 80, 39);
    }
    
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6;
    bgView.layer.borderWidth = 0;
    [self.view addSubview:bgView];
    
    
    textFieldLable=[[UILabel alloc]initWithFrame:CGRectMake(5, bgView.frame.origin.y, 70, 39)];
    textFieldLable.text=@"确认密码:";
    textFieldLable.backgroundColor=[UIColor clearColor];
    textFieldLable.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:textFieldLable];
    textFieldLable.font= [UIFont systemFontOfSize:14];
    
    
    rnewPwdTx = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, bgView.frame.size.width - 20, 39)];
    rnewPwdTx.textColor = [UIColor blackColor];
    rnewPwdTx.delegate = self;
    rnewPwdTx.secureTextEntry = YES;
    rnewPwdTx.placeholder = @"请输入确认密码";
    rnewPwdTx.font = [UIFont systemFontOfSize:14];
    rnewPwdTx.clearButtonMode = UITextFieldViewModeAlways;
    rnewPwdTx.returnKeyType = UIReturnKeyDone;
    rnewPwdTx.keyboardType= UIKeyboardTypeNumbersAndPunctuation;
    rnewPwdTx.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    rnewPwdTx.backgroundColor = [UIColor clearColor];
    [rnewPwdTx becomeFirstResponder];
    [bgView addSubview:rnewPwdTx];
    
    //添加按钮
    UIButton *sureBtn= [[UIButton alloc]initWithFrame:CGRectMake(30, bgView.frame.origin.y + 60, SCREEN_WIDTH-60, 40)];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 6;
    [sureBtn addTarget:self action:@selector(alertPwdDone) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确  定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sureBtn];

    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == orPwdTx) {
        [newPwdTx becomeFirstResponder];
    }else if(textField == newPwdTx){
        [rnewPwdTx becomeFirstResponder];
    }else {
        [rnewPwdTx resignFirstResponder];
    }
    return YES;
}

-(void)alertPwdDone {

    if (orPwdTx.text.length==0) {
        [self.view showResult:ResultViewTypeFaild text:@"旧密码不能为空"];
        return;
    }
    if ( newPwdTx.text.length==0) {
        [self.view showResult:ResultViewTypeFaild text:@"新密码不能为空"];
        return;
    }else if (newPwdTx.text.length>39)
    {
        [self.view showResult:ResultViewTypeFaild text:@"密码不能超过39个字符"];
        return;
    
    }
    
    if ( rnewPwdTx.text.length==0) {
        [self.view showResult:ResultViewTypeFaild text:@"确认码不能为空"];
        return;
    }else if (rnewPwdTx.text.length>39)
    {
        [self.view showResult:ResultViewTypeFaild text:@"密码不能超过39个字符"];
        return;
        
    }
    else if (![newPwdTx.text isEqualToString:rnewPwdTx.text])
    {
        [self showAlertViewTitle:@"提示" message:@"两次输入的密码不一样"];
        return;
    }
    
    [self.view showProgress:YES];
    //修改密码接口
    [AppWebService changepwd:orPwdTx.text newpwd:newPwdTx.text success:^(id result) {
        [self.view showProgress:NO];
        [self.view showResult:ResultViewTypeOK text:@"修改密码成功"];
    } failed:^(NSError *error) {
        [self.view showProgress:NO];
        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

-(BOOL)hasSpecialChar:(NSString*)myString
{
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSRange userNameRange = [myString rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location != NSNotFound) {
        NSLog(@"包含特殊字符");
        return YES;
    }
    
    return NO;
    
}
//校验密码中是否格式正确 - 包含数字和字母
-(BOOL)checkPassWord:(NSString*)pPassword
{
    //數字條件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    //符合數字條件的有幾個字元
    NSInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:pPassword
                                                                options:NSMatchingReportProgress
                                                                  range:NSMakeRange(0, pPassword.length)];
    
    //英文字條件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字條件的有幾個字元
    NSInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:pPassword options:NSMatchingReportProgress range:NSMakeRange(0, pPassword.length)];
    
    
    if (tNumMatchCount == pPassword.length)
        
    {
        //全部符合數字，表示沒有英文
        NSLog(@"全部为數字，表示沒有英文");
        return NO;
    }
    else if (tLetterMatchCount == pPassword.length)
    {
        //全不符合英文，表示沒有數字
        NSLog(@"全部为英文，表示沒有数字");
        return NO;
    }
    else if (tNumMatchCount + tLetterMatchCount == pPassword.length)
    {
        
        //符合英文和符合數字條件的相加等於密碼長度
        NSLog(@"符合英文和符合數字條件的相加等於密碼長度");
        return YES;
    }
    else
    {
        //可能包含標點符號的情況，或是包含非英文的文字，這裡再依照需求詳細判斷想呈現的錯誤
        NSLog(@"可能包含標點符號的情況，或是包含非英文的文字，這裡再依照需求詳細判斷想呈現的錯誤");
        NSString* passWordTip=[NSUserDefaults objectUserForKey:PASSWORDTIP];
        if ([passWordTip isEqualToString:@"-20"]) {
            return YES;
        }else if ([passWordTip isEqualToString:@"-30"])
        {
            
            return YES;
        }
    }
    return NO;
}

#pragma mark- uialertviewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1234) {
        //设置登陆状态为no
        [NSUserDefaults setBool:NO forKey:IS_LOGIN];
        //设置记住密码为no
        [NSUserDefaults setBool:NO forKey:IS_REMIND_PWD];
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_TO_CONTROLLER object:nil];
    }
}
-(void)popBack
{
    [super popBack];
    
}
-(void)dealloc {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
