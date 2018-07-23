//
//  FJStrategyCell.h
//  LetuGame
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJGame;
@protocol FJGameCellDelegate;

@interface FJGameCell : UITableViewCell

@property (nonatomic, strong) FJGame* game;
@property (nonatomic, weak) id<FJGameCellDelegate> delegate;

+ (UINib*)nib;

@end

@protocol FJGameCellDelegate <NSObject>

@optional

/**
 点击cell中我要玩回调

 @param gameCell 当前cell
 @param game cell中对应的游戏model
 */
- (void)gameCell:(FJGameCell*)gameCell clickWantPlayGame:(FJGame*)game;

@end
