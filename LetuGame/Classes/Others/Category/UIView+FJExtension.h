//
//  UIView+FJExtension.h
//  LetuGame
//
//  Created by  admin on 18/5/4.
//  Copyright © 2018年  admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FJExtension)

@property (nonatomic, assign) CGFloat fj_width;
@property (nonatomic, assign) CGFloat fj_height;
@property (nonatomic, assign) CGFloat fj_x;
@property (nonatomic, assign) CGFloat fj_y;
@property (nonatomic, assign) CGSize fj_size;
@property (nonatomic, assign) CGFloat fj_centerX;
@property (nonatomic, assign) CGFloat fj_centerY;

/**
 *  是否在窗口上
 */
- (BOOL)isShowingOnKeyWindow;

@end
