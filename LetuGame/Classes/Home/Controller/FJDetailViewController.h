//
//  FJDetailViewController.h
//  LetuGame
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 com.langlun. All rights reserved.
//  游戏攻略详情页

@class FJNews;

#import "FJBaseViewController.h"

@interface FJDetailViewController : FJBaseViewController

@property (nonatomic, strong)FJNews* news;
@property (nonatomic, assign)BOOL isPushInto; //该页面是否被push进来

@end
