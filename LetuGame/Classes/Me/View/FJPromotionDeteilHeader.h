//
//  FJPromotionDeteilHeader.h
//  LetuGame
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^retHeightBlock)(CGFloat);

@class FJPromotion;

@interface FJPromotionDeteilHeader : UIView

@property (nonatomic, strong)FJPromotion* promotion;

@property (nonatomic, copy)retHeightBlock retBlock;

/**
 构造一个header
 */
+ (instancetype)header;

/**
 返回高度
 */
+ (CGFloat)height;

@end
