//
//  FJIdentificationViewController.m
//  LetuGame
//
//  Created by admin on 2018/12/24.
//  Copyright © 2018 com.langlun. All rights reserved.
//

#import "FJIdentificationViewController.h"
#import "FJUserDetailModel.h"
#import "FJConfirmPwdViewController.h"

@interface FJIdentificationViewController () <FJConfirmPwdDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginConstraint;

@property (weak, nonatomic) IBOutlet UITextField *nameField; //真实姓名
@property (weak, nonatomic) IBOutlet UITextField *codeField; //身份证号码
@property (weak, nonatomic) IBOutlet UITextField *banknoField; //银行卡号码
@property (weak, nonatomic) IBOutlet UITextField *bankinfoField; //银行卡信息

@end

@implementation FJIdentificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的账户";
    self.view.backgroundColor = FJWhiteColor;
    
    self.topMarginConstraint.constant = iphoneX ? (90 + 24) : 90;
    
    WEAKSELF
    [HttpTool getUserDetailSuccess:^(id retObj) {
        STRONGSELF
        DLog(@"retObj = %@", retObj);
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSDictionary* dataDict = retDict[@"data"];
            if (dataDict == nil || [dataDict isEqual:[NSNull null]]) {
                return ;
            }
            
            FJUserDetailModel* userDetail = [FJUserDetailModel mj_objectWithKeyValues:dataDict];
            [strongSelf updateData:userDetail];
        }
    } failure:^(NSError *error) {
        DLog(@"error=%@", error);
    }];
}

- (void)updateData:(FJUserDetailModel*)userDetail
{
    self.nameField.text = userDetail.realName;
    self.codeField.text = userDetail.idNumber;
    self.banknoField.text = userDetail.bankCardNumber;
    self.bankinfoField.text = userDetail.openBank;
}

- (IBAction)onClickSubmit:(id)sender
{
    FJConfirmPwdViewController* confirmPwdVC = [FJConfirmPwdViewController new];
    confirmPwdVC.delegate = self;
    
    UIWindow* keyWindow = [CommTool getCurrentWindow];
    UIViewController* rootVC = keyWindow.rootViewController;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        confirmPwdVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }else{
        rootVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    
    if (rootVC.presentedViewController == nil){
        [rootVC presentViewController:confirmPwdVC animated:NO completion:nil];
    }
}

- (void)sendSubmitInfoWithPwd:(NSString*)password
{
    NSString* name = self.nameField.text;
    NSString* code = self.codeField.text;
    NSString* bankno = self.banknoField.text;
    NSString* bankinfo = self.bankinfoField.text;
    
    [self.view endEditing:YES];
    
    if (name == nil || [name isNullString]) {
        [FJProgressHUB showInfoWithMessage:@"请输入姓名" withTimeInterval:1.5f];
        return;
    }
    
    if (code == nil || [code isNullString]) {
        [FJProgressHUB showInfoWithMessage:@"请输入身份证号" withTimeInterval:1.5f];
        return;
    }
    
    //    if (![code isIDCard]) {
    //        [FJProgressHUB showInfoWithMessage:@"请输入正确的身份证号码" withTimeInterval:1.5f];
    //        return;
    //    }
    
    if (bankno == nil || [bankno isNullString]) {
        [FJProgressHUB showInfoWithMessage:@"请输入银行卡号" withTimeInterval:1.5f];
        return;
    }
    
    //    if (![bankno isBankCardNumber]) {
    //        [FJProgressHUB showInfoWithMessage:@"请输入正确的银行卡号码" withTimeInterval:1.5f];
    //        return;
    //    }
    
    if (bankinfo == nil || [bankinfo isNullString]) {
        [FJProgressHUB showInfoWithMessage:@"请输入银行卡信息" withTimeInterval:1.5f];
        return;
    }
    
    [HttpTool updateUserDetailWithRealName:name idNumber:code bankCardNumber:bankno openBank:bankinfo idCardUrl1:@"" idCardUrl2:@"" password:password Success:^(id retObj) {
        DLog(@"retObj=%@", retObj);
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            [FJProgressHUB showInfoWithMessage:@"提交成功" withTimeInterval:1.5f];
        } else {
            [FJProgressHUB showInfoWithMessage:@"提交失败" withTimeInterval:1.5f];
        }
    } failure:^(NSError *error) {
        DLog(@"提交用户认证信息失败，请检查网络，error=%@", error);
        [FJProgressHUB showInfoWithMessage:@"提交失败，请检查网络" withTimeInterval:1.5f];
    }];
}

#pragma mark - FJConfirmPwdDelegate

- (void)confirmPwdCallback:(NSString *)password
{
    [self sendSubmitInfoWithPwd:password];
}

@end
