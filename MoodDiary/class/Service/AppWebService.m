//
//  NSObject+AppWebService.m
//  intePM
//
//  Created by tysoft on 14-11-19.
//  Copyright (c) 2014年 whtysf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTourAPIClient.h"
#import "AppWebService.h"
#import "OperationModel.h"

@implementation AppWebService

//登录方法例子
+(void)userLoginWithAccount:(NSString *)loginname loginpwd:(NSString *)loginpwd success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:loginname, @"j_username", loginpwd, @"j_password", nil];
    [[iTourAPIClient sharedClient] postPath:API_LOGIN parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            if ([errormsg isEqualToString:@"1"]) {
                errormsg = @"用户名为空";
            }
            else if ([errormsg isEqualToString:@"2"])
            {
                errormsg = @"密码为空";
            }
            else if ([errormsg isEqualToString:@"3"])
            {
                errormsg = @"验证码错误";
            }
            else if ([errormsg isEqualToString:@"4"])
            {
                errormsg = @"用户名不存在";
            }
            else if ([errormsg isEqualToString:@"5"])
            {
                errormsg = @"账号或密码错误";
            }
            else if ([errormsg isEqualToString:@"6"])
            {
                errormsg = @"账号未启用";
            }
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//用户登出
+(void)logoutsuccess:(SuccessBlock)success failed:(FailedBlock)failed{
    [[iTourAPIClient sharedClient] postPath:@"logout" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"%@",responseJson);
        
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        

        SAFE_BLOCK_CALL(success, responseJson);
 
            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//文章列表
+(void)articleListWithStart:(NSString *)start limit:(NSString *)limit success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:start, @"start", limit, @"limit", nil];
    
    [[iTourAPIClient sharedClient] postPath:@"article/list" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"%@",responseJson);
        
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//上传scl测试结果
+(void)uploadresult:(NSString *)result type:(NSString *)type success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSString *point = @"100";
//    NSString *type = @"3";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:result,@"result",type,@"type", point,@"points",nil];
    [[iTourAPIClient sharedClient] postPath:API_UPLOADTEST parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        
        if (responseJson == nil) {
            
            NSString *errormsg = @"发生错误，请稍后再试";
            
            error = [NSError errorWithMsg:errormsg];
            
            SAFE_BLOCK_CALL(failed, error);
        }
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            NSString *errormsg = @"发生错误，请稍后再试";
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//上传测试结果
+(void)uploadupsetanddepress:(NSString *)result points:(NSString *)points type:(NSString *)type success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    int score = [points intValue];
    int testtype = [type intValue];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:result,@"result",nil];
    [dict setObject:[NSNumber numberWithInt:score] forKey:@"points"];
    [dict setObject:[NSNumber numberWithInt:testtype] forKey:@"type"];
    
    [[iTourAPIClient sharedClient] postPath:@"test/submit" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//登出
+(void)userLogoutWithAccount:(NSString *)account success:(SuccessBlock)success failed:(FailedBlock)failed
{
    NSDictionary *dict = nil;
    
    [[iTourAPIClient sharedClient] postPath:API_LOGOUT parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        SAFE_BLOCK_CALL(success, responseJson);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];

}

//获取心情墙
+ (void)moodwalllist:(NSString *)start limit:(NSString *)limit success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:start, @"start",limit,@"limit", nil];
    [[iTourAPIClient sharedClient] postPath:@"post/listAll" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//添加评论
+ (void)addcomment:(NSString *)postid content:(NSString *)content commentid:(NSString *)commentid success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:postid, @"postId",content,@"content",commentid,@"commentId ", nil];
    [[iTourAPIClient sharedClient] postPath:@"post/comment/add" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//获取评论
+ (void)getcomment:(NSString *)postid start:(NSString *)start limit:(NSString *)limit success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:postid, @"postId",start,@"start",limit,@"limit", nil];
    [[iTourAPIClient sharedClient] postPath:@"post/comment/list" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//点赞
+ (void)favourite:(NSString *)postid success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:postid,@"postId", nil];
    [[iTourAPIClient sharedClient] postPath:@"post/favour/add" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//发布心情
+ (void)publishcomment:(NSString *)content success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:content,@"content", nil];
    [[iTourAPIClient sharedClient] postPath:@"post/add" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//修改密码
+ (void)changepwd:(NSString *)oldpwd newpwd:(NSString *)newpwd success:(SuccessBlock)success failed:(FailedBlock)failed{
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:oldpwd,@"oldPwd",newpwd,@"newPwd",info.useraccount,@"username",nil];
    [[iTourAPIClient sharedClient] postPath:@"user/resetPwd?" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//上传用户照片文件
+(void)submitFile:(NSData *)fileData FileName:(NSString *)filename success:(SuccessBlock)success failed:(FailedBlock)failed{
    
    UserInfo *info = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];

    NSString *tempurl = @"http://etotech.net:8080/psychology/";
    
    NSString* base_url=[NSString stringWithFormat:@"%@",tempurl];
    NSString *url = [NSString stringWithFormat:@"%@%@",base_url,@"user/uploadAvatar"];
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"multipart/form-data; boundary=gL6cH2KM7GI3Ij5KM7KM7Ij5Ij5Ij5" forHTTPHeaderField:@"Content-Type"];
    NSString *MPboundary=[NSString stringWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[NSString stringWithFormat:@"%@--",MPboundary];
    NSMutableString *body=[[NSMutableString alloc]init];
    NSArray *keys=[NSArray arrayWithObjects:@"username",@"upload",nil];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:info.useraccount forKey:@"username"];
//    [params setObject:fileData forKey:@"upload"];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"pic"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    [body appendFormat:@"%@\r\n",MPboundary];
    
    //声明pic字段，文件名为boris.png
    NSString *appendFormatStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Filedata\"; filename=\"%@\"\r\n", filename];
    NSLog(@"%@",appendFormatStr);
    //  [body appendFormat:@"Content-Disposition: form-data; name=\"Filedata\"; filename=\"wangbo.doc\"\r\n"];
    [body appendFormat:@"%@",appendFormatStr];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: txt/html\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[NSString stringWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //将image的data加入
    [myRequestData appendData:fileData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[NSString stringWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    [request setTimeoutInterval:5];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //test
    AFHTTPRequestOperation *uploadOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    NSArray *temdbpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *fileNamePath = [[temdbpath objectAtIndex:0] stringByAppendingPathComponent:@"userpic"];   // 保存文件的名称
    NSLog(@"%@",fileNamePath);
    
    uploadOperation.inputStream = [NSInputStream inputStreamWithFileAtPath:fileNamePath];
    
    [uploadOperation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat precent = (CGFloat)totalBytesWritten / totalBytesExpectedToWrite;
        NSString *precentStr = [NSString stringWithFormat:@"%f",precent];
        SAFE_BLOCK_CALL(success, precentStr);
    }];
    
    //test
    NSData *requestdata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *requestStr = [[NSString alloc] initWithData:requestdata encoding:NSUTF8StringEncoding];
    
    NSDictionary *responseJson = [requestStr objectFromJSONString];
    
    NSLog(@"%@",responseJson);
    NSString *responseCode = [NSString stringWithFormat:@"%@",[responseJson valueForKey:@"returncode"]];
    if ([responseCode isEqualToString:@"0"]) {
        SAFE_BLOCK_CALL(success, responseJson);
    } else if  ([responseCode isEqualToString:@"400"]) {
        SAFE_BLOCK_CALL(failed, [NSError errorWithMsg:@"登录超时"]);
    }   else if ([responseCode isEqualToString:@"401"])
    {
        SAFE_BLOCK_CALL(failed, [NSError errorWithMsg:@"用户在其他设备上登录！"]);
    }
    else {
        SAFE_BLOCK_CALL(failed, [NSError errorWithMsg:@"上传头像失败"]);
    }
}

////下载文件
//+(void)loadDownFile:(NSString *)filename operatorid:(NSString *)userid wherelanguage:(NSString *)language userdeviceID:(NSString *)deviceid success:(SuccessBlock)success failed:(FailedBlock)failed
//{
//    UserInfo *userInfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
//    NSString *useroperatetype = @"downloadheadportrait";
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:useroperatetype, @"operatetype",userid, @"operaterid",filename,@"filename",language,@"wherelanguage",deviceid,@"deviceid",nil];
//    NSLog(@"%@",dict);
//    NSString *tempurl = BaseURLString;
//    
//    NSString* base_url=[NSString stringWithFormat:@"%@",tempurl];
//    //    NSString *url = [NSString stringWithFormat:@"%@%@",base_url,API_UPDATE_IMAGE];
//    
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:base_url]];
//    NSURLRequest *request = [httpClient requestWithMethod:@"GET" path:API_UPDATE_IMAGE parameters:dict];
//    
//    AFHTTPRequestOperation *downloadOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSArray *tempath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *path = [[tempath objectAtIndex:0] stringByAppendingPathComponent:@"userpic"];   // 保存文件的名称
//
//    downloadOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
//    [downloadOperation setDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        //显示下载百分数
//        CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
//        NSString *precentStr = [NSString stringWithFormat:@"%f",precent];
//        SAFE_BLOCK_CALL(success, precentStr);
//    }];
//    
//    //    NSDate *date = [NSDate date];
//    //
//    //    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    //
//    //    [formatter setDateFormat:@"yyyy-MM"];
//    //
//    //    NSString *currentstr = [formatter stringFromDate:date];
//    
//    
//    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"%@",docsdir);
//    
//    NSArray *temdbpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *fileNamePath = [[temdbpath objectAtIndex:0] stringByAppendingPathComponent:@"userpic"];   // 保存文件的名称
//    
//    NSLog(@"%@",fileNamePath);
//    
//    //    NSString *otherPath = [documentsPath stringByAppendingPathComponent:@"other"];
//    
//    BOOL sure = [[NSFileManager defaultManager] createDirectoryAtPath:fileNamePath withIntermediateDirectories:YES attributes:nil error:nil];
//    NSAssert(sure,@"创建目录失败");
//    
//    [downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"下载成功");
//        SAFE_BLOCK_CALL(success, @"success");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        SAFE_BLOCK_CALL(failed, [NSError errorWithMsg:@"下载头像失败"]);
//    }];
//    [httpClient.operationQueue addOperation:downloadOperation];
//}

//修改信息
+ (void)changenick:(NSString *)nickname type:(NSString *)type success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:nickname,type,nil];
    [[iTourAPIClient sharedClient] postPath:@"user/modify?" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//获取验证码
+ (void)getcode:(NSString *)phonenumber success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:phonenumber,@"username", nil];
    [[iTourAPIClient sharedClient] postPath:@"user/sendPwdRand?" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//根据验证码重置密码
+ (void)changepwdbycode:(NSString *)code phonenum:(NSString *)phone newpwd:(NSString *)newpwd success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"username",code,@"rand",newpwd,@"newPwd", nil];
    [[iTourAPIClient sharedClient] postPath:@"user/resetPwdbyRand" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseJson);
        
        NSError *error = nil;
        NSString *result = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"isSuccess"]];
        NSString *errormsg = [responseJson objectForKey:@"msg"];
        NSLog(@"%@",errormsg);
        if (result && [result isEqualToString:@"1"]) {
            SAFE_BLOCK_CALL(success, responseJson);
        }
        else
        {
            error = [NSError errorWithMsg:errormsg];
            SAFE_BLOCK_CALL(failed, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        error = [NSError errorWithMsg:SERVER_ERROR];
        SAFE_BLOCK_CALL(failed, error);
    }];
}

@end
