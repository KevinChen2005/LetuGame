//
//  FJPromotionCell.h
//  LetuGame
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJPromotion;

@interface FJPromotionCell : UITableViewCell

@property (nonatomic, strong)FJPromotion* promotion;

+ (instancetype)cell;

@end
