//
//  FJPromotionDeteilHeader.m
//  LetuGame
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJPromotionDeteilHeader.h"
#import "FJPromotion.h"

#define kPromotionDetailHeaderHeight 470.0

static CGFloat g_height = kPromotionDetailHeaderHeight;

@interface FJPromotionDeteilHeader()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *regNum;
@property (weak, nonatomic) IBOutlet UILabel *chongzhi;
@property (weak, nonatomic) IBOutlet UILabel *radio;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *isPayLabel;
@property (weak, nonatomic) IBOutlet UITextView *promotionLink;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *promotionMonth;

@end

@implementation FJPromotionDeteilHeader

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    g_height = kPromotionDetailHeaderHeight;
}

- (IBAction)onClickShare:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString* shareInfo = [NSString stringWithFormat:@"欢迎下载体验《%@》\n推广码：%@ \n%@", self.promotion.gameName, self.promotion.code, self.promotionLink.text];
    pasteboard.string = shareInfo;
    
    [FJProgressHUB showInfoWithMessage:@"复制成功" withTimeInterval:1.5f];
}

+ (instancetype)header
{
    return [[[NSBundle mainBundle] loadNibNamed:@"FJPromotionDeteilHeader" owner:nil options:nil] firstObject];
}

+ (CGFloat)height
{
    return g_height;
}

- (void)setPromotion:(FJPromotion *)promotion
{
    _promotion = promotion;
    
    self.name.text = promotion.gameName;
    self.regNum.text = [NSString stringWithFormat:@"%ld", (long)promotion.registNum];
    self.chongzhi.text = [NSString stringWithFormat:@"%0.2f", promotion.payMoney];
    self.money.text = [NSString stringWithFormat:@"%0.2f", promotion.agentMoney];
    self.code.text = promotion.code;
    self.radio.text = promotion.radio;
    self.isPayLabel.text = promotion.isChecked ? @"是" : @"否";
    self.promotionMonth.text = promotion.promotionMonth;
    
    NSMutableString* linkInfo = [NSMutableString string];
    NSArray* links = promotion.downloadBean;
    [links enumerateObjectsUsingBlock:^(FJDownloadBean*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.url != nil && ![obj.url isEqualToString:@""]) {
            [linkInfo appendString:[CommTool safeString:obj.os]];
            [linkInfo appendString:@"下载地址: \n"];
            [linkInfo appendString:[CommTool safeString:obj.url]];
            [linkInfo appendString:@"\n"];
        }
    }];
    
    if ([linkInfo isNullString]) { //如果没有下载链接
        [linkInfo appendString:@"暂无推广链接！"];
        self.shareBtn.hidden = YES; //隐藏分享链接按钮
        self.shareBtnHeightConstraint.constant = 0; //设置分享按钮约束高度为0
        g_height = kPromotionDetailHeaderHeight - 140; //减去空白高度
    }
    
    self.promotionLink.text = [linkInfo copy];
    
    //适配不通版本高度
    if (floorf([[UIDevice currentDevice].systemVersion floatValue]) > 9.0) {
        self.detailHeightConstraint.constant = 6;
    } else {
        self.detailHeightConstraint.constant = 22;
    }
    
    //回调高度
    if (self.retBlock) {
        self.retBlock(g_height);
    }
}

@end
