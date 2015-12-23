//
//  ArticleDetail.m
//  Mood Diary
//
//  Created by 王振辉 on 15/7/9.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "ArticleDetail.h"

@implementation ArticleDetail

- (id)init{
    if ((self = [super init])){
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super init])) {
        self.thumbnailURL = [aDecoder decodeObjectForKey:@"ThumbnailURL"];
        self.titleString = [aDecoder decodeObjectForKey:@"TitleString"];
        self.dateString = [aDecoder decodeObjectForKey:@"DateString"];
        self.articleURL = [aDecoder decodeObjectForKey:@"ArticleURL"];
        self.IDString =  [aDecoder decodeObjectForKey:@"IDString"];
        self.digest = [aDecoder decodeObjectForKey:@"Digest"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.thumbnailURL forKey:@"ThumbnailURL"];
    [aCoder encodeObject:self.titleString forKey:@"TitleString"];
    [aCoder encodeObject:self.dateString forKey:@"DateString"];
    [aCoder encodeObject:self.articleURL forKey:@"ArticleURL"];
    [aCoder encodeObject:self.IDString forKey:@"IDString"];
    [aCoder encodeObject:self.digest forKey:@"Digest"];
}

@end
