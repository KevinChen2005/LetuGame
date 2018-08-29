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
{
    BOOL _longPressState;
}

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleView;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (strong, nonatomic)UIAlertController *alertController;

@end

@implementation FJOrderGameCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius = 10;
    self.contentView.layer.cornerRadius = 10;
    
    // 添加长按手势
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction)];
    [self addGestureRecognizer:longPressGesture];
    
    _longPressState = NO;
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"FJOrderGameCell" bundle:nil];
}

- (void)setGame:(FJOrderGame *)game
{
    _game = game;
    
    self.deleteBtn.hidden = !game.isEdit;
    self.titleView.text = game.gameName;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:game.icon] placeholderImage:[UIImage imageNamed:@"img_place_holder_icon"]];
    
    _longPressState = game.isEdit;
    
    //动画
    if (game.isEdit == YES) { //可删除
        [UIView animateWithDuration:0.13 delay:0 options:0  animations:^{
             //顺时针旋转0.05 = 0.05 * 180 = 9°
             self.transform=CGAffineTransformMakeRotation(-0.05);
         } completion:^(BOOL finished) {
             //  重复                                  反向            动画时接收交互
             /**
              UIViewAnimationOptionAllowUserInteraction      //动画过程中可交互
              UIViewAnimationOptionBeginFromCurrentState     //从当前值开始动画
              UIViewAnimationOptionRepeat                    //动画重复执行
              UIViewAnimationOptionAutoreverse               //来回运行动画
              UIViewAnimationOptionOverrideInheritedDuration //忽略嵌套的持续时间
              UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
              UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
              UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
              UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
              */
             [UIView animateWithDuration:0.13 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^{
                  self.transform=CGAffineTransformMakeRotation(0.05);
              } completion:^(BOOL finished) {}];
         }];
    } else { //不可删除
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
             self.transform=CGAffineTransformIdentity;
         } completion:^(BOOL finished) {}];
    }
}

- (IBAction)onClickDelete:(id)sender
{
    UIViewController* rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:self.alertController animated:YES completion:nil];
}

- (UIAlertController *)alertController
{
    if (_alertController == nil) {
        _alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定要删除游戏《%@》吗？", _game.gameName] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [_alertController addAction:cancelAction];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self confirmDelete];
        }];
        [_alertController addAction:confirmAction];
    }
    return _alertController;
}

- (void)confirmDelete
{
    if ([self.delegate respondsToSelector:@selector(orderGameCellOnDeleteAction:)]) {
        [self.delegate orderGameCellOnDeleteAction:self];
    }
}

- (void)longPressAction
{
    if (_longPressState) {
        return;
    }
    _longPressState = YES;
    
    if ([self.delegate respondsToSelector:@selector(orderGameCellOnLongPressAction:)]) {
        [self.delegate orderGameCellOnLongPressAction:self];
    }
}

@end
