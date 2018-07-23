//
//  FJBaseNewsController.h
//  LetuGame
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJBaseRefreshTableController.h"
#import "FJNews.h"

@interface FJBaseNewsController : FJBaseRefreshTableController

@property (nonnull, nonatomic, strong) NSMutableArray* datas;

/**
 跳转到详情控制器
 */
- (void)gotoDetailVC:(FJNews*)news;

@end
