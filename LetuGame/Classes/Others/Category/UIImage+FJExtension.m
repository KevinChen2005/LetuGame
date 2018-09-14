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

+ (UIImage *)imageWithColor:(UIColor *)color
{
    
    CGRect rect =CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    
    if (!color || size.width <=0 || size.height <=0) return nil;
    
    CGRect rect =CGRectMake(0.0f,0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (UIImage*)fillWithColor:(UIColor*)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, (CGRect){ {0,0}, self.size} );
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, self.size.height);
    CGContextConcatCTM(context, flipVertical);
    CGContextDrawImage(context, rect, [self CGImage]);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
//    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//
//
//    [color setFill];
//    CGContextFillRect(context, rect);
//    CGContextSetBlendMode(context, kCGBlendModeCopy);
//    [self drawInRect:rect];
//
//    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return image;
}

@end
