//
//  UIBarButtonItem+FJExtension.h
//  LetuGame
//
//  Created by  admin on 18/5/5.
//  Copyright © 2018年  admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (FJExtension)

/**
 *  导航栏添加控件
 *
 *  @param name     默认状态图片名字
 *  @param highName 高亮状态图片名字
 */
+ (instancetype)fj_itemWithImageName:(NSString *)name highImageName:(NSString *)highName target:(id)target action:(SEL)action;
    
@end
