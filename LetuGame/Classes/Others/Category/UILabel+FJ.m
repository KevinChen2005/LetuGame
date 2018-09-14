//
//  UILabel+FJ.m
//  LetuGame
//
//  Created by admin on 2018/9/3.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "UILabel+FJ.h"
#import <objc/runtime.h>

static CGFloat g_linespacing = 0.0;

@implementation UILabel (FJ)

- (CGFloat)lineSpacing
{
    return [objc_getAssociatedObject(self, @"lineSpacingSelf") floatValue];
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    g_linespacing = lineSpacing;
//    objc_setAssociatedObject(self, @"lineSpacingSelf", @(lineSpacing), OBJC_ASSOCIATION_ASSIGN);
    
    [self buildLineSpacing:lineSpacing];
}

- (void)buildLineSpacing:(CGFloat)lineSpacing
{
    if (self.text == nil) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;  //设置行间距
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}

- (CGSize)sizeWhenFillText
{
    CGFloat width = self.frame.size.width;
    
    return [self sizeWhenFillTextWidth:width];
}

/**
 设置文字后所占的大小
 */
- (CGSize)sizeWhenFillTextWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = self.lineBreakMode;
    paraStyle.alignment = self.textAlignment;
    paraStyle.lineSpacing = g_linespacing;
    NSDictionary *dic = @{
                          NSFontAttributeName           : self.font,
                          //                          NSParagraphStyleAttributeName : paraStyle
                          };
    CGSize sizeOneline = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    CGSize sizeNoAttribute = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    int lineNumber = (int)sizeNoAttribute.height/sizeOneline.height;
    
    CGSize size = sizeNoAttribute;
    
    if (g_linespacing > 0.0 && lineNumber > 1) { //如果设置了行距
        size.height = size.height + g_linespacing * (lineNumber+1);
    }
    
    return size;
}
@end
