//
//  FJAppModel.h
//  LetuGame
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 com.langlun. All rights reserved.
//  应用版本信息，用于检测更新

#import <Foundation/Foundation.h>

@interface FJAppModel : NSObject

@property (nonatomic, copy) NSString* appVersion;             //版本号

@property (nonatomic, copy) NSString* appReleaseTime;         //发布时间

@property (nonatomic, copy) NSString* appUpdateUrl;           //更新地址

@property (nonatomic, assign) BOOL isForceUpdate;             //是否强制更新


@end

