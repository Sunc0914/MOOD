//
//  DataModel.m
//  Mood Diary
//
//  Created by 王振辉 on 15/7/9.
//  Copyright (c) 2015年 Mood Group. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (id)init{
    if ((self = [super init])) {
        [self loadArticles];
    }
    return self;
}

- (BOOL)addObject:(ArticleDetail *)articleDetail{
    
    for (ArticleDetail *temp in self.articles) {
        if ([articleDetail.IDString isEqualToString:temp.IDString]) {
            [self.articles removeObject:temp];
            return NO;
        }
    }
    
    [self.articles addObject:articleDetail];
    return YES;
}

- (void)loadArticles{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        self.articles = [unarchiver decodeObjectForKey:@"Articles"];
        [unarchiver finishDecoding];
    }else{
        self.articles = [[NSMutableArray alloc]initWithCapacity:10];
    }
}


- (void)saveArticles{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:_articles forKey:@"Articles"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (NSString *)documentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

-(NSString *)dataFilePath{
    return [[self documentsDirectory]stringByAppendingPathComponent:@"Articles.plist"];
}

@end
