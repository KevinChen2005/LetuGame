//
//  FJGameInfo.m
//  LetuGame
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJGameInfo.h"

@implementation FJGameInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"desc" : @"description",
             @"ID" : @"id"
             };
}

@end
