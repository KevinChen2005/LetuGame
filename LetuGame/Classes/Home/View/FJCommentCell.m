//
//  FJCommentCell.m
//  LetuGame
//
//  Created by admin on 2018/7/11.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJCommentCell.h"
#import "FJComment.h"

@interface FJCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation FJCommentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    // 禁止点击
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.username.textColor = FJBlackTitle;
    self.content.textColor = FJBlackContent;
    self.time.textColor = FJBlackAuthor;
    
    [self.content setLineSpacing:8.0];
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"FJCommentCell" bundle:nil];
}

- (void)setComment:(FJComment *)comment
{
    _comment = comment;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:comment.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.username.text = comment.nickName;
    self.content.text = comment.content;
    self.time.text = comment.createtime;
}

@end
