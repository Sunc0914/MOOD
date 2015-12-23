//
//  SpecificVC.h
//  Mood Diary
//
//  Created by Sunc on 15-4-9.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"



@interface SpecificVC : RootViewController<UIAlertViewDelegate>
{
    UIButton *confirmBt;
    BOOL done;
    BOOL hollanddone;
}

@property (nonatomic, retain)NSString *content1;
@property (nonatomic, retain)NSString *content2;
@property (nonatomic, retain)NSString *testtype;

@end
