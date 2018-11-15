//
//  FJDetailToolbar.m
//  LetuGame
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJDetailToolbar.h"
#import "FJBadgeButton.h"

#define ShareBtnWidth 50

@interface FJDetailToolbar()

@property(nonatomic, strong)FJBadgeButton* commentNumBtn;
@property(nonatomic, strong)UIButton* collectionBtn;

@end

@implementation FJDetailToolbar

+ (instancetype)toolBar
{
    return [[FJDetailToolbar alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.badgeValue = 0;
        
        [self setupToolBar];
    }
    
    return self;
}

- (void)setupToolBar
{
    // 1.顶部分割线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(self);
        if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
            make.height.mas_equalTo(@1);
        } else {
            make.height.mas_equalTo(@0.5);
        }
    }];
    
    
//    // 2.分享按钮
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [shareBtn setImage:[UIImage imageNamed:@"home_011daohangfenxiang"] forState:UIControlStateNormal];
//
//    [shareBtn addTarget:self action:@selector(clickWriteShareBtn:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self addSubview:shareBtn];
//    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self);
//        make.top.equalTo(self);
//        make.width.mas_equalTo(ShareBtnWidth);
//        make.height.mas_equalTo(ToolBarHeight);
//    }];
//    
//    // 2.点赞按钮
//    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [likeBtn setImage:[UIImage imageNamed:@"home_huisedianzan"] forState:UIControlStateNormal];
//    [likeBtn setImage:[UIImage imageNamed:@"home_hongsedianzan"] forState:UIControlStateSelected];
//
//    [likeBtn addTarget:self action:@selector(clickWriteLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self addSubview:shareBtn];
//    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self);
//        make.top.equalTo(self);
//        make.width.mas_equalTo(ShareBtnWidth);
//        make.height.mas_equalTo(ToolBarHeight);
//    }];
    
    // 3.收藏按钮
    UIButton *CollectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [CollectionBtn setImage:[UIImage imageNamed:@"home_hongshoucang"] forState:UIControlStateNormal];
    [CollectionBtn setImage:[UIImage imageNamed:@"home_hongshoucang_s"] forState:UIControlStateSelected];
    [CollectionBtn addTarget:self action:@selector(clickCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:CollectionBtn];
    [CollectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.width.mas_equalTo(ShareBtnWidth);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    self.collectionBtn = CollectionBtn;
    
    // 4.显示评论数按钮
    FJBadgeButton *commentNumBtn = [[FJBadgeButton alloc]init];
    commentNumBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [commentNumBtn setImage:[UIImage imageNamed:@"home_07danghangpinglun"] forState:UIControlStateNormal];
    [commentNumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [commentNumBtn addTarget:self action:@selector(clickCommentNumBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentNumBtn];
    [commentNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(CollectionBtn.mas_left);
        make.top.mas_equalTo(self).offset(2);
        make.width.mas_equalTo(ShareBtnWidth);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    commentNumBtn.badgeValue = self.badgeValue;
    self.commentNumBtn = commentNumBtn;
    
    // 5.写评论按钮
    UIButton *xiePingLunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xiePingLunBtn.layer.cornerRadius = 10;
    xiePingLunBtn.layer.masksToBounds = YES;
    xiePingLunBtn.layer.borderColor = [UIColor grayColor].CGColor;
    xiePingLunBtn.layer.borderWidth = 0.5;
    
    xiePingLunBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [xiePingLunBtn setTitle:@"写评论..." forState:UIControlStateNormal];
    [xiePingLunBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    xiePingLunBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    xiePingLunBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    xiePingLunBtn.backgroundColor = FJRGBColor(252, 252, 252);
    
    [xiePingLunBtn addTarget:self action:@selector(clickWriteCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:xiePingLunBtn];
    
    [xiePingLunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(commentNumBtn.mas_left).offset(-10);
        make.top.equalTo(self.mas_top).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
    }];
}

- (void)setBadgeValue:(NSInteger)badgeValue
{
    _badgeValue = badgeValue;
    
    self.commentNumBtn.badgeValue = badgeValue;
}

- (void)setIsCollected:(BOOL)isCollected
{
    _isCollected = isCollected;
    self.collectionBtn.selected = isCollected;
}

#pragma mark - click event

- (void)clickCollectionBtn:(UIButton *)btn
{
//    btn.selected = !btn.selected;
    
    if ([self.delegate respondsToSelector:@selector(detailToolbarOnClickFavorite:)]) {
        [self.delegate detailToolbarOnClickFavorite:self];
    }
}

- (void)clickCommentNumBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(detailToolbarOnClickShowCommentList:)]) {
        [self.delegate detailToolbarOnClickShowCommentList:self];
    }
}

- (void)clickWriteCommentBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(detailToolbarOnClickWriteComment:)]) {
        [self.delegate detailToolbarOnClickWriteComment:self];
    }
}

- (void)clickWriteShareBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(detailToolbarOnClickShare:)]) {
        [self.delegate detailToolbarOnClickShare:self];
    }
}

- (void)clickWriteLikeBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if ([self.delegate respondsToSelector:@selector(detailToolbarOnClickLike:)]) {
        [self.delegate detailToolbarOnClickLike:self];
    }
}

@end
