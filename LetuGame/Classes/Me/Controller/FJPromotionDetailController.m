//
//  FJPromotionDetailController.m
//  LetuGame
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJPromotionDetailController.h"
#import "FJPromotion.h"

@interface FJPromotionDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *regNum;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UITextView *promotionLink;

@end

@implementation FJPromotionDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"推广详情";
    
    self.name.text = self.promotion.gameName;
    self.regNum.text = [NSString stringWithFormat:@"%ld", (long)self.promotion.registNum];
    self.money.text = [NSString stringWithFormat:@"%0.2f", self.promotion.payMoney];
    self.code.text = self.promotion.code;
    
    NSMutableString* linkInfo = [NSMutableString string];
    NSArray* links = self.promotion.downloadBean;
    [links enumerateObjectsUsingBlock:^(FJDownloadBean*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [linkInfo appendString:[CommTool safeString:obj.os]];
        [linkInfo appendString:@"下载地址: \n"];
        [linkInfo appendString:[CommTool safeString:obj.url]];
        [linkInfo appendString:@"\n"];
    }];
    self.promotionLink.text = linkInfo;
}

- (IBAction)onClickShare:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString* shareInfo = [NSString stringWithFormat:@"欢迎下载体验《%@》\n推广码：%@ \n%@", self.promotion.gameName, self.promotion.code, self.promotionLink.text];
    pasteboard.string = shareInfo;
    
    [FJProgressHUB showInfoWithMessage:@"复制成功" withTimeInterval:1.5f];
}


@end
