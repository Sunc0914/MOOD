//
//  MyTestVC.h
//  Mood Diary
//
//  Created by Sunc on 15/7/10.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"

@interface MyTestVC : RootViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *mytesttableview;
}

@end
