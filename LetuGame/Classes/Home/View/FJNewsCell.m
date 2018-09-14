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
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation FJNewsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLabelView.font = [UIFont fontWithName:FJFontSiHanMedium size:17];
    self.titleLabelView.textColor = FJBlackTitle;
    self.titleLabelView.textAlignment = NSTextAlignmentJustified;
    
    self.descLabel.font = [UIFont fontWithName:FJFontSiHanRegular size:14];
    self.descLabel.textColor = FJBlackContent;
    self.descLabel.textAlignment = NSTextAlignmentJustified;
    
    self.authorLabel.font = [UIFont fontWithName:FJFontSiHanRegular size:12];
    self.authorLabel.textColor = FJBlackAuthor;
    
    self.timeLabel.font = [UIFont fontWithName:FJFontSiHanRegular size:12];
    self.timeLabel.textColor = FJBlackAuthor;
    
    self.readTimesLabel.font = [UIFont fontWithName:FJFontSiHanRegular size:12];
    self.readTimesLabel.textColor = FJBlackAuthor;
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
    if (author == nil || [author isNullString] || [author isKindOfClass:[NSNull class]] || [author isEqualToString:@"系统"]) {
        author = @"官方";
    }
    self.authorLabel.text = [NSString stringWithFormat:@"%@", author];
    self.readTimesLabel.text = [NSString stringWithFormat:@"已阅%ld", (long)news.readTimes];
    
    self.descLabel.text = news.desc;
    
    if (news.readTimes == 0) {
        self.readTimesLabel.hidden = YES;
        self.readTimesImage.hidden = YES;
    } else {
        self.readTimesLabel.hidden = NO;
        self.readTimesImage.hidden = NO;
    }
   
    [self.titleLabelView setLineSpacing:5.0];
    [self.descLabel setLineSpacing:8.0];

//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:news.imageurl] placeholderImage:[UIImage imageNamed:@"img_place_holder"]];
}

- (void)updateConstraints
{
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
