//
//  LoginVC.h
//  Mood Diary
//
//  Created by SunCheng on 15-4-8.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"

@interface LoginVC : RootViewController<UITextFieldDelegate>
{
    UITextField *useraccountTF;
    UITextField *pwdTF;
    UIView *backview;
    UIView *scrollView;
}

@property (nonatomic,assign)BOOL againLogin;

@end
