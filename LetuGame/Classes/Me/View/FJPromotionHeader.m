//
//  FJPromotionHeader.m
//  LetuGame
//
//  Created by admin on 2018/7/30.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJPromotionHeader.h"

@implementation FJPromotionHeader

+ (instancetype)header
{
    return [[[NSBundle mainBundle]loadNibNamed:@"FJPromotionHeader" owner:nil options:nil] firstObject];
}

@end
