//
//  FJGameToolbar.h
//  LetuGame
//
//  Created by admin on 2018/7/13.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FJGameToolbarDelegate;

@interface FJGameToolbar : UIView

@property(nonatomic, weak) id<FJGameToolbarDelegate> delegate;

+ (instancetype)toolbar;
+ (CGFloat)height;

@end

@protocol FJGameToolbarDelegate <NSObject>

- (void)gameToolbarOnClickShowStrategyList:(FJGameToolbar*)toolbar;
- (void)gameToolbarOnClickWriteStrategy:(FJGameToolbar*)toolbar;

@end
