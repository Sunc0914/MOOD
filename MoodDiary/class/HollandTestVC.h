//
//  HollandTestVC.h
//  MoodDiary
//
//  Created by Sunc on 15/10/7.
//  Copyright (c) 2015年 Sunc. All rights reserved.
//

#import "RootViewController.h"

@protocol Hollandisdone <NSObject>

-(void)hollandSetdone;

@end

@interface HollandTestVC : RootViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>
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

@property(nonatomic,assign) id<Hollandisdone>delegate;
@property(nonatomic,assign) BOOL hasdone;

@end

