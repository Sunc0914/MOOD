//
//  WallVC.h
//  Mood Diary
//
//  Created by Sunc on 15/6/26.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"
#import "WallTableviewcellTableViewCell.h"

@interface WallVC : RootViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CommentBtnDelegate,UITextViewDelegate>
{
    UITableView *walltable;
    NSMutableArray *walllist;
    UIView *changenick;
    UITextView *nicknamefield;
    UIButton *comfirmbtn;
    
    NSMutableArray *commentheight;
    NSMutableArray *commentlistarr;
    
    NSMutableArray *selectedstate;
    
    NSString *subpostid;
    
    UIBarButtonItem *right;
    UIBarButtonItem *clearbtn;
    
    NSMutableArray *typearr;
    NSMutableDictionary *nicknamedic;
    
    BOOL morecomment;
    
    float heightwhenkeyboardshow;
    
    BOOL isaftercomment;
}

@end
