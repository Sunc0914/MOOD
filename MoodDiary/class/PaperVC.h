//
//  PaperVC.h
//  Mood Diary
//
//  Created by Sunc on 15/6/26.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"

@interface PaperVC : RootViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *articleTableView;
}


@end
