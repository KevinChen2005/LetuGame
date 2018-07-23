//
//  XBMeHeaderView.m
//  xiu8iOS
//
//  Created by Scarecrow on 15/9/19.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "XBMeHeaderView.h"

@interface XBMeHeaderView()
{
    BOOL _isLogin;
}

@property (weak, nonatomic) IBOutlet UIView *circleBg;
@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *alreadyLoginView;
@property (weak, nonatomic) IBOutlet UIView *noLoginView;

@property (weak, nonatomic) IBOutlet UILabel *usernameView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@end

@implementation XBMeHeaderView

+ (instancetype)header
{
    return [[[NSBundle mainBundle]loadNibNamed:@"XBMeHeaderView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [self setupHeaderCircle];
    
    [super awakeFromNib];
}

- (void)setupHeaderCircle
{
    _isLogin = NO;
}

- (void)loginStateChanged:(BOOL)loginState nickname:(NSString*)nickname avatar:(NSString*)avatar
{
    _isLogin = loginState;
    
    self.noLoginView.hidden = loginState;
    self.alreadyLoginView.hidden = !loginState;
    
    NSString* avatarName = @"avator_default";
    NSString* nickName = @"点击登录";
    UIColor* textColor = [UIColor lightGrayColor];
    if (loginState) { //登录状态
        avatarName = [avatar isNullString] ? @"avator_default" : avatar;
        nickName = [nickname isNullString] ? @"xxxxxx" : nickname;
        textColor = [UIColor blackColor];
    }
    self.avatarView.image = [UIImage imageNamed:avatarName];
    self.usernameView.text = nickName;
    self.usernameView.textColor = textColor;
}

- (IBAction)clickLoginBtn:(id)sender
{
    if (_isLogin) { //已经登录，弹出显示详情资料
        if ([self.delegate respondsToSelector:@selector(XBMeHeaderViewBtnClicked:)]) {
            [self.delegate XBMeHeaderViewBtnClicked:XBMeHeaderViewButtonTypeUserinfo];
        }
    } else { //没有登录，弹出登录界面
        if ([self.delegate respondsToSelector:@selector(XBMeHeaderViewBtnClicked:)]) {
            [self.delegate XBMeHeaderViewBtnClicked:XBMeHeaderViewButtonTypeLogin];
        }
    }
}


@end
