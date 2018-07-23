//
//  FJOrderGameCell.m
//  LetuGame
//
//  Created by admin on 2018/7/18.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJOrderGameCell.h"

#import "FJOrderGame.h"

@interface FJOrderGameCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleView;

@end

@implementation FJOrderGameCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"FJOrderGameCell" bundle:nil];
}

- (void)setGame:(FJOrderGame *)game
{
    _game = game;
    
    self.titleView.text = game.gameName;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:game.icon] placeholderImage:[UIImage imageNamed:@"img_place_holder"]];
}

@end
