
//
//  HeadLineView.m
//  京师杏林
//
//  Created by sjt on 15/11/12.
//  Copyright © 2015年 MaNingbo. All rights reserved.
//

#import "HeadLineView.h"
#import "KNBannerView.h"
#import "KNBannerViewModel.h"
#import "FJGameDetail.h"

#define kDefaultText @"---"
#define kDefaultHeight 670

CGFloat g_height = kDefaultHeight;

@interface HeadLineView()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIView *bannerHoldView;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation HeadLineView

+ (instancetype)headLineView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"HeadLineView" owner:nil options:nil] firstObject];
}

+ (CGFloat)height
{
    return g_height;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    g_height = kDefaultHeight;
    
    self.name.text = @"xxx";
    self.content.text = kDefaultText;
    self.company.text = kDefaultText;
    self.date.text = kDefaultText;
}

- (void)setDetail:(FJGameDetail *)detail
{
    _detail = detail;
    
    NSString* iconUrl = nil;
    NSArray* picArr = detail.picArray;
    NSInteger count = picArr.count;
    if (count > 0) {
        NSMutableArray* bannerArray = [NSMutableArray arrayWithCapacity:count];
        //显示icon
        for (int i=0; i<count; i++) {
            FJGamePic* pic = picArr[i];
            if ([[pic typeId] isEqualToString:@"IconPic"]) {
                iconUrl = [pic url];
            } else { //ScreenShot
                [bannerArray addObject:pic.url];
            }
        }
        if (iconUrl == nil) {
            FJGamePic* pic = picArr[0];
            iconUrl = [pic url];
        }
        [self.icon sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"img_place_holder"]];
        
        //显示banner
        [self buildBanner:bannerArray];
    }
    
    self.name.text = detail.gameInfo.gameName;
    self.company.text = detail.gameInfo.company;
    self.date.text = detail.gameInfo.openTime;
    
    self.content.text = detail.gameInfo.desc;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:self.content.font forKey:NSFontAttributeName];
    CGSize size = [self.content.text boundingRectWithSize:CGSizeMake(self.content.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    [self.content mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([NSNumber numberWithFloat:size.height]);
    }];
    
    g_height = 470 + size.height;
    NSLog(@"g_height = %f", g_height);
    g_height = g_height < 650 ? 650 : g_height;
    
}

- (void)buildBanner:(NSArray*)imageArray
{
    self.bannerHoldView.backgroundColor = [UIColor whiteColor];
    
    KNBannerView* bannerView = [KNBannerView bannerViewWithNetWorkImagesArr:[imageArray copy] frame:self.bannerHoldView.frame];
    
    KNBannerViewModel *viewM = [[KNBannerViewModel alloc] init];
    [viewM setIsNeedPageControl:YES]; // 默认系统PageControl
    [viewM setPageControlStyle:KNBannerPageControlStyleNone]; // 设置pageControl隐藏
    
    [viewM setIsNeedTimerRun:NO]; // 是否需要定时
    [viewM setBannerTimeInterval:1]; // 改变 定时器时间
    [viewM setBannerCornerRadius:8]; // 切个圆角
    [viewM setLeftMargin:10]; // 设置个边距
    [viewM setPlaceHolder:[UIImage imageNamed:@"img_place_holder"]];
    NSLog(@"bannerHoldView = %@", self.bannerHoldView);
    [bannerView setBannerViewModel:viewM]; // 通过模型设置属性 -->赋值
    
    [self addSubview:bannerView];
}

@end
