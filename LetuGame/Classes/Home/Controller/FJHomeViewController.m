//
//  FJHomeViewController.m
//  LetuGame
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJHomeViewController.h"
#import "SDCycleScrollView.h"
#import "FJBanner.h"

@interface FJHomeViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, strong)SDCycleScrollView* banner;
@property (nonatomic, strong)NSMutableArray* bannerArray;

@end

@implementation FJHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bannerArray = [NSMutableArray array];
    
    // 集成图片滚动轮播器
    SDCycleScrollView *banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kBannerHeight) delegate:self placeholderImage:nil];
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
    
    WEAKSELF
    [HttpTool fetchNewslistWithStartId:start endId:end Success:^(id retObj) {
        STRONGSELF
        DLog(@"retObj = %@", retObj);
        [strongSelf.tableView.mj_header endRefreshing];
        
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"][@"newsList"];
            if (arr == nil || [arr isEqual:[NSNull null]] || arr.count <= 0) {
//                [strongSelf showRefreshStaus:@"没有新数据"];
//                [FJProgressHUB showInfoWithMessage:@"没有新数据" withTimeInterval:kTimeHubError];
                return;
            }
            [strongSelf.datas removeAllObjects];
            NSArray* tempArr = [FJNews mj_objectArrayWithKeyValuesArray:arr];
            [strongSelf.datas addObjectsFromArray:tempArr];
            
            [strongSelf.tableView reloadData];
            [strongSelf.tableView.mj_footer endRefreshing];//改变上拉刷新状态为可上拉状态
        } else {
//            [strongSelf showRefreshStaus:@"获取数据失败"];
//            [FJProgressHUB showErrorWithMessage:@"获取数据失败" withTimeInterval:kTimeHubError];
        }
    } failure:^(NSError *error) {
        STRONGSELF
        DLog(@"error = %@", error);
        [strongSelf.tableView.mj_header endRefreshing];
//        [strongSelf showRefreshStaus:@"刷新失败，请检查网络"];
//        [FJProgressHUB showErrorWithMessage:@"刷新失败，请检查网络" withTimeInterval:kTimeHubError];
    }];
    
    
    // 请求banner数据
    [HttpTool fetchBannerWithType:@"news" Success:^(id retObj) {
        STRONGSELF
        DLog(@"fetchBanner retObj = %@", retObj);
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            
            NSArray* arr = retDict[@"data"];
            NSArray* arrTemp = [FJBanner mj_objectArrayWithKeyValuesArray:arr];
            if (arrTemp==nil || arrTemp.count<=0) {
                return;
            }
            [strongSelf.bannerArray addObjectsFromArray:arrTemp];
            NSMutableArray* arrImgUrl = [NSMutableArray array];
            [arrTemp enumerateObjectsUsingBlock:^(FJBanner*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrImgUrl addObject:obj.image];
            }];
            
            strongSelf.banner.imageURLStringsGroup = [arrImgUrl copy];
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
    
    if (self.datas.count < count) {//没有更多数据
//        [FJProgressHUB showInfoWithMessage:@"没有更多数据" withTimeInterval:1.0f];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    WEAKSELF
    [HttpTool fetchNewslistWithStartId:start endId:end Success:^(id retObj) {
        STRONGSELF
        DLog(@"retObj = %@", retObj);
        
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"][@"newsList"];
            if (arr.count <= 0) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//                [FJProgressHUB showInfoWithMessage:@"没有更多数据" withTimeInterval:1.0f];
                return;
            }
            [strongSelf.tableView.mj_footer endRefreshing];
            NSArray* tempArr = [FJNews mj_objectArrayWithKeyValuesArray:arr];
            [strongSelf.datas addObjectsFromArray:tempArr];
            [strongSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        STRONGSELF
        DLog(@"error = %@", error);
        [strongSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - SDCycleScrollViewDelegate
//点击了banner中的图片
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    FJBanner* banner = [self.bannerArray objectAtIndex:index];
    FJNews* news = [FJNews new];
    news.ID = banner.ID;
    [self gotoDetailVC:news];
}

@end


