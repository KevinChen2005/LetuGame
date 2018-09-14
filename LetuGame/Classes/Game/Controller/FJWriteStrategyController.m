//
//  FJWriteStrategyController.m
//  LetuGame
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJWriteStrategyController.h"
#import "FJGame.h"

@interface FJWriteStrategyController ()

@property (nonatomic, strong)UITextField* titleView;
@property (nonatomic, strong)UITextView* contentView;

@end

@implementation FJWriteStrategyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"写攻略";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // titleLabel
    UILabel* titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.text = @"攻略标题：";
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@80);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    // title view
    UITextField* titleView = [UITextField new];
    titleView.borderStyle = UITextBorderStyleRoundedRect;
    titleView.placeholder = @"输入攻略标题";
    titleView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.equalTo(@30);
    }];
    self.titleView = titleView;

    // content label
    UILabel* contentLabel = [UILabel new];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = [UIColor darkTextColor];
    contentLabel.text = @"攻略内容：";
    [self.view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
        make.top.mas_equalTo(titleView.mas_bottom).offset(10);
    }];

    // content view
    UITextView* contentView = [UITextView new];
    contentView.font = [UIFont systemFontOfSize:18];
    contentView.layer.borderColor = FJRGBColor(239, 239, 239).CGColor;
    contentView.layer.borderWidth = 0.8;
    contentView.layer.cornerRadius = 5;
    [self.view addSubview:contentView];
    self.contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.top.mas_equalTo(contentLabel.mas_bottom).offset(8);
        make.bottom.mas_equalTo(self.view).offset(-300);
    }];

    // 发表按钮
    UIButton *sendBtn = [CommTool submitButtonWithTarget:self Action:@selector(send)];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.titleView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)send
{
    NSString* title = self.titleView.text;
    NSString* content = self.contentView.text;
    
    if ([title isNullString]) {
        [FJProgressHUB showInfoWithMessage:@"标题不能为空" withTimeInterval:1.0];
        [self.titleView becomeFirstResponder];
        return;
    }
    
    if ([content isNullString]) {
        [FJProgressHUB showInfoWithMessage:@"内容不能为空" withTimeInterval:1.0];
        [self.contentView becomeFirstResponder];
        return;
    }
    
    //内容加上换行的html标签
    NSString* formatContent = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    formatContent = [formatContent stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
    [HttpTool addNewsWithGameId:self.game.gameId title:title content:formatContent typeOne:@"news" typeTwo:@"" success:^(id retObj) {
        DLog(@"addNews success retObj- %@", retObj);
        NSDictionary* retDict = retObj;
        NSString* code = [NSString stringWithString:retDict[@"code"]];
        NSString* message = [NSString stringWithString:retDict[@"message"]];
        if ([code isEqualToString:@"1"]) {
            [FJProgressHUB showInfoWithMessage:@"添加攻略成功" withTimeInterval:1.5f];
            self.titleView.text = @"";
            self.contentView.text = @"";
            [self.navigationController popViewControllerAnimated:YES];
            [self.view endEditing:YES];
        } else {
            [FJProgressHUB showInfoWithMessage:message withTimeInterval:1.5f];
        }
    } failure:^(NSError *error) {
        DLog(@"addNews failed - %@", error);
        [FJProgressHUB showInfoWithMessage:@"添加攻略失败，请检查网络" withTimeInterval:1.5f];
    }];
}

@end
