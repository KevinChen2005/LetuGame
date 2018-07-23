//
//  FJSendCommentController.m
//  LetuGame
//
//  Created by admin on 2018/7/11.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJSendCommentController.h"
#import "FJNews.h"

@interface FJSendCommentController ()

@property (nonatomic, strong)UITextView* inputView;

@end

@implementation FJSendCommentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"评论";
    
    // 评论输入框
    UITextView* inputView = [UITextView new];
    inputView.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:inputView];
    self.inputView = inputView;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 返回按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 0);
    [button.titleLabel setFont:FJNavbarItemFont];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"nav_back_arrow"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_back_arrow"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // 发表按钮
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发表" forState:UIControlStateNormal];
    [sendBtn setTitleColor:FJRGBColor(0, 130, 188) forState:UIControlStateNormal];
    [sendBtn sizeToFit];
    [sendBtn.titleLabel setFont:FJNavbarItemFont];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.inputView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.inputView resignFirstResponder];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send
{
    NSString* content = self.inputView.text;
    
    if ([content isNullString]) {
        [FJProgressHUB showInfoWithMessage:@"内容不能为空" withTimeInterval:1.0];
        return;
    }
    
    [HttpTool addCommentWithType:@"news" kindId:self.news.ID content:content Success:^(id retObj) {
        DLog(@"addComment success retObj- %@", retObj);
        NSDictionary* retDict = retObj;
        NSString* code = [NSString stringWithString:retDict[@"code"]];
        NSString* message = [NSString stringWithString:retDict[@"message"]];
        if ([code isEqualToString:@"1"]) {
            [FJProgressHUB showInfoWithMessage:@"评论成功" withTimeInterval:1.0f];
            self.inputView.text = @"";
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.view endEditing:YES];
        } else {
            [FJProgressHUB showInfoWithMessage:message withTimeInterval:1.0f];
        }
    } failure:^(NSError *error) {
        DLog(@"addComment failed - %@", error);
    }];
    
}



@end
