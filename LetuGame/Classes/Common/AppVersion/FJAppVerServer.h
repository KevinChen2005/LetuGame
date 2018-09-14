//
//  FJAppVerServer.h
//  LetuGame
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 com.langlun. All rights reserved.
//  服务器应用版本信息，用于检测更新

#import "FJAppModel.h"

@interface FJAppVerServer : FJAppModel

@property (nonatomic, copy) NSString* version;             //版本号

@property (nonatomic, copy) NSString* url;                //更新跳转地址

@property (nonatomic, copy) NSString* createtime;         //发布时间

@property (nonatomic, assign) BOOL isforce;              //是否强制更新

@end

/*
 {
 "version": "1.0.0",
 "url": "xxxx",
 "isforce": 0,
 "createtime": "2018-09-12 11:24:45"
 }
 */
