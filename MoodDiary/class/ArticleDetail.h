//
//  ArticleDetail.h
//  Mood Diary
//
//  Created by 王振辉 on 15/7/9.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleDetail : NSObject<NSCoding>
@property (nonatomic, copy)NSURL *thumbnailURL;
@property (nonatomic, copy)NSString *titleString;
@property (nonatomic, copy)NSString *dateString;
@property (nonatomic, copy)NSURL *articleURL;
@property (nonatomic, copy)NSString *IDString;
@property (nonatomic, copy)NSString *digest;
@end
