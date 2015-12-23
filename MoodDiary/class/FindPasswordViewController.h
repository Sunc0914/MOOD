//
//  FindPasswordViewController.h
//  inteLook
//
//  Created by Sunc on 15-3-3.
//  Copyright (c) 2015年 whtysf. All rights reserved.
//

#import "RootViewController.h"

@interface FindPasswordViewController : RootViewController<UITextFieldDelegate,UIScrollViewDelegate>
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
