//
//  FJPromotionDetailCell.m
//  LetuGame
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJPromotionDetailCell.h"
#import "FJPromotionDetailModel.h"

#define kCellName    @"FJPromotionDetailCell"
#define kCellHeight  40;

@interface FJPromotionDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UILabel *userid;

@end

@implementation FJPromotionDetailCell

+ (instancetype)cell
{
    return [[[NSBundle mainBundle]loadNibNamed:kCellName owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:kCellName bundle:nil];
}

+ (NSString *)reuseId
{
    return kCellName;
}

+ (CGFloat)height
{
    return kCellHeight;
}

- (void)setPromotionDetail:(FJPromotionDetailModel *)promotionDetail
{
    _promotionDetail = promotionDetail;
    
    self.userid.text = promotionDetail.channelUserName;
    self.money.text = [NSString stringWithFormat:@"%0.2f", promotionDetail.payMoney];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
