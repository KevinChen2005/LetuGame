//
//  HttpTool.m
//  LetuGame
//
//  Created by admin on 18/7/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "HttpTool.h"

@interface HttpTool()

@end

static AFHTTPSessionManager* mgr = nil;

@implementation HttpTool


#pragma mark - 统一接口
/**
 GET请求
 */
+ (void)getWithURL:(NSString *)url success:(successBlock)success failure:(failureBlock)failure
{
    if (mgr == nil) {
        mgr = [AFHTTPSessionManager manager];
    }
    
    [mgr GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 POST请求
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    if (mgr == nil) {
        mgr = [AFHTTPSessionManager manager];
    }
    mgr.requestSerializer.timeoutInterval = 10.0; //设置请求超时10s
    NSLog(@"mgr = %@", mgr);
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 GET请求带菊花
 */
+ (void)getShowToastWithURL:(NSString *)url success:(successBlock)success failure:(failureBlock)failure
{
    [FJProgressHUB showWithMessage:nil];
    
    [self getWithURL:url success:^(id retObj) {
        [FJProgressHUB dismiss];
        if (success) {
            success(retObj);
        }
    } failure:^(NSError *error) {
        [FJProgressHUB dismiss];
        if (failure) {
            failure(error);
        }
    }];
}

/**
 POST请求带菊花
 */
+ (void)postShowToastWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    [FJProgressHUB showWithMessage:nil];
    
    [self postWithURL:url params:params success:^(id retObj) {
        [FJProgressHUB dismiss];
        if (success) {
            success(retObj);
        }
    } failure:^(NSError *error) {
        [FJProgressHUB dismiss];
        if (failure) {
            failure(error);
        }
    }];
}

/**
 取消请求
 */
+ (void)cancel
{
    NSLog(@"cancel mgr = %@", mgr);
    [mgr.operationQueue cancelAllOperations];
}

#pragma mark - 详细接口

/**
 注册
 */
+ (void)registerWithPhone:(NSString*)phone password:(NSString*)password nickname:(NSString*)nickname authcode:(NSString*)authcode success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"phone"    : [CommTool safeString:phone],
                             @"password" : [CommTool safeString:password],
                             @"nickName" : [CommTool safeString:nickname],
                             @"verifyCode" : [CommTool safeString:authcode], //验证码
//                             @"caption" : @"", //推广人
                             };
    [self postShowToastWithURL:kUrl(@"user/regist") params:params success:success failure:failure];
}

/**
 登录
 */
+ (void)loginWithPhone:(NSString*)phone password:(NSString*)password success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"phone"    : [CommTool safeString:phone],
                             @"password" : [CommTool safeString:password],
                             };
    [self postShowToastWithURL:kUrl(@"user/login") params:params success:success failure:failure];
}

/**
 检验登录状态（验证token是否过期）
 */
+ (void)verifyLoginStateSuccess:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"  : [CommTool safeString:[UserAuth shared].userInfo.token],
                             };
    [self postWithURL:kUrl(@"user/veryfiyToken") params:params success:success failure:failure];
}

/**
 获取攻略列表
 */
+ (void)fetchNewslistWithStartId:(NSInteger)startId endId:(NSInteger)endId Success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"start"    : [NSNumber numberWithInteger:startId],
                             @"end"      : [NSNumber numberWithInteger:endId],
                             };
    [self postWithURL:kUrl(@"news/list") params:params success:success failure:failure];
}

/**
 获取攻略列表（针对游戏）
 */
+ (void)fetchNewslistWithGameId:(NSString*)gameId StartId:(NSInteger)startId endId:(NSInteger)endId Success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"start"    : [NSNumber numberWithInteger:startId],
                             @"end"      : [NSNumber numberWithInteger:endId],
                             @"gameId"      : [CommTool safeString:gameId],
                             };
    [self postWithURL:kUrl(@"news/list") params:params success:success failure:failure];
}

/**
 获取攻略详情
 */
+ (void)fetchNewsDetailWithNewsId:(NSString*)newsId success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"  : [CommTool safeString:[UserAuth shared].userInfo.token],
                             @"id"     : [CommTool safeString:newsId],
                             };
    [self postWithURL:kUrl(@"news/get") params:params success:success failure:failure];
}

/**
 添加攻略
 */
+ (void)addNewsWithGameId:(NSString*)gameId title:(NSString*)title content:(NSString*)content typeOne:(NSString*)typeOne typeTwo:(NSString*)typeTwo success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"    : [CommTool safeString:[UserAuth shared].userInfo.token],
                             @"gameId"   : [CommTool safeString:gameId],
                             @"title"    : [CommTool safeString:title],
                             @"content"  : [CommTool safeString:content],
                             @"typeOne"  : [CommTool safeString:typeOne],
                             @"typeTwo"  : [CommTool safeString:typeTwo],
                             };
    [self postWithURL:kUrl(@"news/add") params:params success:success failure:failure];
}

/**
 修改攻略
 */
+ (void)updateNewsWithId:(NSString*)newsId gameId:(NSString*)gameId title:(NSString*)title content:(NSString*)content typeOne:(NSString*)typeOne typeTwo:(NSString*)typeTwo success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"    : [CommTool safeString:[UserAuth shared].userInfo.token],
                             @"id"       : [CommTool safeString:newsId],
                             @"gameId"   : [CommTool safeString:gameId],
                             @"title"    : [CommTool safeString:title],
                             @"content"  : [CommTool safeString:content],
                             @"typeOne"  : [CommTool safeString:typeOne],
                             @"typeTwo"  : [CommTool safeString:typeTwo],
                             };
    [self postWithURL:kUrl(@"news/update") params:params success:success failure:failure];
}

/**
 获取游戏列表
 */
+ (void)fetchGamelistWithStartId:(NSInteger)startId endId:(NSInteger)endId Success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"    : [CommTool safeString:[UserAuth shared].userInfo.token],
                             @"start"    : [NSNumber numberWithInteger:startId],
                             @"end"      : [NSNumber numberWithInteger:endId],
                             };
    [self postWithURL:kUrl(@"game/list") params:params success:success failure:failure];
}

/**
 获取游戏详情
 */
+ (void)fetchGameDetailWithGameId:(NSString *)gameId success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"gameId"    : [CommTool safeString:gameId],
                             @"os"        : @"ios"
                             };
    [self postShowToastWithURL:kUrl(@"game/detail") params:params success:success failure:failure];
}

/**
 获取评论列表
 */
+ (void)fetchCommentlistWithType:(NSString*)commentType kindId:(NSString*)kindId startId:(NSInteger)startId endId:(NSInteger)endId Success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"        : [CommTool safeString:[UserAuth shared].userInfo.token],
                             @"commentType"  : [CommTool safeString:commentType],
                             @"kindid"       : [CommTool safeString:kindId],
                             @"start"        : [NSNumber numberWithInteger:startId],
                             @"end"          : [NSNumber numberWithInteger:endId],
                             };
    [self postWithURL:kUrl(@"comment/list") params:params success:success failure:failure];
}

/**
 添加评论
 */
+ (void)addCommentWithType:(NSString*)commentType kindId:(NSString*)kindId content:(NSString*)content Success:(successBlock)success failure:(failureBlock)failure;
{
    NSDictionary* params = @{
                             @"token"      : [CommTool safeString:[UserAuth shared].userInfo.token],
                             @"commentType": [CommTool safeString:commentType],
                             @"kindid"     : [CommTool safeString:kindId],
                             @"content"    : [CommTool safeString:content],
                             };
    [self postWithURL:kUrl(@"comment/add") params:params success:success failure:failure];
}

/**
 修改评论
 */
+ (void)updateCommentWithID:(NSString*)commentId commentType:(NSString*)commentType content:(NSString*)content Success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"      : [CommTool safeString:[UserAuth shared].userInfo.token],
                             @"commentType": [CommTool safeString:commentType],
                             @"id"         : [CommTool safeString:commentId],
                             @"content"    : [CommTool safeString:content],
                             };
    [self postWithURL:kUrl(@"comment/update") params:params success:success failure:failure];
}

/**
 点赞
 */
+ (void)likeWithType:(NSString*)likeType kindId:(NSString*)kindId Success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"      : [CommTool safeString:[UserAuth shared].userInfo.token],
                             @"likeType"   : [CommTool safeString:likeType],
                             @"kindid"     : [CommTool safeString:kindId],
                             };
    [self postWithURL:kUrl(@"like/add") params:params success:success failure:failure];
}

/**
 收藏
 */
+ (void)collectionWithType:(NSString*)collectType kindId:(NSString*)kindId Success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"      : [CommTool safeString:[UserAuth shared].userInfo.token],
                             @"collectType": [CommTool safeString:collectType],
                             @"kindid"     : [CommTool safeString:kindId],
                             };
    [self postWithURL:kUrl(@"collect/add") params:params success:success failure:failure];
}

/**
 取消收藏
 */
+ (void)removeCollectionWithType:(NSString*)collectType kindId:(NSString*)kindId Success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"      : [CommTool safeString:[UserAuth shared].userInfo.token],
                             @"collectType": [CommTool safeString:collectType],
                             @"kindid"     : [CommTool safeString:kindId],
                             };
    [self postWithURL:kUrl(@"collect/remove") params:params success:success failure:failure];
}

/**
 获取收藏列表
 */
+ (void)fetchCollectionListWithType:(NSString*)collectType Success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"      : [CommTool safeString:[UserAuth shared].userInfo.token],
                             @"collectType": [CommTool safeString:collectType],
                             };
    [self postWithURL:kUrl(@"collect/list") params:params success:success failure:failure];
}

/**
 我要玩游戏
 */
+ (void)wantPlayGameWithId:(NSString*)gameId Success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"   : [CommTool safeString:[UserAuth shared].userInfo.token],
                             @"gameid"  : [CommTool safeString:gameId],
                             @"os"      : @"ios",
                             };
    [self postWithURL:kUrl(@"user/wantPlayGame") params:params success:success failure:failure];
}

/**
 获取注册验证码
 */
+ (void)fetchVerifyCodeWithPhone:(NSString*)phone Success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"phone"   : [CommTool safeString:phone],
                             };
    [self postWithURL:kUrl(@"user/getRegistCode") params:params success:success failure:failure];
}

/**
 获取Banner
 */
+ (void)fetchBannerWithType:(NSString*)bannerType Success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"bannerType"   : [CommTool safeString:bannerType],
                             };
    [self postWithURL:kUrl(@"banner/list") params:params success:success failure:failure];
}

/**
 获取我的游戏预约列表
 */
+ (void)fetchMyGameListSuccess:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"token"   : [CommTool safeString:[UserAuth shared].userInfo.token],
                             };
    [self postWithURL:kUrl(@"user/listMyGame") params:params success:success failure:failure];
}
@end


