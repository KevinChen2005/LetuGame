//
//  PersonalHomeController.h
//  DailyRanking
//
//  Created by ymy on 15/11/12.
//  Copyright © 2015年 com.xianlaohu.multipeer. All rights reserved.

#import <UIKit/UIKit.h>

@class FJGameDetail;

@interface HeadLineView : UIView

@property(nonatomic, strong) FJGameDetail* detail;

+ (instancetype)headLineView;

+ (CGFloat)height;

@end

