//
//  FJNewsTitleView.m
//  LetuGame
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJNewsTitleView.h"
#import "FJNewsDetail.h"

#define kMargin 20

@interface FJNewsTitleView()
{
    CGFloat _height;
}

@property (weak, nonatomic) IBOutlet UILabel *title;      //标题
@property (weak, nonatomic) IBOutlet UILabel *author;     //作者
@property (weak, nonatomic) IBOutlet UILabel *readTimes;  //阅读量
@property (weak, nonatomic) IBOutlet UILabel *createDate; //发表时间
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;  //左间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin; //右间距

@end

@implementation FJNewsTitleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _height = 120;
    self.title.textAlignment = NSTextAlignmentJustified;
    
    // ipad适配左右间距
    if (isIpad) {
        self.leftMargin.constant  = self.fj_width * 0.07;
        self.rightMargin.constant = self.fj_width * 0.07;
    }
}

+ (instancetype)titleView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"FJNewsTitleView" owner:nil options:nil] firstObject];
}

- (void)setNewsDetail:(FJNewsDetail *)newsDetail
{
    if (newsDetail == nil) {
        return;
    }
    _newsDetail = newsDetail;
    
    self.title.text = self.newsDetail.title;
    NSString* author = self.newsDetail.creatUser;
    if (author == nil || [author isNullString] || [author isKindOfClass:[NSNull class]] || [author isEqualToString:@"系统"]) {
        author = @"官方";
    }
    self.author.text = author;
    self.readTimes.text = [NSString stringWithFormat:@"已阅%ld", (long)self.newsDetail.readTimes];
    self.createDate.text = [self.newsDetail.creattime timeFormat];
    
    [self.title setLineSpacing:5.0];
    
    NSLog(@"%f", self.title.fj_width);
    CGSize size = [self.title sizeWhenFillTextWidth:kScreenWidth - 40];
    CGFloat titleHeight = size.height;
    CGFloat authorHeight = 20;
    
    _height = kMargin*3 + titleHeight + authorHeight;
}

- (CGFloat)height
{
    return _height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

@end
