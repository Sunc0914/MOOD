//
//  NSObject+AppWebService.h
//  intePM
//
//  Created by tysoft on 14-11-19.
//  Copyright (c) 2014年 whtysf. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppWebService:NSObject
#define API_LOGIN @"login"
#define API_UPLOADTEST @"test/submit"
#define API_LOGOUT @"logout"
#define API_CHANGEPWD @"user/resetPwd"

//用户登录
+(void)userLoginWithAccount:(NSString *)loginname loginpwd:(NSString *)loginpwd success:(SuccessBlock)success failed:(FailedBlock)failed;

//用户登出
+(void)logoutsuccess:(SuccessBlock)success failed:(FailedBlock)failed;

//文章列表
+(void)articleListWithStart:(NSString *)start limit:(NSString *)limit success:(SuccessBlock)success failed:(FailedBlock)failed;

//上传测试结果
+(void)uploadresult:(NSString *)result type:(NSString *)type success:(SuccessBlock)success failed:(FailedBlock)failed;

//上传测试结果
+(void)uploadupsetanddepress:(NSString *)result points:(NSString *)points type:(NSString *)type success:(SuccessBlock)success failed:(FailedBlock)failed;

//用户登出
+(void)userLogoutWithAccount:(NSString *)account success:(SuccessBlock)success failed:(FailedBlock)failed;

//心情墙列表
+ (void)moodwalllist:(NSString *)start limit:(NSString *)limit success:(SuccessBlock)success failed:(FailedBlock)failed;

//添加评论
+ (void)addcomment:(NSString *)postid content:(NSString *)content commentid:(NSString *)commentid success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取某条心情墙的评论列表
+ (void)getcomment:(NSString *)postid start:(NSString *)start limit:(NSString *)limit success:(SuccessBlock)success failed:(FailedBlock)failed;

//点赞
+ (void)favourite:(NSString *)postid success:(SuccessBlock)success failed:(FailedBlock)failed;

//发表心情墙
+ (void)publishcomment:(NSString *)content success:(SuccessBlock)success failed:(FailedBlock)failed;

//修改密码
+ (void)changepwd:(NSString *)oldpwd newpwd:(NSString *)newpwd success:(SuccessBlock)success failed:(FailedBlock)failed;

//上传用户照片文件
+ (void)submitFile :(NSData *)fileData FileName:(NSString *)filename success:(SuccessBlock)success failed:(FailedBlock)failed;

//修改信息
+ (void)changenick:(NSString *)nickname type:(NSString *)type success:(SuccessBlock)success failed:(FailedBlock)failed;

//获取验证码
+ (void)getcode:(NSString *)phonenumber success:(SuccessBlock)success failed:(FailedBlock)failed;

//根据验证码重置密码
+ (void)changepwdbycode:(NSString *)code phonenum:(NSString *)phone newpwd:(NSString *)newpwd success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
