//
//  FJCommentCell.h
//  LetuGame
//
//  Created by admin on 2018/7/11.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJComment;

@interface FJCommentCell : UITableViewCell

@property (nonatomic, strong) FJComment* comment;

+ (UINib*)nib;

@end
