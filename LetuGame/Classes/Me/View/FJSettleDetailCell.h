//
//  FJSettleDetailCell.h
//  LetuGame
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJSettleDetailModel;

@interface FJSettleDetailCell : UITableViewCell

@property (nonatomic, strong)FJSettleDetailModel* settle;

+ (UINib*)nib;

+ (instancetype)cell;

+ (NSString*)reuseId;

+ (CGFloat)height;

@end
