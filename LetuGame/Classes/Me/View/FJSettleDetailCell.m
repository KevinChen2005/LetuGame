//
//  FJSettleDetailCell.m
//  LetuGame
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJSettleDetailCell.h"
#import "FJSettleDetailModel.h"

#define kCellName    @"FJSettleDetailCell"
#define kCellHeight  40;

@interface FJSettleDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *week;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *isSettle;

@end

@implementation FJSettleDetailCell

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

- (void)setSettle:(FJSettleDetailModel *)settle
{
    _settle = settle;
    
    self.week.text = settle.week;
    self.money.text = [NSString stringWithFormat:@"%0.2f", settle.agentMoney];
    self.isSettle.text = settle.isPay?@"是":@"否";
}

@end
