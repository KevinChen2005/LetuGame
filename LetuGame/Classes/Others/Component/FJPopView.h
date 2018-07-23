//
//  FJPopView.h
//  LetuGame
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^popActionBlock)(void);

@interface FJPopView : NSObject

/**
 显示只有一个确定按钮的提示框

 @param title 提示框标题
 @param message 提示框消息
 */
+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message;

/**
 显示有一个确定按钮和一个取消按钮的提示框
 
 @param title 提示框标题
 @param message 提示框消息
 @param okBlock 点击确定后的回调block
 @param cancelBlock 点击取消后的回调block
 */
+ (void)showConfirmViewWithTitle:(NSString*)title message:(NSString*)message okBlock:(popActionBlock)okBlock cancelBlock:(popActionBlock)cancelBlock;

@end
