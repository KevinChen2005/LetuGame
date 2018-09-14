//
//  UILabel+FJ.h
//  LetuGame
//
//  Created by admin on 2018/9/3.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (FJ)

/**
 设置行间距
 */
//- (void)setLineSpacing:(CGFloat)lineSpacing;
@property (nonatomic, assign)CGFloat lineSpacing;

/**
 设置文字后所占的大小
 */
- (CGSize)sizeWhenFillText;

/**
 设置文字后所占的大小
 */
- (CGSize)sizeWhenFillTextWidth:(CGFloat)width;

@end
