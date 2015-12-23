//
//  PersonalInfoVC.h
//  Mood Diary
//
//  Created by Sunc on 15/6/17.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"

#import "RootViewController.h"
#import "UserInfo.h"
#import "UIImageView+WebCache.h"

@interface PersonalInfoVC : RootViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

{
    UITableView *persontable;
    
    UITextField *nicknamefield;
    
    UIView *changepicback;
    
    UIView *changenick;

}

@end
