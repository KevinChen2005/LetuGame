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
@property (weak, nonatomic) IBOutlet UILabel *readTimesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *readTimesImage;

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
        author = @"官方";
    }
    self.authorLabel.text = [NSString stringWithFormat:@"%@", author];
    self.readTimesLabel.text = [NSString stringWithFormat:@"%d", news.readTimes];
    
    if (news.readTimes == 0) {
        self.readTimesLabel.hidden = YES;
        self.readTimesImage.hidden = YES;
    } else {
        self.readTimesLabel.hidden = NO;
        self.readTimesImage.hidden = NO;
    }
    
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:news.imageurl] placeholderImage:[UIImage imageNamed:@"img_place_holder"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
