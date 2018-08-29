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
    if (self.currentVersion == nil || self.appstoreVerInfo == nil) {
        return NO;
    }
    
    if ([self.currentVersion floatValue] < [self.appstoreVerInfo.version floatValue]) {
        return YES;
    }
    
    return NO;
}

- (void)gotoUpdate
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appstoreVerInfo.trackViewUrl]];
}

@end
