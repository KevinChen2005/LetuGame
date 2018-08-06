//
//  XBSettingCell.m
//  xiu8iOS
//
//  Created by XB on 15/9/18.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "XBSettingCell.h"
#import "XBSettingItemModel.h"
#import "UIView+XBExtension.h"
#import "XBConst.h"

@interface XBSettingCell()

@property (nonatomic,strong) UILabel  *detailLabel;
@property (nonatomic,strong) UILabel  *funcNameLabel;
@property (nonatomic,strong) UISwitch *aswitch;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *indicator;
@property (nonatomic,strong) UIImageView *detailImageView;

@end

@implementation XBSettingCell

- (void)setItem:(XBSettingItemModel *)item
{
    _item = item;
    [self updateUI];
}

- (void)updateUI
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //如果有图片
    if (self.item.img) {
        [self setupImgView];
    }
    
    //功能名称
    if (self.item.funcName) {
        [self setupFuncLabel];
    }

    //accessoryType
    if (self.item.accessoryType) {
        [self setupAccessoryType];
    }
    
    //detailView
    if (self.item.detailText) {
        [self setupDetailText];
    }
    
    if (self.item.detailImage || self.item.detailImageURL) {
        [self setupDetailImage];
    }

    //bottomLine
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, XBScreenWidth, 0.8)];
//    line.backgroundColor = FJGlobalBG;
//    [self.contentView addSubview:line];
}

-(void)setupDetailImage
{
    if (self.item.detailImage) {
        self.detailImageView = [[UIImageView alloc]initWithImage:self.item.detailImage];
    } else if ([self.item.detailImageURL hasPrefix:@"http"]) {
        self.detailImageView = [[UIImageView alloc]init];
        [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:self.item.detailImageURL] placeholderImage:[UIImage imageNamed:@"img_place_holder"]];
    } else {
        self.detailImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.item.detailImageURL]];
    }
    
    self.detailImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:self.detailImageView];
    
    switch (self.item.accessoryType) {
        case XBSettingAccessoryTypeNone:
        {
            NSLog(@"detailImageView.size = %@", NSStringFromCGSize(self.detailImageView.size));
            [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView).offset(-XBDetailViewToIndicatorGap-2);
                make.centerY.mas_equalTo(self.contentView);
            }];
        }
            break;
        case XBSettingAccessoryTypeDisclosureIndicator:
        {
            [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.indicator.mas_left).offset(-XBDetailViewToIndicatorGap);
                make.centerY.mas_equalTo(self.contentView);
            }];
        }
            break;
        case XBSettingAccessoryTypeSwitch:
        {
            [self.detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.aswitch.mas_left).offset(-XBDetailViewToIndicatorGap);
                make.centerY.mas_equalTo(self.contentView);
            }];
        }
            break;
        default:
            break;
    }
    
    self.detailImageView.layer.cornerRadius = self.item.isAvatar ? 28 : 5;
    self.detailImageView.layer.masksToBounds = YES;
    
    //图片过大，将detailImageView调整和到contentView高度
    CGFloat imgW = self.detailImageView.size.width > 10 ? self.detailImageView.size.width : 56;
    CGFloat imgH = self.detailImageView.size.height > 10 ? self.detailImageView.size.height : 56;
    if (imgH > self.contentView.height) {
        CGFloat relH = 56;
        CGFloat relW = (relH * imgW)/imgH;
        [self.detailImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo([NSNumber numberWithFloat:relH]);
            make.width.equalTo([NSNumber numberWithFloat:relW]);
        }];
    } else {
        [self.detailImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo([NSNumber numberWithFloat:imgH]);
            make.width.equalTo([NSNumber numberWithFloat:imgW]);
        }];
    }
}

- (void)setupDetailText
{
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.text = self.item.detailText;
    self.detailLabel.textColor = XBMakeColorWithRGB(142, 142, 142, 1);
    self.detailLabel.font = [UIFont systemFontOfSize:XBDetailLabelFont];
    self.detailLabel.size = [self sizeForTitle:self.item.detailText withFont:self.detailLabel.font];
    
    [self.contentView addSubview:self.detailLabel];
    
    switch (self.item.accessoryType) {
        case XBSettingAccessoryTypeNone:
        {
            [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView).offset(-XBDetailViewToIndicatorGap);
                make.centerY.mas_equalTo(self.contentView);
            }];
        }
            break;
        case XBSettingAccessoryTypeDisclosureIndicator:
        {
            [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.indicator.mas_left).offset(-XBDetailViewToIndicatorGap);
                make.centerY.mas_equalTo(self.contentView);
            }];
        }
            break;
        case XBSettingAccessoryTypeSwitch:
        {
            [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.aswitch.mas_left).offset(-XBDetailViewToIndicatorGap);
                make.centerY.mas_equalTo(self.contentView);
            }];
        }
            break;
        default:
            break;
    }   
}

- (void)setupAccessoryType
{
    switch (self.item.accessoryType) {
        case XBSettingAccessoryTypeNone:
            break;
        case XBSettingAccessoryTypeDisclosureIndicator:
            [self setupIndicator];
            break;
        case XBSettingAccessoryTypeSwitch:
            [self setupSwitch];
            break;
        default:
            break;
    }
}

- (void)setupSwitch
{
    [self.contentView addSubview:self.aswitch];
    [self.aswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-XBIndicatorToRightGap);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (void)setupIndicator
{
    [self.contentView addSubview:self.indicator];
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-XBIndicatorToRightGap);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (void)setupImgView
{
    self.imgView = [[UIImageView alloc]initWithImage:self.item.img];
    [self.contentView addSubview:self.imgView];

    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@XBFuncImgToLeftGap);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (void)setupFuncLabel
{
    self.funcNameLabel = [[UILabel alloc]init];
    self.funcNameLabel.text = self.item.funcName;
    self.funcNameLabel.textColor = XBMakeColorWithRGB(13, 13, 13, 1);
    self.funcNameLabel.font = [UIFont systemFontOfSize:XBFuncLabelFont];
    self.funcNameLabel.size = [self sizeForTitle:self.item.funcName withFont:self.funcNameLabel.font];
    [self.contentView addSubview:self.funcNameLabel];
    
    [self.funcNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.imgView) {
            make.left.mas_equalTo(self.imgView.mas_right).offset(XBFuncLabelToFuncImgGap);
        } else {
            make.left.mas_equalTo(@XBFuncLabelToFuncImgGap);
        }
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font
{
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    
    return CGSizeMake(titleRect.size.width,
                      titleRect.size.height);
}

- (UIImageView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-arrow1"]];
    }
    return _indicator;
}

- (UISwitch *)aswitch
{
    if (!_aswitch) {
        _aswitch = [[UISwitch alloc]init];
        [_aswitch addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
    }
    return _aswitch;
}

- (void)switchTouched:(UISwitch *)sw
{
    __weak typeof(self) weakSelf = self;
    self.item.switchValueChanged(weakSelf.aswitch.isOn);
}

@end
