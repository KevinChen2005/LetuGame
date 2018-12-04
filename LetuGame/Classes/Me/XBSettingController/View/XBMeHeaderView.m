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
@property (weak, nonatomic) IBOutlet UIImageView *editView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarConstraintY;

@end

@implementation XBMeHeaderView

+ (instancetype)header
{
    return [[[NSBundle mainBundle]loadNibNamed:@"XBMeHeaderView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupHeaderCircle];
}

- (void)setupHeaderCircle
{
    _isLogin = NO;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLoginBtn:)];
    self.editView.userInteractionEnabled = YES;
    [self.editView addGestureRecognizer:singleTap];
    
    self.avatarConstraintY.constant = -15;
}

- (void)loginStateChanged:(BOOL)loginState nickname:(NSString*)nickname avatar:(NSString*)avatar
{
    _isLogin = loginState;
    
    self.noLoginView.hidden = loginState;
    self.alreadyLoginView.hidden = !loginState;
    
    if (loginState) { //登录状态
        NSString* nickName = [nickname isNullString] ? @"xxxxxx" : nickname;
        self.usernameView.text = nickName;
        self.editView.hidden = NO;
        self.usernameView.textColor = [UIColor blackColor];
        self.usernameView.font = [UIFont boldSystemFontOfSize:17];
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    } else {
        self.editView.hidden = YES;
        self.usernameView.text = @"点击登录";
        self.usernameView.textColor = [UIColor lightGrayColor];
        self.usernameView.font = [UIFont systemFontOfSize:17];
        self.avatarView.image = [UIImage imageNamed:@"avatar_default"];
    }
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



