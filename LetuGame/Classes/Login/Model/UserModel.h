//
//  UserModel.h
//  MACProject
//
//  Created by MacKun on 16/4/18.
//  Copyright © 2016年 com.soullon.MACProject. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

/**
 *  用户编号
 */
@property(nonatomic,copy) NSString *userId;

/**
 *  手机号
 */
@property(nonatomic,copy) NSString *phone;

/**
 *  token
 */
@property(nonatomic,copy) NSString *token;

/**
 *  昵称
 */
@property(nonatomic,copy) NSString *nickName;

/**
 *  头像
 */
@property(nonatomic,copy) NSString *avatarUrl;

/**
 *  性别
 */
@property(nonatomic,copy) NSString *sex;

/**
 *  是否是推广员
 */
@property(nonatomic,assign)BOOL isSpreader;

@end

