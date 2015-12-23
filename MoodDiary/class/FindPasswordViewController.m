//
//  FindPasswordViewController.m
//  inteLook
//
//  Created by Sunc on 15-3-3.
//  Copyright (c) 2015年 whtysf. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "UserInfo.h"

@interface FindPasswordViewController ()<UIAlertViewDelegate>

@end

@implementation FindPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回密码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.navigationBar.translucent = YES;
    
    if (IS_IOS_7) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    }
    
    [self initWithScrollView];
    [self initInputPhoneNum];
    [self initchangePwdView];
    
    
}

//服务器设置界面上拉试图初始化
-(void)initWithScrollView
{
    //定义scrollview
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, upsideheight, self.view.frame.size.width, self.view.frame.size.height-64)];
    mainScrollView.backgroundColor = [UIColor whiteColor];
    //设置代理
    mainScrollView.delegate=self;
    if (IS_IOS_7) {
        mainScrollView.contentSize=CGSizeMake(self.view.frame.size.width,700);
        
    }else
    {
        mainScrollView.contentSize=CGSizeMake(self.view.frame.size.width,600);
        
    }
    [self.view addSubview:mainScrollView];
}

-(void)initInputPhoneNum
{
    UIView *backeview = [[UIView alloc]initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH-40, 38)];
    backeview.layer.cornerRadius = 6;
    backeview.layer.borderWidth = 1;
    backeview.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    backeview.layer.masksToBounds = YES;
    backeview.backgroundColor = [UIColor colorWithRed:186/255.0 green:233/255.0 blue:208/255.0 alpha:1.0];
    [mainScrollView addSubview:backeview];
    
    UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 38)];
    telLabel.text = @"中国  +86";
    telLabel.textColor = [UIColor blackColor];
    telLabel.font = [UIFont systemFontOfSize:14];
    telLabel.backgroundColor = [UIColor clearColor];
    [backeview addSubview: telLabel];
    
    phoneNumTx = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-100-20, 38)];
    phoneNumTx.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phoneNumTx.returnKeyType = UIReturnKeyDone;
    phoneNumTx.font = [UIFont systemFontOfSize:14];
    phoneNumTx.tag = 0;
    phoneNumTx.backgroundColor = [UIColor clearColor];
    phoneNumTx.placeholder = @"请输入手机号码";

    phoneNumTx.textColor = [UIColor blackColor];
    phoneNumTx.delegate = self;
    phoneNumTx.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [backeview addSubview:phoneNumTx];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(90, 0, 1, 38)];
    line.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [backeview addSubview:line];
    
    nextStepbt = [[UIButton alloc]initWithFrame:CGRectMake(20, 93, SCREEN_WIDTH-40, 40)];
    [nextStepbt setTitle:@"获取验证码" forState:UIControlStateNormal];
    [nextStepbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStepbt addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepbt setBackgroundImage:nil forState:UIControlStateNormal];
    nextStepbt.backgroundColor = [UIColor colorWithRed:228/255.0 green:229/255.0 blue:231/255.0 alpha:1.0];
    nextStepbt.layer.masksToBounds = YES;
    nextStepbt.layer.cornerRadius = 5;
    nextStepbt.userInteractionEnabled = NO;
    nextStepbt.titleLabel.font = [UIFont systemFontOfSize:16];
    [mainScrollView addSubview:nextStepbt];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:phoneNumTx];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:newPwd];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:repeatPwd];
}

-(BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^((13[0-9])|(14[^7,\\D])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)nextStep:(NSString *)sender
{
    if (![self isMobileNumber:phoneNumTx.text]) {
        //请输入正确的手机号
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (phoneNumTx.text.length == 0) {
        //手机号不能为空
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号不能为空！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
  
    //获取验证码
    if ([self isMobileNumber:phoneNumTx.text]) {
        nextStepbt.userInteractionEnabled = NO;
        [nextStepbt setBackgroundImage:nil forState:UIControlStateNormal];
        nextStepbt.backgroundColor = [UIColor colorWithRed:228/255.0 green:229/255.0 blue:231/255.0 alpha:1.0];
        [self.view showProgress:YES];
    //获取验证码
        [AppWebService getcode:phoneNumTx.text success:^(id result) {
            [self.view showProgress:NO];
            [self.view showResult:ResultViewTypeOK text:@"验证码已发送，请耐心等待"];
    showchangeview = YES;
    [self.view showProgress:NO];
    
    nextStepbt.userInteractionEnabled = NO;
                [confirm setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [self getverifycodedone];
    [self fcounttime];
    
        } failed:^(NSError *error) {
            [self.view showProgress:NO];
            [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    nextStepbt.userInteractionEnabled = YES;
    nextStepbt.backgroundColor = [UIColor clearColor];
        }];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil,nil];
        [alert show];
    }
}

-(void)fcounttime
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                nextStepbt.userInteractionEnabled = YES;
                nextStepbt.backgroundColor = [UIColor clearColor];
                [nextStepbt setBackgroundImage:[UIImage imageNamed:@"green_bg"] forState:UIControlStateNormal];
                nextStepbt.titleLabel.font = [UIFont systemFontOfSize:14];
                [nextStepbt setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else{
            //            int minutes = timeout / 60;
            //            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"剩余 %d秒", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                nextStepbt.titleLabel.font = [UIFont systemFontOfSize:16];
                [nextStepbt setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)delay:(int)sender
{
    __block int timeout=sender; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self popBack];
            });
        }else{
            //            int minutes = timeout / 60;
            //            int seconds = timeout % 60;
            
//            NSString *strTime = [NSString stringWithFormat:@"%d秒后重新获取验证码", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置

            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(void)getverifycodedone
{
    //下一步,一定注意先验证手机号
    [self showview:showchangeview];
    [checkcode becomeFirstResponder];
}

-(void)showview:(BOOL)sender
{
    if (sender) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
        frontview.frame = CGRectMake(SCREEN_WIDTH*2, 228, SCREEN_WIDTH, 170);
        
        [UIView setAnimationDelegate:self];
        // 动画完毕后调用animationFinished
        [UIView setAnimationDidStopSelector:@selector(animationFinished)];
        [UIView commitAnimations];
    }
}

-(void)hideview:(BOOL)sender
{
    if (sender) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
        frontview.frame = CGRectMake(SCREEN_WIDTH, 228, SCREEN_WIDTH, 170);
        
        [UIView setAnimationDelegate:self];
        // 动画完毕后调用animationFinished
        [UIView setAnimationDidStopSelector:@selector(animationFinished)];
        [UIView commitAnimations];
    }
}

-(void)animationFinished
{
    
}

-(void)initchangePwdView
{
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 158, SCREEN_WIDTH, 250)];
    backview.backgroundColor = [UIColor clearColor];
    [mainScrollView addSubview:backview];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 38)];
    bgview.backgroundColor = [UIColor colorWithRed:186/255.0 green:233/255.0 blue:208/255.0 alpha:1.0];
    bgview.layer.masksToBounds = YES;
    bgview.layer.cornerRadius = 5;
    checkcode = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-60, 38)];
    checkcode.backgroundColor = [UIColor clearColor];
    checkcode.keyboardType = UIKeyboardTypeDefault;
    checkcode.returnKeyType = UIReturnKeyNext;
    checkcode.font = [UIFont systemFontOfSize:14];
    checkcode.tag = 1;
    checkcode.backgroundColor = [UIColor colorWithRed:186/255.0 green:233/255.0 blue:208/255.0 alpha:1.0];
    checkcode.placeholder = @"  请输入验证码";
    checkcode.textColor = [UIColor blackColor];
    checkcode.delegate = self;
    checkcode.layer.masksToBounds = YES;
    checkcode.layer.cornerRadius = 5;
    checkcode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bgview addSubview:checkcode];
    [backview addSubview:bgview];
    
    bgview = [[UIView alloc]initWithFrame:CGRectMake(20, 63, SCREEN_WIDTH-40, 38)];
    bgview.backgroundColor = [UIColor colorWithRed:186/255.0 green:233/255.0 blue:208/255.0 alpha:1.0];
    bgview.layer.masksToBounds = YES;
    bgview.layer.cornerRadius = 5;
    newPwd = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-60, 38)];
    newPwd.backgroundColor = [UIColor clearColor];
    newPwd.keyboardType = UIKeyboardTypeDefault;
    newPwd.returnKeyType = UIReturnKeyNext;
    newPwd.font = [UIFont systemFontOfSize:14];
    newPwd.tag = 2;
    newPwd.backgroundColor = [UIColor colorWithRed:186/255.0 green:233/255.0 blue:208/255.0 alpha:1.0];
    newPwd.placeholder = @"  请输入新密码";
    newPwd.textColor = [UIColor blackColor];
    newPwd.delegate = self;
    newPwd.layer.masksToBounds = YES;
    newPwd.layer.cornerRadius = 5;
    newPwd.secureTextEntry = YES;
    newPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bgview addSubview:newPwd];
    [backview addSubview:bgview];
    
    bgview = [[UIView alloc]initWithFrame:CGRectMake(20, 126, SCREEN_WIDTH-40, 38)];
    bgview.backgroundColor = [UIColor colorWithRed:186/255.0 green:233/255.0 blue:208/255.0 alpha:1.0];
    bgview.layer.masksToBounds = YES;
    bgview.layer.cornerRadius = 5;
    repeatPwd = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-60, 38)];
    repeatPwd.keyboardType = UIKeyboardTypeDefault;
    repeatPwd.returnKeyType = UIReturnKeyDone;
    repeatPwd.font = [UIFont systemFontOfSize:14];
    repeatPwd.tag = 3;
    repeatPwd.backgroundColor = [UIColor clearColor];
    repeatPwd.placeholder = @"  再输入新密码";
    repeatPwd.textColor = [UIColor blackColor];
    repeatPwd.delegate = self;
    repeatPwd.layer.masksToBounds = YES;
    repeatPwd.layer.cornerRadius = 5;
    repeatPwd.secureTextEntry = YES;
    repeatPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bgview addSubview:repeatPwd];
    [backview addSubview:bgview];
    
    confirm = [[UIButton alloc]initWithFrame:CGRectMake(20, 189, SCREEN_WIDTH-40, 38)];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm setTitle:@"确认修改" forState:UIControlStateNormal];
    [confirm setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    confirm.layer.masksToBounds = YES;
    confirm.layer.cornerRadius = 5;
    [confirm addTarget:self action:@selector(confirmclicked) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:confirm];
    
    frontview = [[UIView alloc]initWithFrame:CGRectMake(0, 158, SCREEN_WIDTH, 227)];
    frontview.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:frontview];
    
}

-(void)confirmclicked
{
    //确认修改密码方法
    
    if ( checkcode.text.length==0) {
        [self.view showResult:ResultViewTypeFaild text:@"验证码不能为空"];
        return;
    }
    
    //新密码
    if ( newPwd.text.length==0) {
        [self.view showResult:ResultViewTypeFaild text:@"新密码不能为空"];
        return;
    }else if (newPwd.text.length>39)
    {
        [self.view showResult:ResultViewTypeFaild text:@"密码不能超过39个字符"];
        return;
        
    }
    //第二次输入
    if ( repeatPwd.text.length==0) {
        [self.view showResult:ResultViewTypeFaild text:@"确认码不能为空"];
        return;
    }
    else if (repeatPwd.text.length>39)
    {
        [self.view showResult:ResultViewTypeFaild text:@"密码不能超过39个字符"];
        return;
        
    }
    else if (![newPwd.text isEqualToString:repeatPwd.text])
    {
        [self showAlertViewTitle:@"提示" message:@"两次输入的密码不一样"];
        return;
    }
    //调用修改密码方法
    //调用登录方法
    [self.view showProgress:YES];
    [AppWebService changepwdbycode:checkcode.text phonenum:phoneNumTx.text newpwd:newPwd.text success:^(id result) {
        [self.view showProgress:NO];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码重置成功" delegate:self cancelButtonTitle:@"返回登陆页面" otherButtonTitles:nil, nil];
        [alert show];
    } failed:^(NSError *error) {
        [self.view showProgress:NO];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil,nil];
        [alert show];
        
    }];
    
}

#pragma mark - uitextfielddelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == newPwd) {
        NSLog(@"%f",repeatPwd.frame.origin.y+158+38+63+64);
        NSLog(@"%f",SCREEN_HEIGHT-keyboardheight);
        if ((SCREEN_HEIGHT-keyboardheight)<63+158+38+63+64) {
            NSLog(@"%f",repeatPwd.frame.origin.y+158+38+63+64);
            NSLog(@"%f",SCREEN_HEIGHT-keyboardheight);
            [mainScrollView setContentOffset:CGPointMake(0, 130) animated:YES];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0) {
        //电话号码
    }
    else if (textField.tag == 1)
    {
        //验证码
        [checkcode resignFirstResponder];
        [newPwd becomeFirstResponder];
    }
    else if (textField.tag == 2)
    {
        //新密码
        [newPwd resignFirstResponder];
        [repeatPwd becomeFirstResponder];
    }
    else if (textField.tag == 3)
    {
        //确认密码
        [newPwd resignFirstResponder];
        [repeatPwd resignFirstResponder];
        //调用找回密码方法
        [self confirmclicked];
    }
    return YES;
}

- (void)textFieldChanged:(id)sender
{
    if (phoneNumTx.text.length > 0) {
        nextStepbt.backgroundColor = [UIColor clearColor];
        [nextStepbt setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        nextStepbt.userInteractionEnabled = YES;
    }else{
        nextStepbt.backgroundColor = [UIColor colorWithRed:186/255.0 green:233/255.0 blue:208/255.0 alpha:1.0];
        [nextStepbt setBackgroundImage:nil forState:UIControlStateNormal];
        nextStepbt.userInteractionEnabled = NO;
    }
    
    if ((newPwd.text.length > 0)&&(newPwd.editing)) {
        newPwd.clearButtonMode = UITextFieldViewModeAlways;
    }
    else
    {
        newPwd.clearButtonMode = UITextFieldViewModeNever;
    }
    
    if ((repeatPwd.text.length > 0)&&(repeatPwd.editing)) {
        repeatPwd.clearButtonMode = UITextFieldViewModeAlways;
    }
    else
    {
        repeatPwd.clearButtonMode = UITextFieldViewModeNever;
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [phoneNumTx resignFirstResponder];
    [newPwd resignFirstResponder];
    [repeatPwd resignFirstResponder];
    [checkcode resignFirstResponder];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    mainScrollView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if (textField == repeatPwd) {
        [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark-keyboardHight

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    keyboardheight = kbSize.height;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- uialertviewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
