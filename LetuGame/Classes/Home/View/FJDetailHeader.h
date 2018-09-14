//
//  FJDetailCell.h
//  LetuGame
//
//  Created by admin on 2018/7/12.
//  Copyright © 2018年 com.langlun. All rights reserved.
//  头部视图，存放webView显示文章正文

#import <UIKit/UIKit.h>

@protocol FJDetailHeaderDelegate;
@class FJNewsDetail;

typedef void(^completeBlock)(NSInteger height);

@interface FJDetailHeader : UIView

@property (nonatomic, weak)id<FJDetailHeaderDelegate> delegate;

@property(nonatomic, strong)FJNewsDetail* newsDetail;
@property (nonatomic, assign)NSInteger likeCount;
@property (nonatomic, assign)BOOL isLiked;

- (void)startLoadHtmlString:(NSString *)htmlString CompleteBlock:(completeBlock)complete;

@end


@protocol FJDetailHeaderDelegate <NSObject>

- (void)detailHeader:(FJDetailHeader*)header onClickUrlLink:(NSString*)urlString;

- (void)detailHeader:(FJDetailHeader*)header onClickLikeBtn:(id)obj;

@end
