//
//  XBMeHeaderView.h
//  xiu8iOS
//
//  Created by Scarecrow on 15/9/19.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XBMeHeaderViewButtonType) {
    XBMeHeaderViewButtonTypeLogin,        //登录
    XBMeHeaderViewButtonTypeUserinfo,     //用户详细资料
    XBMeHeaderViewButtonTypeRegister,
    XBMeHeaderViewButtonTypeHistory,
    XBMeHeaderViewButtonTypeAttention,
    XBMeHeaderViewButtonTypeGuard
};

@protocol XBMeHeaderViewDelegate <NSObject>

- (void)XBMeHeaderViewBtnClicked:(XBMeHeaderViewButtonType)type;

@end

@interface XBMeHeaderView : UIView

@property (nonatomic,weak) id<XBMeHeaderViewDelegate> delegate;

+ (instancetype)header;

- (void)loginStateChanged:(BOOL)loginState nickname:(NSString*)nickname avatar:(NSString*)avatar;

@end
