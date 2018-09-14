//
//  FJPopView.m
//  LetuGame
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJPopView.h"

@implementation FJPopView

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

+ (void)showConfirmViewWithTitle:(NSString *)title message:(NSString *)message okBlock:(popActionBlock)okBlock cancelBlock:(popActionBlock)cancelBlock
{
    [self showConfirmViewWithTitle:title message:message okTitle:@"确定" cancelTitle:@"取消" okBlock:okBlock cancelBlock:cancelBlock];
}

+ (void)showConfirmViewWithTitle:(NSString*)title message:(NSString*)message okTitle:(NSString*)okTitle cancelTitle:(NSString*)cancelTitle okBlock:(popActionBlock)okBlock cancelBlock:(popActionBlock)cancelBlock
{
    //弹出选择框
    UIAlertController* alercontroller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //取消按钮
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(cancelTitle, nil)  style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                                   {
                                       if (cancelBlock) {
                                           cancelBlock();
                                       }
                                   }];
    [alercontroller addAction:cancelAction];
    
    //确定按钮
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(okTitle, nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        if (okBlock) {
                                            okBlock();
                                        }
                                    }];
    [alercontroller addAction:defaultAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alercontroller animated:YES completion:nil];
}

+ (void)showConfirmViewWithTitle:(NSString *)title message:(NSString *)message okBlock:(popActionBlock)okBlock
{
    //弹出选择框
    UIAlertController* alercontroller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //确定按钮
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        if (okBlock) {
                                            okBlock();
                                        }
                                    }];
    [alercontroller addAction:defaultAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alercontroller animated:YES completion:nil];
}
@end
