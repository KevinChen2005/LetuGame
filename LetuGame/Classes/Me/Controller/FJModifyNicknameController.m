//
//  FJModifyNicknameController.m
//  LetuGame
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJModifyNicknameController.h"

#define kMaxLength 10

@interface FJModifyNicknameController () <UITextFieldDelegate>

@property (nonatomic, strong)UITextField* nicknameField;
@property (nonatomic, strong)UIButton* sendBtn;

@end

@implementation FJModifyNicknameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改昵称";
    
    // 输入框
    UITextField* nicknameField = [UITextField new];
    nicknameField.borderStyle = UITextBorderStyleRoundedRect;
    nicknameField.placeholder = @"请输入你的昵称(长度0-10)";
    nicknameField.delegate = self;
    [nicknameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:nicknameField];
    [nicknameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(90);
        make.right.mas_equalTo(self.view);
        make.height.equalTo(@40);
    }];
    self.nicknameField = nicknameField;
    self.nicknameField.returnKeyType = UIReturnKeyDone;
    if (@available(iOS 10.0, *)) {
        self.nicknameField.textContentType = UITextContentTypeNickname;
    }
    self.nicknameField.text = [UserAuth shared].userInfo.nickName;
    
    // 发表按钮
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sendBtn setTitleColor:FJWhiteColor forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(0, 0, 50, 20);
    [sendBtn sizeToFit];
    [sendBtn.titleLabel setFont:FJNavbarItemFont];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn = sendBtn;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.nicknameField becomeFirstResponder];
}

- (void)send
{
    NSString* nickname = self.nicknameField.text;
    
    if ([nickname isNullString]) {
        [FJProgressHUB showInfoWithMessage:@"昵称不能为空" withTimeInterval:1.0];
        [self.nicknameField becomeFirstResponder];
        return;
    }
    
    if ([[UserAuth shared].userInfo.nickName isEqualToString:nickname]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [HttpTool modifyUserNickName:nickname Success:^(id retObj) {
        DLog(@"modifyUserNickName success retObj- %@", retObj);
        NSDictionary* retDict = retObj;
        NSString* code = [NSString stringWithString:retDict[@"code"]];
        NSString* message = [NSString stringWithString:retDict[@"message"]];
        if ([code isEqualToString:@"1"]) {
//            [FJProgressHUB showInfoWithMessage:@"修改昵称成功" withTimeInterval:1.5f];
            self.nicknameField.text = @"";
            [self.navigationController popViewControllerAnimated:YES];
            [self.view endEditing:YES];
            
            UserModel* userinfo = [UserAuth shared].userInfo;
            userinfo.nickName = nickname;
            [UserAuth saveUserInfo:userinfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationModifyNicknameSuccess object:nil];
        } else {
            [FJProgressHUB showInfoWithMessage:message withTimeInterval:1.5f];
        }
    } failure:^(NSError *error) {
        DLog(@"addNews failed - %@", error);
        [FJProgressHUB showInfoWithMessage:@"修改昵称失败，请检查网络" withTimeInterval:1.5f];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    CGFloat maxLength = kMaxLength;
    NSString *toBeString = textField.text;

    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (position && selectedRange) {
        return;
    }

    if (toBeString.length > maxLength) {
        NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
        if (rangeIndex.length == 1) {
            textField.text = [toBeString substringToIndex:maxLength];
        } else {
            NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
            textField.text = [toBeString substringWithRange:rangeRange];
        }
    }
}

@end
