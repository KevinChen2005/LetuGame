//
//  FJOrderGameCell.h
//  LetuGame
//
//  Created by admin on 2018/7/18.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJOrderGame;
@protocol FJOrderGameCellDelegate;

@interface FJOrderGameCell : UICollectionViewCell

@property (nonatomic, strong)FJOrderGame* game;

@property (nonatomic, weak)id<FJOrderGameCellDelegate> delegate;

+ (UINib *)nib;

@end

@protocol FJOrderGameCellDelegate <NSObject>

@optional
/**
 点击删除按钮回调
 */
- (void)orderGameCellOnDeleteAction:(FJOrderGameCell*)cell;

/**
 长按cell回调
 */
- (void)orderGameCellOnLongPressAction:(FJOrderGameCell*)cell;

@end
