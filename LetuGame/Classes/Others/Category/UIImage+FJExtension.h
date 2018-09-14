//
//  UIImage+FJExtension.h
//  LetuGame
//
//  Created by  admin on 18/5/30.
//  Copyright © 2018年  admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FJExtension)

/**
 *  圆图
 */
- (UIImage *)circleImage;

- (UIImage*)fillWithColor:(UIColor*)color;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
