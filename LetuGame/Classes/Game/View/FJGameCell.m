//
//  FJStrategyCell.m
//  LetuGame
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJGameCell.h"
#import "FJGame.h"

@interface FJGameCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelView;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation FJGameCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"FJGameCell" bundle:nil];
}

- (void)setGame:(FJGame *)game
{
    _game = game;
    
    self.titleLabelView.text = game.name;
    NSString* desc = [CommTool safeString:game.desc];
    desc = [desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    while ([desc hasPrefix:@"\r\n"]) {
        desc = [desc substringFromIndex:2];
    }
    
    self.subtitleLabel.text = desc;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:game.icon] placeholderImage:[UIImage imageNamed:@"img_place_holder_icon"]];
}

- (IBAction)clickWantPlay:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(gameCell:clickWantPlayGame:)]) {
        [self.delegate gameCell:self clickWantPlayGame:self.game];
    }
}


@end
