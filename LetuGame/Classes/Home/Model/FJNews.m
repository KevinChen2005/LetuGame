//
//  FJNews.m
//  LetuGame
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJNews.h"

@implementation FJNews

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",
             };
}

- (instancetype)init
{
    if (self = [super init]) {
        //测试
//        static int i = 0;
//        switch (i++%4) {
//            case 0:
//                self.desc = @"勇士们正在一步一步的接近终极遗忘之城挑战。经过深渊之门的试勇士们正在一步一步的接";
//                break;
//            case 1:
//                self.desc = @"勇士们正在一步一步的接近终极遗忘之城挑战。";
//                break;
//            case 2:
//                self.desc = @"";
//                break;
//            default:
//                self.desc = @"勇士们正在一步一步的接近终极遗忘之城挑战。经过深渊之门的试探后，才能迎来初探深渊的挑战。对于英雄们不......";
//                break;
//        }
    }
    
    return self;
}

@end
