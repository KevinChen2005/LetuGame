//
//  FJSectionHeader.m
//  LetuGame
//
//  Created by admin on 2018/7/12.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJSectionHeader.h"

#define kTopMargin 9
#define kBottomMargin 1
#define kContentViewH 30

@interface FJSectionHeader()

@property (nonatomic, strong)UILabel* titleLabel;

@end

@implementation FJSectionHeader

+ (instancetype)headerWithTitle:(NSString *)title
{
    return [[self alloc] initWithTitle:title];
}

+ (NSInteger)height
{
    return kTopMargin + kBottomMargin + kContentViewH;
}

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        self.backgroundColor = FJGlobalBG;
        self.title = title;
        
        UIView* contentView = [UIView new];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@kContentViewH);
            make.bottom.equalTo(self).offset(-kBottomMargin);
        }];
        
        UIView* redView = [UIView new];
        redView.backgroundColor = [UIColor redColor];
        [contentView addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@3);
            make.left.mas_equalTo(contentView.mas_left).offset(10);
            make.top.mas_equalTo(contentView.mas_top).offset(8);
            make.bottom.mas_equalTo(contentView.mas_bottom).offset(-8);
        }];
        
        UILabel* titleLabel = [UILabel new];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(redView.mas_right).offset(3);
            make.top.bottom.equalTo(contentView);
            make.right.equalTo(contentView).offset(10);
        }];
        titleLabel.text = title;
        self.titleLabel = titleLabel;
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

@end
