//
//  XBMeFooterView.m
//  xiu8iOS
//
//  Created by Scarecrow on 15/9/19.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "XBMeFooterView.h"

@interface XBMeFooterView()
{
    BOOL _isLogin;
}
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation XBMeFooterView

+ (instancetype)footer
{
    return [[[NSBundle mainBundle]loadNibNamed:@"XBMeFooterView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _isLogin = NO;
}

- (IBAction)clickLogoutBtn:(id)sender
{
    if (_isLogin) {
        if ([self.delegate respondsToSelector:@selector(XBMeFooterViewBtnClicked:)]) {
            [self.delegate XBMeFooterViewBtnClicked:XBMeFooterViewButtonTypeLogout];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(XBMeFooterViewBtnClicked:)]) {
            [self.delegate XBMeFooterViewBtnClicked:XBMeFooterViewButtonTypeLogin];
        }
    }
    
}

- (void)loginStateChanged:(BOOL)loginState
{
    _isLogin = loginState;
    
    NSString* title = @"登  录";
    if (loginState) { //登录状态
        title = @"退出登录";
    }
    [self.loginBtn setTitle:title forState:UIControlStateNormal];
}

@end
