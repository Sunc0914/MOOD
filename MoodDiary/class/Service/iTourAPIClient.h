//
//  AFHTTPRequestOperation+iTourAPIClient.h
//  intePM
//
//  Created by tysoft on 14-11-19.
//  Copyright (c) 2014年 whtysf. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

#define BASE_URL @"http://etotech.net:8080/psychology/"
#define SERVER_ERROR @"网络异常"

@interface iTourAPIClient:AFHTTPClient

+(iTourAPIClient *)sharedClient;

@end
