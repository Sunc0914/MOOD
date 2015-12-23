//
//  FirstpageVC.h
//  Mood Diary
//
//  Created by Sunc on 15/6/16.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"

@interface FirstpageVC : RootViewController<UIScrollViewDelegate>
{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
    
    UIScrollView *scrollback;
}

@end
