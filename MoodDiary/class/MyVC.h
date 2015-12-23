//
//  MyVC.h
//  Mood Diary
//
//  Created by Sunc on 15/6/17.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"

@interface MyVC : RootViewController<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *settable;
}

@end
