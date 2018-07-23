//
//  HttpTool.h
//  LetuGame
//
//  Created by admin on 18/7/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id retObj);
typedef void(^failureBlock)(NSError* error);

@interface HttpTool : NSObject

#pragma mark - 统一请求接口

/**
 GET请求
 */
+ (void)getWithURL:(NSString*)url success:(successBlock)success failure:(failureBlock)failure;

/**
 GET请求带菊花
 */
+ (void)getShowToastWithURL:(NSString *)url success:(successBlock)success failure:(failureBlock)failure;

/**
 POST请求
 */
+ (void)postWithURL:(NSString*)url params:(NSDictionary*)params success:(successBlock)success failure:(failureBlock)failure;

/**
 POST请求带菊花
 */
+ (void)postShowToastWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;

/**
 取消请求
 */
+ (void)cancel;

#pragma mark - 详细接口

/**
 注册请求
 */
+ (void)registerWithPhone:(NSString*)phone password:(NSString*)password nickname:(NSString*)nickname authcode:(NSString*)authcode success:(successBlock)success failure:(failureBlock)failure;

/**
 登录请求
 */
+ (void)loginWithPhone:(NSString*)phone password:(NSString*)password success:(successBlock)success failure:(failureBlock)failure;

/**
 检验登录状态（验证token是否过期）
 */
+ (void)verifyLoginStateSuccess:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 攻略相关接口

/**
 获取攻略列表
 */
+ (void)fetchNewslistWithStartId:(NSInteger)startId endId:(NSInteger)endId Success:(successBlock)success failure:(failureBlock)failure;

/**
 获取攻略列表（针对游戏）
 */
+ (void)fetchNewslistWithGameId:(NSString*)gameId StartId:(NSInteger)startId endId:(NSInteger)endId Success:(successBlock)success failure:(failureBlock)failure;

/**
 获取攻略详情
 */
+ (void)fetchNewsDetailWithNewsId:(NSString*)newsId success:(successBlock)success failure:(failureBlock)failure;

/**
 添加攻略
 */
+ (void)addNewsWithGameId:(NSString*)gameId title:(NSString*)title content:(NSString*)content typeOne:(NSString*)typeOne typeTwo:(NSString*)typeTwo success:(successBlock)success failure:(failureBlock)failure;

/**
 修改攻略
 */
+ (void)updateNewsWithId:(NSString*)newsId gameId:(NSString*)gameId title:(NSString*)title content:(NSString*)content typeOne:(NSString*)typeOne typeTwo:(NSString*)typeTwo success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 游戏相关接口

/**
 获取游戏列表
 */
+ (void)fetchGamelistWithStartId:(NSInteger)startId endId:(NSInteger)endId Success:(successBlock)success failure:(failureBlock)failure;

/**
 获取游戏详情
 */
+ (void)fetchGameDetailWithGameId:(NSString*)gameId success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 评论相关接口

/**
 获取评论列表
 */
+ (void)fetchCommentlistWithType:(NSString*)commentType kindId:(NSString*)kindId startId:(NSInteger)startId endId:(NSInteger)endId Success:(successBlock)success failure:(failureBlock)failure;

/**
 添加评论

 @param commentType 评论类型：news、game等
 @param kindId 类型id,（攻略ID, 游戏id等）
 @param content 评论内容
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)addCommentWithType:(NSString*)commentType kindId:(NSString*)kindId content:(NSString*)content Success:(successBlock)success failure:(failureBlock)failure;

/**
 修改评论
 */
+ (void)updateCommentWithID:(NSString*)commentId commentType:(NSString*)commentType content:(NSString*)content Success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 点赞
/**
 点赞
 */
+ (void)likeWithType:(NSString*)likeType kindId:(NSString*)kindId Success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 收藏
/**
 收藏
 */
+ (void)collectionWithType:(NSString*)collectType kindId:(NSString*)kindId Success:(successBlock)success failure:(failureBlock)failure;

/**
 取消收藏
 */
+ (void)removeCollectionWithType:(NSString*)collectType kindId:(NSString*)kindId Success:(successBlock)success failure:(failureBlock)failure;

/**
 获取收藏列表
 */
+ (void)fetchCollectionListWithType:(NSString*)collectType Success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 我要玩游戏
/**
 我要玩游戏
 */
+ (void)wantPlayGameWithId:(NSString*)gameId Success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 获取注册验证码
/**
 获取注册验证码
 */
+ (void)fetchVerifyCodeWithPhone:(NSString*)phone Success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 获取Banner
/**
 获取Banner
 */
+ (void)fetchBannerWithType:(NSString*)bannerType Success:(successBlock)success failure:(failureBlock)failure;

/**
 获取我的游戏预约列表
 */
+ (void)fetchMyGameListSuccess:(successBlock)success failure:(failureBlock)failure;

@end