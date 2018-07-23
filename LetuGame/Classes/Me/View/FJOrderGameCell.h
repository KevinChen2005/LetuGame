//
//  FJOrderGameCell.h
//  LetuGame
//
//  Created by admin on 2018/7/18.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJOrderGame;

@interface FJOrderGameCell : UICollectionViewCell

@property (nonatomic, strong)FJOrderGame* game;

+ (UINib *)nib;

@end
