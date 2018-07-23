//
//  FJDetailToolbar.h
//  LetuGame
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 com.langlun. All rights reserved.
//  文章详情toolbar

#import <UIKit/UIKit.h>

@protocol FJDetailToolbarDelegate;

@interface FJDetailToolbar : UIView

@property (nonatomic, weak) id <FJDetailToolbarDelegate> delegate;

@property (nonatomic, assign) NSInteger badgeValue;
@property (nonatomic, assign) BOOL isCollected;

+ (instancetype)toolBar;

@end


@protocol FJDetailToolbarDelegate <NSObject>

@optional

/**
 点击写评论回调
 */
- (void)detailToolbarOnClickWriteComment:(FJDetailToolbar*)toolBar;

/**
 点击显示评论列表回调
 */
- (void)detailToolbarOnClickShowCommentList:(FJDetailToolbar*)toolBar;

/**
 点击收藏回调
 */
- (void)detailToolbarOnClickFavorite:(FJDetailToolbar*)toolBar;

/**
 点击分享回调
 */
- (void)detailToolbarOnClickShare:(FJDetailToolbar*)toolBar;

/**
 点赞回调
 */
- (void)detailToolbarOnClickLike:(FJDetailToolbar*)toolBar;

@end
