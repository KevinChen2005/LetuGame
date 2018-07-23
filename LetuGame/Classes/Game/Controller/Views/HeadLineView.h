//
//  PersonalHomeController.h
//  DailyRanking
//
//  Created by ymy on 15/11/12.
//  Copyright © 2015年 com.xianlaohu.multipeer. All rights reserved.

#import <UIKit/UIKit.h>

@protocol headLineDelegate;
@class FJGameDetail;

@interface HeadLineView : UIView

@property(nonatomic, weak) id<headLineDelegate> delegate;
@property(nonatomic, strong) FJGameDetail* detail;

+ (instancetype)headLineView;

+ (CGFloat)height;

@end


@protocol headLineDelegate <NSObject>

@optional
- (void)refreshHeadLine:(NSInteger)currentIndex;

@end
