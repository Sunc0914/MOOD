//
//  FindPwdVC.h
//  MoodDiary
//
//  Created by Sunc on 15/9/14.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "RootViewController.h"

@interface FindPwdVC : RootViewController
{
    UIScrollView *mainScrollView;
    UIView *changePwdView;
    UITextField *phoneNumTx;
    BOOL showchangeview;
    UIButton *nextStepbt;
    UIView *frontview;
    
    UITextField *newPwd;
    UITextField *repeatPwd;
    UITextField *checkcode;
    UIButton *confirm;
    int keyboardheight;
}

@end
