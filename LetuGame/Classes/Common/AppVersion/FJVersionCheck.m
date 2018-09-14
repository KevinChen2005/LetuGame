//
//  FJVersionCheck.m
//  LetuGame
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJVersionCheck.h"

@implementation FJVersionCheck

SingleM

- (BOOL)isNeedUpdate
{
    if (self.currentVersion == nil || self.appVersionInfo == nil) {
        return NO;
    }
    
    NSString* curVersion = self.currentVersion;
    NSString* newVersion = self.appVersionInfo.appVersion;
    NSLog(@"curVersion=%@, newVersion=%@", curVersion, newVersion);
    
    return [self compareLocalVersion:curVersion newVersion:newVersion];
}

- (void)gotoUpdate
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appVersionInfo.appUpdateUrl]];
}


/**
 是否需要强制更新
 */
- (BOOL)isForeceUpdate
{
    return _appVersionInfo.isForceUpdate;
}

- (void)setAppVersionInfo:(FJAppModel *)appVersionInfo
{
    _appVersionInfo = appVersionInfo;
    
    //检测是否强制更新
    [self checkForceUpdate];
}

- (void)checkForceUpdate
{
    if (self.isNeedUpdate && [self isForeceUpdate]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [FJPopView showConfirmViewWithTitle:@"提示" message:@"检测到新版本，需要更新后才能继续！" okBlock:^{//点击确认
                [[FJVersionCheck shareInstance] gotoUpdate];
                exit(0);
            }];
        });
    }
    
}

- (BOOL)compareLocalVersion:(NSString*)localVerson newVersion:(NSString*)newVersion
{
    //将版本号按照.切割后存入数组中
    NSArray *localArray = [localVerson componentsSeparatedByString:@"."];
    NSArray *appArray = [newVersion componentsSeparatedByString:@"."];
    NSInteger localCount = localArray.count;
    NSInteger appCount = appArray.count;
    NSInteger maxArrayLength = MAX(localCount, appCount);
    //当前版本号短
    if (localCount < appCount) {
        NSInteger nCap = appCount - localCount;
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:localArray];
        for (int i=0; i<nCap; i++) {
            [tempArray addObject:@"0"];
        }
        localArray = [tempArray copy];
    }
    //当前版本号短
    if (appCount < localCount) {
        NSInteger nCap = localCount - appCount;
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:appArray];
        for (int i=0; i<nCap; i++) {
            [tempArray addObject:@"0"];
        }
        appArray = [tempArray copy];
    }
    
    BOOL needUpdate = NO;
    for(int i=0; i<maxArrayLength; i++){//以最短的数组长度为遍历次数,防止数组越界
        //取出每个部分的字符串值,比较数值大小
        NSString* localElement = localArray[i];
        NSString* appElement = appArray[i];
        NSInteger  localValue = localElement.integerValue;
        NSInteger  appValue = appElement.integerValue;
        if(localValue<appValue) {
            //从前往后比较数字大小,一旦分出大小,跳出循环
            needUpdate = YES;
            break;
        }else{
            needUpdate = NO;
        }
    }
    
    return needUpdate;
}

@end
