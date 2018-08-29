//
//  FJOrderGameController.m
//  LetuGame
//
//  Created by admin on 2018/7/18.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJOrderGameController.h"
#import "FJOrderGame.h"
#import "FJOrderGameCell.h"
#import "FJGame.h"
#import "FJGameDetailController.h"

@interface FJOrderGameController ()<FJOrderGameCellDelegate>
{
    BOOL _isEditModel;
}

@property (nonatomic, strong)NSMutableArray* datas;
@property (nonatomic, strong)MJRefreshHeader* mjHeaderView;

@property (nonatomic, strong)NSDate* startDate;
@property (nonatomic, strong)NSDate* endDate;

@property (nonatomic, strong)UIButton* editButton;

@end

@implementation FJOrderGameController

static NSString * const reuseIdentifier = @"Cell";

+ (instancetype)create
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat w = (kScreenWidth - 20*2 - 20*2)/3;
    flowLayout.itemSize = CGSizeMake(w, w);
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    flowLayout.itemSize = CGSizeMake(w, w+25);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    return [[FJOrderGameController alloc] initWithCollectionViewLayout:flowLayout];
}

- (void)dealloc
{
    DLog(@"---dealloc---");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的游戏";
    _isEditModel = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES; //数据少的时候也可以滚动
    [self.collectionView registerNib:[FJOrderGameCell nib] forCellWithReuseIdentifier:reuseIdentifier];
    self.datas = [NSMutableArray array];
    
    // tableView 偏移20/64适配
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.collectionView.contentInset = UIEdgeInsetsMake(iphoneX? 88 : 64, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    
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
    self.collectionView.mj_header = mjHeader;
    self.mjHeaderView = mjHeader;
    
    // 右上角“编辑”
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateSelected];
    [button setTitleColor:FJRGBColor(0, 130, 188) forState:UIControlStateNormal];
    [button sizeToFit];
    [button.titleLabel setFont:FJNavbarItemFont];
    [button addTarget:self action:@selector(onClickEdit:) forControlEvents:UIControlEventTouchUpInside];
    self.editButton = button;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)loadNewDatas
{
    WEAKSELF
    [HttpTool fetchMyGameListSuccess:^(id retObj) {
        STRONGSELF
        DLog(@"retObj = %@", retObj);
        [strongSelf.collectionView.mj_header endRefreshing];
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"];
            if (arr == nil || [arr isEqual:[NSNull null]] || arr.count <= 0) {
                [FJProgressHUB showInfoWithMessage:@"暂无数据！" withTimeInterval:1.5f];
                return ;
            }
            [strongSelf.datas removeAllObjects];
            NSArray* tempArr = [FJOrderGame mj_objectArrayWithKeyValuesArray:arr];
            [strongSelf.datas addObjectsFromArray:tempArr];
            
            [strongSelf.collectionView reloadData];
        } else {
//            [strongSelf showRefreshStaus:@"刷新失败"];
//            [FJProgressHUB showErrorWithMessage:@"刷新失败" withTimeInterval:kTimeHubError];
        }
    } failure:^(NSError *error) {
        STRONGSELF
        DLog(@"fetchMyGameList error - %@", error);
        [strongSelf.collectionView.mj_header endRefreshing];
//        [strongSelf showRefreshStaus:@"刷新失败，请检查网络"];
//        [FJProgressHUB showErrorWithMessage:@"刷新失败，请检查网络" withTimeInterval:kTimeHubError];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //5分钟刷新一次
    self.endDate = [NSDate date];
    if ([CommTool timeIntervalOfTwoData:self.startDate endDate:self.endDate] > 5) {
        [self.collectionView.mj_header beginRefreshing];
        self.startDate = self.endDate;
    }
}

- (void)onClickEdit:(UIButton*)btn
{
    btn.selected = !btn.selected;
    
    BOOL isEdit = btn.selected;
    _isEditModel = isEdit;
    
    [self changeState:isEdit];
}

- (void)changeState:(BOOL)isEdit
{
    if (isEdit) { //编辑模式去掉下拉刷新
        self.collectionView.mj_header = nil;
    } else {
        self.collectionView.mj_header = self.mjHeaderView;
    }
    
    [self.datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FJOrderGame* game = obj;
        game.isEdit = isEdit;
    }];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    FJOrderGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.game = self.datas[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEditModel) { //如果是编辑模式就不跳转详情页
        return;
    }
    
    FJOrderGame* orderGame = [self.datas objectAtIndex:indexPath.row];
    FJGame* game = [FJGame new];
    game.gameId = orderGame.gameid;
    game.name = orderGame.gameName;
    game.icon = orderGame.icon;
    
    FJGameDetailController* detailVC = [FJGameDetailController new];
    detailVC.game = game;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 提示用户刷新状态
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

#pragma mark - FJOrderGameCellDelegate
- (void)orderGameCellOnDeleteAction:(FJOrderGameCell *)cell
{
    [self.datas removeObject:cell.game];
    [self.collectionView reloadData];
}

- (void)orderGameCellOnLongPressAction:(FJOrderGameCell *)cell
{
    [self onClickEdit:self.editButton];
}

@end
