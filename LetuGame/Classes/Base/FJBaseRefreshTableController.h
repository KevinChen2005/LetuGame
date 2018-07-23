//
//  FJBaseRefreshTableController.h
//  LetuGame
//
//  Created by admin on 2018/7/18.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJBaseTableViewController.h"

@interface FJBaseRefreshTableController : FJBaseTableViewController

/**
 下拉刷新
 */
- (void)loadNewDatas;

/**
 上拉加载更多
 */
- (void)loadMoreDatas;

/**
 *  提示用户刷新状态
 */
- (void)showRefreshStaus:(NSString*)message;

@end
