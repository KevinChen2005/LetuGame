//
//  FJStrategyCell.h
//  LetuGame
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJNews;

@interface FJNewsCell : UITableViewCell

@property (nonatomic, strong) FJNews* news;

+ (UINib*)nib;

@end
