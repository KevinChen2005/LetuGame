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
        make.width.equalTo(self);;
        make.height.equalTo(@(0.5));
    }];
    
    
//    // 2.分享按钮
//    UIButton *shareBtn = ({
//        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
//        [view setImage:[UIImage imageNamed:@"home_011daohangfenxiang"] forState:UIControlStateNormal];
//
//        [view addTarget:self action:@selector(clickWriteShareBtn:) forControlEvents:UIControlEventTouchUpInside];
//
//        [self addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self);
//            make.top.equalTo(self);
//            make.width.mas_equalTo(ShareBtnWidth);
//            make.height.mas_equalTo(ToolBarHeigth);
//        }];
//        view;
//    });
    
//    // 2.点赞按钮
//    UIButton *likeBtn = ({
//        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
//        [view setImage:[UIImage imageNamed:@"home_huisedianzan"] forState:UIControlStateNormal];
//        [view setImage:[UIImage imageNamed:@"home_hongsedianzan"] forState:UIControlStateSelected];
//
//        [view addTarget:self action:@selector(clickWriteLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
//
//        [self addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self);
//            make.top.equalTo(self);
//            make.width.mas_equalTo(ShareBtnWidth);
//            make.height.mas_equalTo(ToolBarHeigth);
//        }];
//        view;
//    });
    
    
    // 3.收藏按钮
    UIButton *CollectionBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"home_hongshoucang"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"home_hongshoucang_s"] forState:UIControlStateSelected];
        [view addTarget:self action:@selector(clickCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.width.mas_equalTo(ShareBtnWidth);
            make.height.mas_equalTo(ToolBarHeight);
        }];
        view;
    });
    self.collectionBtn = CollectionBtn;
    
    // 4.显示评论按钮
//    UIButton *commentNumBtn = ({
//        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
//        view.titleLabel.font = [UIFont systemFontOfSize:13];
//        [view setImage:[UIImage imageNamed:@"home_07danghangpinglun"] forState:UIControlStateNormal];
//        [view setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [view addTarget:self action:@selector(clickCommentNumBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(CollectionBtn.mas_left);
//            make.top.equalTo(self);
//            make.width.mas_equalTo(ShareBtnWidth);
//            make.height.mas_equalTo(ToolBarHeigth);
//        }];
//        view;
//    });
    
    FJBadgeButton *commentNumBtn = ({
//        FJBadgeButton *view = [FJBadgeButton buttonWithType:UIButtonTypeCustom];
        FJBadgeButton *view = [[FJBadgeButton alloc]init];
        view.titleLabel.font = [UIFont systemFontOfSize:13];
        [view setImage:[UIImage imageNamed:@"home_07danghangpinglun"] forState:UIControlStateNormal];
        [view setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(clickCommentNumBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(CollectionBtn.mas_left);
            make.top.mas_equalTo(self).offset(2);
            make.width.mas_equalTo(ShareBtnWidth);
            make.height.mas_equalTo(ToolBarHeight);
        }];
        view;
    });
    commentNumBtn.badgeValue = self.badgeValue;
    self.commentNumBtn = commentNumBtn;
    
    // 5.写评论按钮
    UIButton *xiePingLunBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        view.layer.borderColor = [UIColor grayColor].CGColor;
        view.layer.borderWidth = 0.5;
        
        view.titleLabel.font = [UIFont systemFontOfSize:14];
        [view setTitle:@"写评论..." forState:UIControlStateNormal];
        [view setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        view.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        view.contentEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        view.backgroundColor = FJRGBColor(252, 252, 252);
        
        [view addTarget:self action:@selector(clickWriteCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(commentNumBtn.mas_left).offset(-10);
            make.top.equalTo(self.mas_top).offset(8);
            make.bottom.equalTo(self.mas_bottom).offset(-8);
        }];
        view;
    });
    [xiePingLunBtn class]; //无意义调用，防止xiePingLunBtn unused警告
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
