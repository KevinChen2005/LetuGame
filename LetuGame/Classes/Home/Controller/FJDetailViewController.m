//
//  FJDetailViewController.m
//  LetuGame
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJDetailViewController.h"
#import "FJDetailToolbar.h"
#import "IMYWebView.h"
#import "HZPhotoBrowser.h"
#import "FJWebViewController.h"
#import "FJComment.h"
#import "FJCommentCell.h"
#import "FJOrderViewController.h"
#import "FJSendCommentController.h"
#import "FJNavigationController.h"
#import "FJDetailHeader.h"
#import "FJSectionHeader.h"
#import "FJNews.h"
#import "FJNewsDetail.h"

#define kWorkCount 2 //work总数
#define kType @"news"

@interface FJDetailViewController() <UITableViewDataSource, UITableViewDelegate, FJDetailHeaderDelegate , FJDetailToolbarDelegate>
{
    BOOL bShowComment;
    CGPoint _offset;
    
}

@property(nonatomic, assign)NSInteger loadFlag;//记录加载完成线程的数量
@property(nonatomic, assign)BOOL isFirstEnterPage;

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, copy)NSString *HTMLData;//需要加载的HTML数据
@property(nonatomic, strong)NSMutableArray* datas;

@property(nonatomic, strong)UIView* cover;
@property(nonatomic, strong)FJDetailHeader* header;
@property(nonatomic, strong)FJDetailToolbar* toolbar;
@property(nonatomic, strong)FJNewsDetail* newsDetail;
@property(nonatomic, strong)MJRefreshFooter* mj_footer;

@end

@implementation FJDetailViewController

#pragma mark - 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _loadFlag = 0;
    bShowComment = NO;
    _offset = CGPointZero;
    _isFirstEnterPage = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.datas = [NSMutableArray arrayWithCapacity:20];
    
    [self buildUI];
}

- (void)buildUI
{
    // 右上角“我要玩游戏”
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"我要玩" forState:UIControlStateNormal];
    [button setTitleColor:FJRGBColor(0, 130, 188) forState:UIControlStateNormal];
    [button sizeToFit];
    [button.titleLabel setFont:FJNavbarItemFont];
    [button addTarget:self action:@selector(onClickWantPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 底部工具栏
    FJDetailToolbar *toolbar = [FJDetailToolbar toolBar];
    toolbar.delegate = self;
    [self.view insertSubview:toolbar atIndex:0];
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    self.toolbar = toolbar;

    // 构建tableview
    UITableView* tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableHeaderView = [[UIView alloc] init];
    // tableView 偏移20/64适配
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.sectionHeaderHeight = 15;
    self.tableView.sectionFooterHeight = 1;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@64);
        make.bottom.mas_equalTo(toolbar.mas_top);
    }];
    self.tableView = tableView;
    
    [self.tableView registerNib:[FJCommentCell nib] forCellReuseIdentifier:NSStringFromClass([FJCommentCell class])];
    
    
    // 集成上拉加载更多评论
    WEAKSELF
    MJRefreshFooter* mjFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        STRONGSELF
        // 进入刷新状态后会自动调用这个block
        [strongSelf loadMoreDatas];
    }];
    self.tableView.tableFooterView = mjFooter;
    self.mj_footer = mjFooter;
    self.mj_footer.hidden = YES;
    
    // 加载攻略详情
    [HttpTool fetchNewsDetailWithNewsId:self.news.ID success:^(id retObj) {
        STRONGSELF
        DLog(@"fetchNewsDetail success retObj- %@", retObj);
        NSDictionary* retDict = retObj;
        NSString* code = [NSString stringWithString:retDict[@"code"]];
        NSDictionary* retData = retDict[@"data"];
        if ([code isEqualToString:@"1"]) {
            strongSelf.newsDetail = [FJNewsDetail mj_objectWithKeyValues:retData];
            [strongSelf makeHeaderWithTitle:self.newsDetail.title content:self.newsDetail.content];
            strongSelf.header.likeCount = self.newsDetail.score;
            strongSelf.header.isLiked = self.newsDetail.isLiked;
            strongSelf.toolbar.isCollected = self.newsDetail.isCollected;
        }
    } failure:^(NSError *error) {
        STRONGSELF
        DLog(@"fetchNewsDetail error - %@", error);
        [strongSelf endLoading:YES];
    }];
    
    // 加入遮盖，在数据加载完后移除
//    UIView* cover = [UIView new];
//    cover.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:cover];
//    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    self.cover = cover;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (self.isPushInto) {
//        self.isPushInto = NO;
//        [FJProgressHUB showWithMessage:nil];
//    }
    
    
    // 加载评论数据
    NSInteger start = 0;
    NSInteger end = 20;
    WEAKSELF
    [HttpTool fetchCommentlistWithType:kType kindId:self.news.ID startId:start endId:end Success:^(id retObj) {
        STRONGSELF
        DLog(@"fetchCommentlist success retObj- %@", retObj);
        [strongSelf endLoading:NO];
        
        NSDictionary* retDict = retObj;
        NSString* code = [NSString stringWithString:retDict[@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"][@"comments"];
            NSInteger count = [retDict[@"data"][@"count"] integerValue];//评论总数
            if (arr == nil || [arr isEqual:[NSNull null]] || arr.count <= 0) {
                strongSelf.isFirstEnterPage = NO;
                [strongSelf.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            if (arr.count < 20) {
                [strongSelf.mj_footer endRefreshingWithNoMoreData];
            }
            NSArray* arrTemp = [FJComment mj_objectArrayWithKeyValuesArray:arr];
            [strongSelf.datas removeAllObjects];
            [strongSelf.datas addObjectsFromArray:[[arrTemp reverseObjectEnumerator] allObjects]];
            if (strongSelf.isFirstEnterPage == NO) { //发表评论后进入页面
                [strongSelf.tableView reloadData];
            }
            strongSelf.toolbar.badgeValue = count;
        }
        strongSelf.isFirstEnterPage = NO;
        
    } failure:^(NSError *error) {
        STRONGSELF
        strongSelf.isFirstEnterPage = NO;
        [strongSelf endLoading:YES];
        DLog(@"fetchCommentlist error - %@", error);
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
        [self.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    WEAKSELF
    [HttpTool fetchCommentlistWithType:kType kindId:self.news.ID startId:start endId:end Success:^(id retObj) {
        STRONGSELF
        DLog(@"retObj = %@", retObj);
        
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"][@"comments"];
            if (arr == nil || [arr isEqual:[NSNull null]] || arr.count <= 0) {
//                [FJProgressHUB showInfoWithMessage:@"没有更多数据" withTimeInterval:1.0f];
                [strongSelf.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            NSArray* tempArr = [FJComment mj_objectArrayWithKeyValuesArray:arr];
            [strongSelf.datas addObjectsFromArray:tempArr];
            [strongSelf.tableView reloadData];
            [strongSelf.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        STRONGSELF
        DLog(@"error = %@", error);
        [strongSelf.mj_footer endRefreshing];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endLoading:YES];
}

- (void)endLoading:(BOOL)forceEnd
{
    DLog(@"endLoading");
    self.loadFlag++;
    if (self.loadFlag == kWorkCount || forceEnd) {
        self.loadFlag = 0;
        [FJProgressHUB dismiss];
        [self.cover removeFromSuperview];
        [self.tableView reloadData];
        self.mj_footer.hidden = NO;
        DLog(@"dismiss removeFromSuperview");
    }
}

- (void)makeHeaderWithTitle:(NSString*)title content:(NSString*)content
{
    NSLog(@"makeHeader");
    NSLog(@"title - %@", title);
    NSLog(@"content - %@", content);
    //将标题和内容拼进html页面中
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"NewsHtml" ofType:@"html"];
    NSMutableString *appHtml = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    //标题
    NSString* t = [self.newsDetail.title isEqualToString:@""]?@"--":self.newsDetail.title;
    
    NSString* titleFormat = [NSString stringWithFormat:@"<h2 class = 'thicker'>%@</h2><p class='subtitle'>%@ 发布于 %@</p>", t, self.newsDetail.creatUser, [self.newsDetail.creattime timeFormat]];
    
    //内容
    NSString* c = [content isEqualToString:@""]?@"--":content;
    NSString* contentTemp = c;
    if (![content containsString:@"<p>"]) {
        contentTemp = [NSString stringWithFormat:@"<p>%@</p>", c];
    }
    NSString* strAdd = [NSString stringWithFormat:@"%@ %@", titleFormat, contentTemp];
    [appHtml replaceOccurrencesOfString:@"<p>mainnews</p>" withString:strAdd options:NSCaseInsensitiveSearch range:[appHtml rangeOfString:@"<p>mainnews</p>"]];
    
    // 构建header
    __weak typeof(self) weakSelf = self;
    FJDetailHeader* header = [[FJDetailHeader alloc] initWithLoadHtmlString:appHtml CompleteBlock:^(NSInteger height) {
        weakSelf.header.frame = CGRectMake(0, 0, weakSelf.tableView.bounds.size.width, height);
        weakSelf.tableView.tableHeaderView = weakSelf.header;
        
        [weakSelf endLoading:NO];
        NSLog(@"height = %ld", (long)height);
        
    }];
    header.delegate = self;
    self.header = header;
}

// 点击“我要玩”按钮
- (void)onClickWantPlay:(id)sender
{
    if ([CommTool isLogined] == NO) {
        [CommTool showLoginPageWithNavVC:self.navigationController];
        return;
    }
    
    [CommTool wantPlayGame:self.newsDetail.gameId];
    
//    FJOrderViewController* orderVC = [FJOrderViewController new];
//    [self.navigationController pushViewController:orderVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    FJCommentCell *cell = (FJCommentCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FJCommentCell class])];
//
//    cell.comment = [self.datas objectAtIndex:indexPath.row];
//
//    //这句代码必须要有，也就是说必须要设定contentView的宽度约束。
//    //设置以后，contentView里面的内容才知道什么时候该换行了
//    CGFloat contentViewWidth = CGRectGetWidth(self.tableView.frame);
//    [cell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(contentViewWidth));
//    }];
//
//    //重新加载约束,每次计算之前一定要重新确认一下约束
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
//
//    //自动算高度，+1的原因是因为contentView的高度要比cell的高度小1
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
//
//    return height;
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [FJSectionHeader height];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FJCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FJCommentCell class]) forIndexPath:indexPath];
    cell.comment = self.datas[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [FJSectionHeader headerWithTitle:@"评论"];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = [FJSectionHeader height];
    
    if (scrollView.contentOffset.y <= sectionHeaderHeight &&
        scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    } else {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark - FJDetailToolbarDelegate
- (void)detailToolbarOnClickShowCommentList:(FJDetailToolbar *)toolBar
{
    bShowComment = !bShowComment;
    
    if (bShowComment) {
        if (self.datas.count > 0) {
            CGFloat height = self.tableView.frame.size.height;
            CGFloat contentOffsetY = self.tableView.contentOffset.y;
            CGFloat bottomOffset = self.tableView.contentSize.height - contentOffsetY;
            if (bottomOffset <= height) {//在最底部
                [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
            } else {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        } else {
            [FJProgressHUB showInfoWithMessage:@"暂无评论" withTimeInterval:1.0f];
            bShowComment = !bShowComment;
        }
        
        _offset = self.tableView.contentOffset;
    } else {
        if (CGPointEqualToPoint(_offset, self.tableView.contentOffset)) { //如果滚动前已处在底部，再次点击就回顶部
            [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
        } else {
            [self.tableView setContentOffset:_offset];
        }
    }
}

- (void)detailToolbarOnClickWriteComment:(FJDetailToolbar *)toolBar
{
    if ([CommTool isLogined] == NO) {
        [CommTool showLoginPageWithNavVC:self.navigationController];
        return;
    }
    
    FJSendCommentController* vc = [FJSendCommentController new];
    vc.news = self.news;
    FJNavigationController* navVC = [[FJNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

- (void)detailToolbarOnClickFavorite:(FJDetailToolbar *)toolBar
{
    if ([CommTool isLogined] == NO) {
        [CommTool showLoginPageWithNavVC:self.navigationController];
        return;
    }
    
    if (self.newsDetail.isCollected) { //如果已收藏，取消收藏
        [HttpTool removeCollectionWithType:kType kindId:self.news.ID Success:^(id retObj) {
            DLog(@"remove collection success retObj- %@", retObj);
            NSDictionary* retDict = retObj;
            NSString* code = [NSString stringWithString:retDict[@"code"]];
            NSString* message = [NSString stringWithString:retDict[@"message"]];
            if ([code isEqualToString:@"1"]) {
                self.newsDetail.isCollected = NO;
                toolBar.isCollected = NO;
                [FJProgressHUB showInfoWithMessage:@"收藏已取消" withTimeInterval:1.0f];
            } else {
                [FJProgressHUB showInfoWithMessage:message withTimeInterval:1.0f];
            }
        } failure:^(NSError *error) {
            DLog(@"remove collection failed - %@", error);
        }];
    } else { //如果未收藏，进行收藏
        [HttpTool collectionWithType:kType kindId:self.news.ID Success:^(id retObj) {
            DLog(@"collection success retObj- %@", retObj);
            NSDictionary* retDict = retObj;
            NSString* code = [NSString stringWithString:retDict[@"code"]];
            NSString* message = [NSString stringWithString:retDict[@"message"]];
            if ([code isEqualToString:@"1"]) {
                self.newsDetail.isCollected = YES;
                toolBar.isCollected = YES;
                [FJProgressHUB showInfoWithMessage:@"已收藏" withTimeInterval:1.0f];
            } else if ([code isEqualToString:@"-3"]) { //已收藏
                self.newsDetail.isCollected = YES;
                toolBar.isCollected = YES;
                [FJProgressHUB showInfoWithMessage:@"已收藏" withTimeInterval:1.0f];
            } else {
                [FJProgressHUB showInfoWithMessage:message withTimeInterval:1.0f];
            }
        } failure:^(NSError *error) {
            DLog(@"collection failed - %@", error);
        }];
    }
}

#pragma mark - FJDetailHeaderDelegate
- (void)detailHeader:(FJDetailHeader *)header onClickUrlLink:(NSString *)urlString
{
    FJWebViewController* webVC = [[FJWebViewController alloc] init];
    webVC.urlString = urlString;
    [self.navigationController pushViewController:webVC animated:YES];
}

//点赞
- (void)detailHeader:(FJDetailHeader *)header onClickLikeBtn:(id)obj
{
    if ([CommTool isLogined] == NO) {
        [CommTool showLoginPageWithNavVC:self.navigationController];
        return;
    }
    
    UIButton* likeBtn = obj;
    if (self.newsDetail.isLiked == YES) {
        likeBtn.selected = YES;
        return;
    }
    
    [HttpTool likeWithType:kType kindId:self.news.ID Success:^(id retObj) {
        DLog(@"like success retObj- %@", retObj);
        NSDictionary* retDict = retObj;
        NSString* code = [NSString stringWithString:retDict[@"code"]];
        NSString* message = [NSString stringWithString:retDict[@"message"]];
        if ([code isEqualToString:@"1"]) {
            header.likeCount = header.likeCount + 1;
            header.isLiked = YES;
            self.newsDetail.isLiked = YES;
            [FJProgressHUB showInfoWithMessage:@"已点赞" withTimeInterval:1.0f];
        } else if ([code isEqualToString:@"-3"]) { //已点赞
            header.isLiked = YES;
            self.newsDetail.isLiked = YES;
            [FJProgressHUB showInfoWithMessage:@"已点赞" withTimeInterval:1.0f];
        } else {
            [FJProgressHUB showInfoWithMessage:message withTimeInterval:1.0f];
        }
    } failure:^(NSError *error) {
        DLog(@"like failed - %@", error);
    }];
}


@end
