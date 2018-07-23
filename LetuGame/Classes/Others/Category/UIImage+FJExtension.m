//
//  UIImage+FJExtension.m
//  LetuGame
//
//  Created by  admin on 18/5/30.
//  Copyright © 2018年  admin. All rights reserved.
//

#import "UIImage+FJExtension.h"

@implementation UIImage (FJExtension)

- (UIImage *)circleImage {
    
    // NO -> 透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圈
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
