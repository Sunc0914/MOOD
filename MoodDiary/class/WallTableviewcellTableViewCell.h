//
//  WallTableviewcellTableViewCell.h
//  Mood Diary
//
//  Created by Sunc on 15/6/26.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentBtnDelegate <NSObject>

- (void)subcommentbtnclicked:(UIButton *)sender;

@end

@interface WallTableviewcellTableViewCell : UITableViewCell
{
    UILabel *namelabel;
    
    UILabel *contentlabel;
    
    UILabel *timelabel;
    
    UIImageView *img;
    
    UIView *line;
    
    UIView *commentview;
    
    UIView *commentline;
    
    NSMutableArray *celltypearr;
    
    UIView *lineview;
    
    UIView *backview;
    
    UIImageView *sexbackview;
    
}

@property (nonatomic, retain)UIButton *commentbtn;

@property (nonatomic, retain)UIButton *favouritebtn;

@property (nonatomic, assign)id <CommentBtnDelegate> delegate;

- (void)setcontent:(NSDictionary *)sender commentarr:(NSMutableArray *)arr height:(CGFloat)height more:(BOOL)more number:(NSInteger) index nowDate:(NSString *)nowDateStr;

@end
