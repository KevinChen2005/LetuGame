//
//  FJVersionCheck.h
//  LetuGame
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJVersionCheck : NSObject

SingleH

/**
 当前版本号
 */
@property (nonatomic, copy)NSString* currentVersion;

/**
 AppStore获取到的版本信息
 */
@property (nonatomic, strong)FJAppModel* appVersionInfo;

/**
 是否需要更新
 */
- (BOOL)isNeedUpdate;

/**
 是否需要强制更新
 */
- (BOOL)isForeceUpdate;

/**
 跳转appstore升级
 */
- (void)gotoUpdate;

@end


