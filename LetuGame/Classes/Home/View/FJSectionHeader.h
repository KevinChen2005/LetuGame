//
//  FJSectionHeader.h
//  LetuGame
//
//  Created by admin on 2018/7/12.
//  Copyright © 2018年 com.langlun. All rights reserved.
//  表格的section header

#import <UIKit/UIKit.h>

@interface FJSectionHeader : UIView

@property(nonatomic, copy)NSString* title;

+ (instancetype)headerWithTitle:(NSString*)title;
+ (NSInteger)height;

@end
