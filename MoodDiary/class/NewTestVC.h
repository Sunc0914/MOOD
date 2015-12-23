//
//  NewTestVC.h
//  Mood Diary
//
//  Created by Sunc on 15/6/18.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "RootViewController.h"

@protocol isdone <NSObject>

-(void)setdone;

@end

@interface NewTestVC : RootViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *choicearr;

    UIBarButtonItem *left;
    UIBarButtonItem *right;
    
    NSArray *sclarr;
    
    NSMutableArray *btarr;
    UIButton *answerBt;
    
    //防作弊
    NSDate *last;
    NSDate *now;
    
    UILabel *numberlabel;
    
    int itemIndex;
}

@property (nonatomic,retain) NSString *testname;

@property (nonatomic,retain) UICollectionView *collectionview;

@property(nonatomic,assign) id<isdone>delegate;
@property(nonatomic,assign) BOOL hasdone;

@end
