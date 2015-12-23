//
//  LoginVC.m
//  Mood Diary
//
//  Created by SunCheng on 15-4-8.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "LoginVC.h"
#import "FindPasswordViewController.h"
#import "FindPwdVC.h"

@interface LoginVC ()

@end

@implementation LoginVC{
    CGFloat keyboardHeightChange;
    
    NSInteger buttonnum;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    [self initBackground];
    [self initScrollView];
    
    //self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:241/255.0 alpha:1.0];
    
    if(IS_IOS_7)
    {
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,nil]];
    }
    
    [self initloginpart];
    
    buttonnum = 1;
    
    if (_againLogin) {
        
        buttonnum = 2;
    }

    [self initbt];
    [self initKeyboardNotification];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    
    if (_againLogin) {
        [self.view showResult:ResultViewTypeFaild text:@"您还没有登录，请先登录"];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initKeyboardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}






- (void)initBackground{
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backgroundView.image = [UIImage imageNamed:@"logInBackground.jpg"];
    [self.view addSubview:backgroundView];
}

- (void)initScrollView{
    scrollView = [[UIView alloc]initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
}

-(void)initloginpart
{
    /*----Title----*/
    UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 37, 100, 25)];
    CGPoint center = titleLB.center;
    center.x = self.view.center.x;
    titleLB.center = center;
    
    titleLB.font = [UIFont boldSystemFontOfSize:25];
    titleLB.textColor = [UIColor whiteColor];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.text = @"心情日记";
    [scrollView addSubview:titleLB];
    
    /*----background----*/
    backview = [[UIView alloc]initWithFrame:CGRectMake(25, upsideheight+70, SCREEN_WIDTH-50, 160)];
    backview.backgroundColor = [UIColor whiteColor];
    backview.alpha = 0.2;
    backview.layer.cornerRadius = 5;
    [scrollView addSubview:backview];
    
    backview = [[UIView alloc]initWithFrame:CGRectMake(31, upsideheight+76, SCREEN_WIDTH-62, 148)];
    backview.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    backview.layer.cornerRadius = 5;
    [scrollView addSubview:backview];
    
    /*----account----*/
    backview = [[UIView alloc]initWithFrame:CGRectMake(20+18+10, upsideheight+20+80, SCREEN_WIDTH-40-36-20, 30)];
    backview.backgroundColor = [UIColor whiteColor];
    backview.layer.masksToBounds = YES;
    backview.layer.cornerRadius = 5;
    [scrollView addSubview:backview];
    
    UIImageView *userimg = [[UIImageView alloc]initWithFrame:CGRectMake(10, (30-25)/2, 25, 25)];
    userimg.image = [UIImage imageNamed:@"account"];
    [backview addSubview:userimg];
    
    useraccountTF = [[UITextField alloc]initWithFrame:CGRectMake(42, 0, SCREEN_WIDTH-40-90-10, 30)];
    useraccountTF.delegate = self;
    useraccountTF.font = [UIFont systemFontOfSize:14];
    useraccountTF.returnKeyType = UIReturnKeyNext;
    useraccountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    useraccountTF.placeholder = @"手机号码/用户名";
    useraccountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    if (userinfo.useraccount.length>0) {
        useraccountTF.text = userinfo.useraccount;
    }
    
    if ([userinfo.useraccount isEqualToString:@"(null)"]) {
        useraccountTF.text = @"";
    }
    
    [backview addSubview:useraccountTF];
    
    /*----password----*/
    backview = [[UIView alloc]initWithFrame:CGRectMake(20+18+10, upsideheight+40+20+10+20+70, SCREEN_WIDTH-40-36-20, 30)];
    backview.backgroundColor = [UIColor whiteColor];
    backview.layer.masksToBounds = YES;
    backview.layer.cornerRadius = 5;
    [scrollView addSubview:backview];
    
    UIImageView *pwdimg = [[UIImageView alloc]initWithFrame:CGRectMake(10,(30-25)/2,25,25)];
    pwdimg.image = [UIImage imageNamed:@"password"];
    [backview addSubview:pwdimg];
    
    pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(42, 0, SCREEN_WIDTH-40-90-10, 30)];
    pwdTF.delegate = self;
    pwdTF.font = [UIFont systemFontOfSize:14];
    pwdTF.returnKeyType = UIReturnKeyDone;
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTF.placeholder = @"密码";
    pwdTF.secureTextEntry = YES;
    pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [backview addSubview:pwdTF];

}

-(void)initbt
{
    
    NSArray *titlearr = [NSArray arrayWithObjects:@"登      陆",@"返       回",@"注      册", nil];
    
    for (int i=0; i<buttonnum; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20+40, backview.frame.origin.y+62+i*50+50, SCREEN_WIDTH-40-80, 40)];
        button.tag = i;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.backgroundColor = [UIColor colorWithRed:65/255.0 green:211/255.0 blue:148/255.0 alpha:1.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [button setTitle:[titlearr objectAtIndex:i] forState:UIControlStateNormal];
        [scrollView addSubview:button];
        [button addTarget:self action:@selector(loginclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    /*----keyForgetButton----*/
    UIButton *keyForgetButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-105, upsideheight+70+160, 80, 20)];
    keyForgetButton.backgroundColor = [UIColor clearColor];
    keyForgetButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [keyForgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [keyForgetButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [keyForgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [scrollView addSubview:keyForgetButton];
    [keyForgetButton addTarget:self action:@selector(forgetPasswordClicked) forControlEvents:UIControlEventTouchUpInside];
    
    /*----signUpButton----*/
    UIButton *signUpButton = [[UIButton alloc]initWithFrame:CGRectMake(30, upsideheight+70+160, 40, 20)];
    signUpButton.backgroundColor = [UIColor clearColor];
    signUpButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [signUpButton setTitle:@"注册" forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [scrollView addSubview:signUpButton];
    [signUpButton addTarget:self action:@selector(signUpClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action
-(void)userlogin
{
    if (useraccountTF.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (pwdTF.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    self.view.userInteractionEnabled = NO;
    [self.view showProgress:YES text:@"请等待..."];
    
    UserInfo *userinfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    
    NSMutableDictionary *temdic = [[NSMutableDictionary alloc]init];
    
    if (userinfo.testresult) {
        temdic = userinfo.testresult;
    }
    
    [AppWebService userLoginWithAccount:useraccountTF.text loginpwd:pwdTF.text success:^(id result) {
        NSLog(@"success");
        [self.view showProgress:NO];
        self.view.userInteractionEnabled = YES;
        NSDictionary *temdata  = [result objectForKey:@"data"];
        NSDictionary *infoDic = [[NSDictionary alloc]initWithDictionary:[temdata objectForKey:@"account"]];
        
        UserInfo *userinfo  = [[UserInfo alloc]init];
        userinfo.testresult = temdic;
        userinfo.accountType = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"accountType"]];
        userinfo.birthday = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"birthday"]];
        userinfo.email = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"email"]];
        userinfo.userid = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"userid"]];
        userinfo.idCard = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"idCard"]];
        userinfo.loginCount = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"loginCount"]];
        userinfo.name = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"name"]];
        userinfo.nickname = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"nickname"]];
        userinfo.phone = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"phone"]];
        userinfo.photo = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"photo"]];
        userinfo.registerDate = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"registerDate"]];
        userinfo.sex = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sex"]];
        userinfo.signature = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"signature"]];
        userinfo.status = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"status"]];
        userinfo.useraccount = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"username"]];
        userinfo.password = pwdTF.text;
        
        [NSUserDefaults setUserObject:userinfo forKey:USER_STOKRN_KEY];
        [NSUserDefaults setBool:YES forKey:IS_LOGIN];
        
        if (_againLogin) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_TO_CONTROLLER object:nil];
        }
        
        
        
    } failed:^(NSError *error) {
        NSLog(@"fail");
        [self.view showProgress:NO];
        self.view.userInteractionEnabled = YES;
        [self.view showResult:ResultViewTypeFaild text:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

-(void)loginclicked:(UIButton *)sender
{
    if (sender.tag == 0) {
        //登陆
//        [useraccountTF resignFirstResponder];
//        [pwdTF resignFirstResponder];
        [self userlogin];
    }
    else if (sender.tag == 1)
    {
        //体验
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else if (sender.tag ==2)
    {
        //注册
    }
}

- (void)forgetPasswordClicked{
    NSLog(@"forgetPassword!");
    FindPwdVC *find = [[FindPwdVC alloc]init];
    find.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:find animated:YES];
}

- (void)signUpClicked{
    NSLog(@"Sign Up!");
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == useraccountTF) {
        [useraccountTF resignFirstResponder];
        [pwdTF becomeFirstResponder];
    }
    else
    {
        [pwdTF resignFirstResponder];
        [self userlogin];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KeyboardNotification
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGFloat keyboardframeY =SCREEN_HEIGHT-keyboardSize.height;
    CGFloat bottomButtonYwithHeight =backview.frame.origin.y+152;
    if( keyboardframeY < bottomButtonYwithHeight ){
        CGRect containerFrame = scrollView.frame;
        containerFrame.origin.y =keyboardframeY - bottomButtonYwithHeight-keyboardHeightChange;
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.25];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            scrollView.frame = containerFrame;
        }];
    }


}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect containerFrame = scrollView.frame;
    containerFrame.origin.y = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        scrollView.frame = containerFrame;
    }];
}

- (void)keyboardWillChange:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *beginValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue *endValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize beginKeyboardSize = [beginValue CGRectValue].size;
    CGSize endKeyboardSize = [endValue CGRectValue].size;
    keyboardHeightChange= endKeyboardSize.height - beginKeyboardSize.height;
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
