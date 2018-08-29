//
//  FJPromotionHeader.h
//  LetuGame
//
//  Created by admin on 2018/7/30.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FJPromotionHeaderDelegate;

@interface FJPromotionHeader : UIView

@property (nonatomic, weak)id<FJPromotionHeaderDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

+ (instancetype)header;

@end

@protocol FJPromotionHeaderDelegate <NSObject>

@optional
- (void)promotionHeader:(FJPromotionHeader*)header onClickSearchWithBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate;

@end
