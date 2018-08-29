//
//  FJTabBar.h
//  LetuGame
//
//  Created by  admin on 18/5/4.
//  Copyright © 2018年  admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FJTabBarDelegate;

@interface FJTabBar : UITabBar

@property(nonatomic, weak) id<FJTabBarDelegate> delegate;

@end

@protocol FJTabBarDelegate <NSObject>

- (void)fj_tabBar:(FJTabBar*)tabBar didSelectedItemIndex:(NSInteger)index;

@end
