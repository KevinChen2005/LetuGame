
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
#import "HZPhotoBrowser.h"

#define kDefaultText @"---"
#define kDefaultHeight 800

CGFloat g_height = kDefaultHeight;

@interface HeadLineView() <KNBannerViewDelegate, HZPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIView *bannerHoldView;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (nonatomic, strong)NSMutableArray* bannerArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHoldViewHeightConstraint;

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
    
    self.name.font = [UIFont fontWithName:FJFontSiHanMedium size:19];
    self.name.textColor = FJBlackTitle;
    self.content.font = [UIFont fontWithName:FJFontSiHanRegular size:16];
    self.content.textColor = FJBlackContent;
    
    self.bannerHoldViewHeightConstraint.constant = kBannerHeight;
    g_height = g_height + kBannerHeight;
}

- (IBAction)clickWantPlay:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(headLineView:onClickWantPlay:)]) {
        [self.delegate headLineView:self onClickWantPlay:sender];
    }
}

- (void)setDetail:(FJGameDetail *)detail
{
    _detail = detail;
    
    NSString* iconUrl = nil;
    NSArray* picArr = detail.picArray;
    NSInteger count = picArr.count;
    if (count > 0) {
        self.bannerArray = [NSMutableArray arrayWithCapacity:count];
        //显示icon
        for (int i=0; i<count; i++) {
            FJGamePic* pic = picArr[i];
            if ([[pic typeId] isEqualToString:@"IconPic"]) {
                iconUrl = [pic url];
            } else { //ScreenShot
                [self.bannerArray addObject:pic.url];
            }
        }
        
        if (iconUrl == nil) {
            FJGamePic* pic = picArr[0];
            iconUrl = [pic url];
        }
        [self.icon sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"img_place_holder"]];
        
        //显示banner
        [self buildBanner:self.bannerArray];
    }
    
    self.name.text = detail.gameInfo.gameName;
    self.company.text = detail.gameInfo.company;
    self.date.text = detail.gameInfo.openTime;
    
    self.content.text = detail.gameInfo.desc;
    self.content.textAlignment = NSTextAlignmentJustified;
//    self.content.text = @"height 和 width 属性有一种隐藏的特性，就是人们无需指定图像的实际大小，也就是说，这两个值可以比实际的尺寸大一些或小一些。浏览器会自动调整图像，使其适应这个预留空间的大小。使用这种方法就可以很容易地为大图像创建其缩略图，以及放大很小的图像。但需要注意的是：浏览器还是必须要下载整个文件，不管它最终显示的尺寸到底是多大，而且，如果没有保持其原来的宽度和高度比例，图像会发生扭曲。使用 height 和 width 属性的另外一种技巧，是可以非常容易地实现对页面区域的填充，同时还可以改善文档的性能。设想一下，如果你想在文档中放置一个彩色的横条。您不需要创建一个具有完整尺寸的图像，相反，您只要创建一个宽度和高度都为 1 个像素的图像，并把自己希望使用的颜色赋给它。然后使用 height 和 width 属性把它扩展到更大的尺寸。height 和 width 属性有一种隐藏的特性，就是人们无需指定图像的实际大小，也就是说，这两个值可以比实际的尺寸大一些或小一些。浏览器会自动调整图像，使其适应这个预留空间的大小。使用这种方法就可以很容易地为大图像创建其缩略图，以及放大很小的图像。但需要注意的是：浏览器还是必须要下载整个文件，不管它最终显示的尺寸到底是多大，而且，如果没有保持其原来的宽度和高度比例，图像会发生扭曲。使用 height 和 width 属性的另外一种技巧，是可以非常容易地实现对页面区域的填充，同时还可以改善文档的性能。设想一下，如果你想在文档中放置一个彩色的横条。您不需要创建一个具有完整尺寸的图像，相反，您只要创建一个宽度和高度都为 1 个像素的图像，并把自己希望使用的颜色赋给它。然后使用 height 和 width 属性把它扩展到更大的尺寸。";
    [self.content setLineSpacing:10.0];
    NSLog(@"content.width = %f", self.content.fj_width);
    CGSize size = [self.content sizeWhenFillText];
    CGFloat contentHeight = size.height;
    
    CGFloat otherCtrlHeight = 700 + 100; //其他控件加间距高度，由xib计算获得
    g_height = otherCtrlHeight + contentHeight;
    NSLog(@"g_height = %f", g_height);
    
}

- (void)buildBanner:(NSArray*)imageArray
{
    self.bannerHoldView.backgroundColor = [UIColor whiteColor];
    
    KNBannerView* bannerView = [KNBannerView bannerViewWithNetWorkImagesArr:[imageArray copy] frame:self.bannerHoldView.frame];
    
    KNBannerViewModel *viewM = [[KNBannerViewModel alloc] init];
    [viewM setIsNeedPageControl:YES]; // 默认系统PageControl
    [viewM setPageControlStyle:KNBannerPageControlStyleNone]; // 设置pageControl隐藏
    
    [viewM setIsNeedTimerRun:YES]; // 是否需要定时
    [viewM setBannerTimeInterval:8]; // 改变 定时器时间
    [viewM setBannerCornerRadius:8]; // 切个圆角
    [viewM setIsNeedCycle:YES]; //循环轮播
    [viewM setLeftMargin:10]; // 设置个边距
    [viewM setPlaceHolder:[UIImage imageNamed:@"img_place_holder"]];
    NSLog(@"bannerHoldView = %@", self.bannerHoldView);
    [bannerView setBannerViewModel:viewM]; // 通过模型设置属性 -->赋值
    bannerView.delegate = self;
    
    [self addSubview:bannerView];
}

- (void)bannerView:(KNBannerView *)bannerView collectionView:(UICollectionView *)collectionView collectionViewCell:(KNBannerCollectionViewCell *)collectionViewCell didSelectItemAtIndexPath:(NSInteger)index
{
    if (self.bannerArray == nil || self.bannerArray.count <= 0) {
        return;
    }
    
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.imageCount = self.bannerArray.count; // 图片总数
    browserVc.currentImageIndex = index;//当前点击的图片
    browserVc.delegate = self;
    [browserVc show];
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //图片浏览时，未加载出图片的占位图
    return nil;//[UIImage imageNamed:@"img_place_holder2"];
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.bannerArray[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

@end
