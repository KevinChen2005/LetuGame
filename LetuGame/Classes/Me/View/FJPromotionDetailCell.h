//
//  FJPromotionDetailCell.h
//  LetuGame
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJPromotionDetailModel;

@interface FJPromotionDetailCell : UITableViewCell

@property (nonatomic, strong)FJPromotionDetailModel* promotionDetail;

+ (instancetype)cell;

+ (UINib*)nib;

+ (NSString*)reuseId;

+ (CGFloat)height;

@end
