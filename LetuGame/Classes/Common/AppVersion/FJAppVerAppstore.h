//
//  FJAppVerAppstore.h
//  LetuGame
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 com.langlun. All rights reserved.
//  Appstore应用版本信息，用于检测更新

#import "FJAppModel.h"

@interface FJAppVerAppstore : FJAppModel

@property (nonatomic, copy) NSString* version;             //版本号

@property (nonatomic, copy) NSString* minimumOsVersion;    //App所支持的最低iOS系统

@property (nonatomic, copy) NSString* releaseDate;         //发布时间

@property (nonatomic, copy) NSString* trackId;             //应用程序ID

@property (nonatomic, copy) NSString* trackName;           //应用程序名称

@property (nonatomic, copy) NSString* trackViewUrl;        //应用程序介绍网址(下载跳转地址)

@property (nonatomic, copy) NSString* trackCensoredName;   //审查名称

@property (nonatomic, copy) NSString* trackContentRating;  //评级

@property (nonatomic, assign) CGFloat fileSizeBytes;       //应用的大小

@end

/*
 minimumOsVersion = "8.0";         //App所支持的最低iOS系统
 fileSizeBytes = ;                 //应用的大小
 releaseDate = "";                 //发布时间
 trackCensoredName = "";           //审查名称
 trackContentRating = "";          //评级
 trackId = ;                       //应用程序ID
 trackName = "";                   //应用程序名称
 trackViewUrl = "";                //应用程序介绍网址
 version = "4.0.3";                //版本号
 ……
 */
