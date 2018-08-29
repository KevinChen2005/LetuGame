//
//  FJPromotionCell.m
//  LetuGame
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJPromotionCell.h"
#import "FJPromotion.h"

@interface FJPromotionCell()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *registerion;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *code;

@end

@implementation FJPromotionCell

+ (instancetype)cell
{
    return [[[NSBundle mainBundle]loadNibNamed:@"FJPromotionCell" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setPromotion:(FJPromotion *)promotion
{
    _promotion = promotion;
    
    self.name.text = _promotion.gameName;
    self.registerion.text = [NSString stringWithFormat:@"%ld", (long)_promotion.registNum];
    self.money.text = [NSString stringWithFormat:@"%0.2f", _promotion.agentMoney];
    self.code.text = _promotion.code;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
