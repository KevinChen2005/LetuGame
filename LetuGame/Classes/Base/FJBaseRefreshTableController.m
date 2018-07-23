//
//  FJBaseRefreshTableController.m
//  LetuGame
//
//  Created by admin on 2018/7/18.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJBaseRefreshTableController.h"

@interface FJBaseRefreshTableController ()

@property (nonatomic, strong)NSDate* startDate;
@property (nonatomic, strong)NSDate* endDate;

@end

@implementation FJBaseRefreshTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.startDate = [formatter dateFromString:@"1970-01-01 00:00:00"];
    self.endDate = [NSDate date]; //now
    
    // 集成下拉刷新
    WEAKSELF
    MJRefreshHeader* mjHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        STRONGSELF
        // 进入刷新状态后会自动调用这个block
        [strongSelf loadNewDatas];
    }];
    self.tableView.mj_header = mjHeader;
    
    // 集成上拉加载更多
    MJRefreshFooter* mjFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        STRONGSELF
        // 进入刷新状态后会自动调用这个block
        [strongSelf loadMoreDatas];
    }];
    self.tableView.mj_footer = mjFooter;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //5分钟刷新一次
    self.endDate = [NSDate date];
    if ([CommTool timeIntervalOfTwoData:self.startDate endDate:self.endDate] > 5) {
        [self.tableView.mj_header beginRefreshing];
        self.startDate = self.endDate;
    }
}

- (void)loadNewDatas
{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1.0];
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView.mj_header endRefreshing];
        });
    });
}

- (void)loadMoreDatas
{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1.0];
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView.mj_footer endRefreshing];
        });
    });
}

/**
 *  提示用户刷新状态
 */
- (void)showRefreshStaus:(NSString*)message
{
    if ([message isNullString]) {
        return;
    }
    
    // 1.创建一个UILabel
    UILabel *label = [[UILabel alloc] init];
    
    // 2.显示文字
    label.text = message;
    
    // 3.设置背景
    label.backgroundColor = FJRGBColor(0, 130, 188);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    // 4.设置frame
    label.fj_width = self.view.fj_width;
    label.fj_height = 40;
    label.fj_x = 0;
    label.fj_y = 64 - label.fj_height;
    
    // 5.添加到导航控制器的view
    //    [self.navigationController.view addSubview:label];
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 6.动画
    CGFloat duration = 0.6;
    //    label.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        // 往下移动一个label的高度
        label.transform = CGAffineTransformMakeTranslation(0, label.fj_height);
        //        label.alpha = 1.0;
    } completion:^(BOOL finished) { // 向下移动完毕
        
        // 延迟delay秒后，再执行动画
        CGFloat delay = 1.0;
        
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            // 恢复到原来的位置
            label.transform = CGAffineTransformIdentity;
            //            label.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            // 删除控件
            [label removeFromSuperview];
        }];
    }];
}

@end
