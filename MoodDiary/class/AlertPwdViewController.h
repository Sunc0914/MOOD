//
//  AlertPwdViewController.h
//  FlowMng
//
//  Created by tysoft on 14-3-13.
//  Copyright (c) 2014年 key. All rights reserved.
//

#import "RootViewController.h"

@interface AlertPwdViewController : RootViewController<UITextFieldDelegate,UIAlertViewDelegate> {
    UITextField *orPwdTx;
    UITextField *newPwdTx;
    UITextField *rnewPwdTx;
}

@end
