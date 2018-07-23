//
//  FJBadgeButton.m
//  LetuGame
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJBadgeButton.h"

#define kBadgeFont [UIFont systemFontOfSize:9]
#define kBadgeW 14
#define kBadgeH 14
#define kBadgeCornerRadius (kBadgeW*0.5)

@interface FJBadgeButton()

@property (nonatomic, strong) UILabel *badgeLab;

@end


@implementation FJBadgeButton

-(instancetype)init
{
    self = [super init];
    if (self) {
        _badgeLab = [[UILabel alloc] init];
        _badgeLab.backgroundColor = FJRGBColor(251, 85, 85);
        _badgeLab.font = kBadgeFont;
        _badgeLab.textColor = [UIColor whiteColor];
        _badgeLab.clipsToBounds = YES;
        _badgeLab.layer.cornerRadius = kBadgeCornerRadius;
        _badgeLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_badgeLab];
        
        [_badgeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(6);
            make.right.equalTo(self).offset(-5);
            make.width.height.equalTo(@kBadgeW);
        }];
        
        self.badgeValue = 0;
    }
    return self;
}

-(void)setBadgeValue:(NSInteger)badgeValue
{
    _badgeValue = badgeValue;
    
    if (_badgeValue <= 0) {
        _badgeValue = 0;
    }
    
    NSString* text = @"";
    if (_badgeValue > 999) {
        text = @"999+";
    }else{
        text = [NSString stringWithFormat:@"%ld",(long)_badgeValue];
    }
    
    CGSize size = [self sizeWithText:text withFont:kBadgeFont];
    NSInteger w = size.width + 6;
    NSInteger textWidth = w < kBadgeW ? kBadgeW : w;
    
    [self.badgeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithInteger:textWidth]);
    }];
    _badgeLab.text = text;
}

- (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font
{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    
    return size;
}

@end



