//
//  FJGameViewController.m
//  LetuGame
//
//  Created by admin on 2018/7/11.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJGameViewController.h"
#import "SDCycleScrollView.h"
#import "FJGameDetailController.h"
#import "FJGameCell.h"
#import "FJGame.h"
#import "FJBanner.h"

@interface FJGameViewController () <SDCycleScrollViewDelegate, FJGameCellDelegate>

@property (nonatomic, strong)SDCycleScrollView* banner;
@property (nonatomic, strong)NSMutableArray* bannerArray;

@end

@implementation FJGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"游戏中心";
    self.bannerArray = [NSMutableArray array];
    
    self.tableView.sectionHeaderHeight = 1;
    self.tableView.sectionFooterHeight = 1;
    self.tableView.estimatedRowHeight = 70;
    // 注册tableView的cell
    [self.tableView registerNib:[FJGameCell nib] forCellReuseIdentifier:NSStringFromClass([FJGameCell class])];
    
    // 集成图片滚动轮播器
    SDCycleScrollView *banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kBannerHeight) delegate:self placeholderImage:nil];
    banner.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    banner.autoScrollTimeInterval = 5.0f;
    banner.placeholderImage = [UIImage imageNamed:@"img_place_holder"];
    self.tableView.tableHeaderView = banner;
    self.banner = banner;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.mj_header.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.mj_header.hidden = YES;
}

- (void)gotoDetailVC:(FJGame*)game
{
    // 跳转到游戏详情页面
    FJGameDetailController* detailVC = [FJGameDetailController new];
    detailVC.game = game;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)loadNewDatas
{
    NSInteger start = 0;
    NSInteger end = 20;
    
    WEAKSELF
    [HttpTool fetchGamelistWithStartId:start endId:end Success:^(id retObj) {
        STRONGSELF
        [strongSelf.tableView.mj_header endRefreshing];
        
        DLog(@"retObj = %@", retObj)
        if (retObj && [retObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary* retDict = retObj;
            NSString* code = retDict[@"code"];
            NSString* message = retDict[@"message"];
            if ([code isEqualToString:@"1"]) { //请求成功
                NSArray* arr = retDict[@"data"][@"games"];
                if (arr == nil || [arr isEqual:[NSNull null]] || arr.count<=0) {
//                    [strongSelf showRefreshStaus:@"没有新数据"];
//                    [FJProgressHUB showInfoWithMessage:@"没有新数据" withTimeInterval:kTimeHubError];
                    return ;
                }
                [strongSelf.datas removeAllObjects];
                NSArray* arrTemp = [FJGame mj_objectArrayWithKeyValuesArray:arr];
                [strongSelf.datas addObjectsFromArray:arrTemp];
                [strongSelf.tableView reloadData];
                [strongSelf.tableView.mj_footer endRefreshing];//改变上拉刷新状态为可上拉状态
            } else {
                NSString* msg = [NSString stringWithFormat:@"获取游戏列表失败，%@", message];
                [FJProgressHUB showErrorWithMessage:msg withTimeInterval:kTimeHubError];
//                [self showRefreshStaus:msg];
            }
        } else {
//            [self showRefreshStaus:@"刷新失败，返回数据错误"];
//            [FJProgressHUB showErrorWithMessage:@"刷新失败，返回数据错误" withTimeInterval:kTimeHubError];
        }
    } failure:^(NSError *error) {
        DLog(@"fetchGamelistFailure = %@", error)
        [self.tableView.mj_header endRefreshing];
//        [self showRefreshStaus:@"刷新失败，请检查网络"];
//        [FJProgressHUB showErrorWithMessage:@"刷新失败，请检查网络" withTimeInterval:kTimeHubError];
    }];
    
    
    // 请求banner数据
    [HttpTool fetchBannerWithType:@"game" Success:^(id retObj) {
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
    [HttpTool fetchGamelistWithStartId:start endId:end Success:^(id retObj) {
        DLog(@"retObj = %@", retObj);
        
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"][@"games"];
            if (arr == nil || [arr isEqual:[NSNull null]] || arr.count <= 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                [FJProgressHUB showInfoWithMessage:@"没有更多数据" withTimeInterval:1.0f];
                return;
            }
            [self.tableView.mj_footer endRefreshing];
            NSArray* tempArr = [FJGame mj_objectArrayWithKeyValuesArray:arr];
            [self.datas addObjectsFromArray:tempArr];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        DLog(@"error = %@", error);
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FJGameCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FJGameCell class]) forIndexPath:indexPath];
    
    FJGame* ss = self.datas[indexPath.row];
    cell.game = ss;
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [self gotoDetailVC:self.datas[indexPath.row]];
}

#pragma mark - SDCycleScrollViewDelegate
//点击了banner中的图片
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    FJBanner* banner = [self.bannerArray objectAtIndex:index];
    FJGame* game = [FJGame new];
    game.gameId = banner.ID;
    [self gotoDetailVC:game];
}

#pragma mark - FJGameCellDelegate
- (void)gameCell:(FJGameCell *)gameCell clickWantPlayGame:(FJGame *)game
{
    if ([CommTool isLogined] == NO) {
        [CommTool showLoginPageWithNavVC:self.navigationController];
        return;
    }
    
    [CommTool wantPlayGame:game.gameId];
}


@end
