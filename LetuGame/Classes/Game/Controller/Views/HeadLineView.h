//
//  PersonalHomeController.h
//  DailyRanking
//
//  Created by ymy on 15/11/12.
//  Copyright © 2015年 com.xianlaohu.multipeer. All rights reserved.

#import <UIKit/UIKit.h>

@class FJGameDetail;
@protocol HeadLineViewDelegate;

@interface HeadLineView : UIView

@property(nonatomic, strong) FJGameDetail* detail;

@property(nonatomic, weak) id<HeadLineViewDelegate> delegate;

+ (instancetype)headLineView;

+ (CGFloat)height;

@end

@protocol HeadLineViewDelegate <NSObject>

@optional

- (void)headLineView:(HeadLineView*)view onClickWantPlay:(UIButton*)wantPlayBtn;

@end

