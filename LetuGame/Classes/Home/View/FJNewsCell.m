//
//  FJStrategyCell.m
//  LetuGame
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJNewsCell.h"
#import "FJNews.h"

@interface FJNewsCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation FJNewsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"FJNewsCell" bundle:nil];
}

- (void)setNews:(FJNews*)news
{
    _news = news;
    
    self.titleLabelView.text = news.title;
    self.timeLabel.text = [news.creattime timeFormat];
    NSString* author = news.creatUser;
    if (author == nil || [author isNullString] || [author isKindOfClass:[NSNull class]]) {
        author = @"未知";
    }
    self.authorLabel.text = [NSString stringWithFormat:@"%@", author];
    
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:news.imageurl] placeholderImage:[UIImage imageNamed:@"img_place_holder"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
