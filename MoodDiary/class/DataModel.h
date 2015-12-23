//
//  DataModel.h
//  Mood Diary
//
//  Created by 王振辉 on 15/7/9.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleDetail.h"
@interface DataModel : NSObject
@property (nonatomic, strong)NSMutableArray *articles;
- (void)saveArticles;
- (BOOL)addObject:(ArticleDetail *)articleDetail;
@end
