//
//  upsetVC.h
//  Mood Diary
//
//  Created by Sunc on 15/6/24.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"

@interface upsetVC : RootViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *choicearr;
    
    UIBarButtonItem *left;
    UIBarButtonItem *right;
    
    NSArray *upsetarr;
    
    NSMutableArray *btarr;
    UIButton *answerBt;
    
    //防作弊
    NSDate *last;
    NSDate *now;
    
    UILabel *numberlabel;
    
    int itemIndex;
}

@property (nonatomic,retain) NSString *testname;

@property (nonatomic,retain) UICollectionView *upsetCollectionview;

@end
