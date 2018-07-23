//
//  XBMeHeaderView.h
//  xiu8iOS
//
//  Created by Scarecrow on 15/9/19.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XBMeFooterViewButtonType)
{
    XBMeFooterViewButtonTypeLogin,         //登录
    XBMeFooterViewButtonTypeLogout,        //退出登录
};

@protocol XBMeFooterViewDelegate <NSObject>

- (void)XBMeFooterViewBtnClicked:(XBMeFooterViewButtonType)type;

@end

@interface XBMeFooterView : UIView

@property (nonatomic,weak) id<XBMeFooterViewDelegate> delegate;

+ (instancetype)footer;
- (void)loginStateChanged:(BOOL)loginState;

@end
