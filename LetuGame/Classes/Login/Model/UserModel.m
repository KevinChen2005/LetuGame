//
//  UserModel.m
//  MACProject
//
//  Created by MacKun on 16/4/18.
//  Copyright © 2016年 com.soullon.MACProject. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithDict:(NSDictionary*)dict
{
    if (self = [super init]) {
        self.userid = dict[@"userId"];
        self.nickname = dict[@"nickName"];
        self.token = dict[@"token"];
        self.phone = dict[@"phone"];
        self.avatar = dict[@"avatarUrl"];
    }
    
    return self;
}

+ (instancetype)userWithDict:(NSDictionary*)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
