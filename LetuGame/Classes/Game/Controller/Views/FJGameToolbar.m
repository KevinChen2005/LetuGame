//
//  FJGameToolbar.m
//  LetuGame
//
//  Created by admin on 2018/7/13.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJGameToolbar.h"

@implementation FJGameToolbar

+ (instancetype)toolbar
{
    return [[[NSBundle mainBundle]loadNibNamed:@"FJGameToolbar" owner:nil options:nil] firstObject];
}

+ (CGFloat)height
{
    return 50;
}

- (IBAction)showStrategyList:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(gameToolbarOnClickShowStrategyList:)]) {
        [self.delegate gameToolbarOnClickShowStrategyList:self];
    }
}

- (IBAction)writeStrategy:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(gameToolbarOnClickWriteStrategy:)]) {
        [self.delegate gameToolbarOnClickWriteStrategy:self];
    }
}

@end
