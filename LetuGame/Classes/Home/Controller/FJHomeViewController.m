//
//  FJHomeViewController.m
//  LetuGame
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJHomeViewController.h"
#import "SDCycleScrollView.h"

@interface FJHomeViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, strong)SDCycleScrollView* banner;

@end

@implementation FJHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 集成图片滚动轮播器
    SDCycleScrollView *banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 160) delegate:self placeholderImage:nil];
    banner.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    banner.autoScrollTimeInterval = 5.0f;
    banner.placeholderImage = [UIImage imageNamed:@"img_place_holder"];
    self.tableView.tableHeaderView = banner;
    self.banner = banner;
    
}

// 重写父类
- (void)loadNewDatas
{
    NSInteger start = 0;
    NSInteger end = 20;
    [HttpTool fetchNewslistWithStartId:start endId:end Success:^(id retObj) {
        DLog(@"retObj = %@", retObj);
        [self.tableView.mj_header endRefreshing];
        
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"][@"newsList"];
            if (arr == nil || [arr isEqual:[NSNull null]] || arr.count <= 0) {
                [self showRefreshStaus:@"没有新数据"];
                return;
            }
            [self.datas removeAllObjects];
            NSArray* tempArr = [FJNews mj_objectArrayWithKeyValuesArray:arr];
            [self.datas addObjectsFromArray:tempArr];
            
            [self.tableView reloadData];
        } else {
            [self showRefreshStaus:@"获取数据失败"];
        }
    } failure:^(NSError *error) {
        DLog(@"error = %@", error);
        [self.tableView.mj_header endRefreshing];
        [self showRefreshStaus:@"刷新失败，请检查网络"];
    }];
    
    
    // 请求banner数据
    [HttpTool fetchBannerWithType:@"news" Success:^(id retObj) {
        DLog(@"fetchBanner retObj = %@", retObj);
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            
            NSArray* arr = retDict[@"data"];
            self.banner.imageURLStringsGroup = arr;
        }
    } failure:^(NSError *error) {
        DLog(@"fetchBanner error = %@", error);
    }];
}

- (void)loadMoreDatas
{
    static NSInteger start = 0;
    start = self.datas.count;
    NSInteger count = 20;
    NSInteger end = start + count;
    
    if (self.datas.count < 20) {//没有更多数据
//        [FJProgressHUB showInfoWithMessage:@"没有更多数据" withTimeInterval:1.0f];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [HttpTool fetchNewslistWithStartId:start endId:end Success:^(id retObj) {
        DLog(@"retObj = %@", retObj);
        
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"][@"newsList"];
            if (arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                [FJProgressHUB showInfoWithMessage:@"没有更多数据" withTimeInterval:1.0f];
                return;
            }
            [self.tableView.mj_footer endRefreshing];
            NSArray* tempArr = [FJNews mj_objectArrayWithKeyValuesArray:arr];
            [self.datas addObjectsFromArray:tempArr];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        DLog(@"error = %@", error);
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - SDCycleScrollViewDelegate
//点击了banner中的图片
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    [self gotoDetailVC:[self.datas objectAtIndex:index]];
}

@end


