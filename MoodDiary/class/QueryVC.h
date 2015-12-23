//
//  QueryVC.h
//  Mood Diary
//
//  Created by Sunc on 15/6/17.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"
#import <MessageUI/MessageUI.h>

@interface QueryVC : RootViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
    UITableView *querytable;
}

@property (nonatomic, assign)BOOL isToRoot;

@end
