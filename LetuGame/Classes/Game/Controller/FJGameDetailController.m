//
//  FJGameDetailController.m
//  LetuGame
//
//  Created by admin on 18/7/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "FJGameDetailController.h"
#import "NavHeadTitleView.h"
#import "HeadImageView.h"
#import "HeadLineView.h"
#import "FJGameToolbar.h"
#import "FJGame.h"
#import "FJGameDetail.h"
#import "FJStrategyController.h"
#import "FJWriteStrategyController.h"

@interface FJGameDetailController () <NavHeadTitleViewDelegate, headLineDelegate, FJGameToolbarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    //头像
    UIImageView *_headerImg;
    //昵称
    UILabel *_nickLabel;
}

@property(nonatomic,strong)UIImageView *backgroundImgV;//背景图
@property(nonatomic,assign)float backImgHeight;
@property(nonatomic,assign)float backImgWidth;
@property(nonatomic,assign)float backImgOrgy;
@property(nonatomic,assign)int rowHeight;
@property(nonatomic,strong)NavHeadTitleView *NavView;//导航栏
@property(nonatomic,strong)HeadImageView *headImageView;//头视图
@property(nonatomic,strong)HeadLineView *headLineView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)FJGameToolbar *toolbar;
@property(nonatomic,strong)UIView *cover;
@property(nonatomic,strong)FJGameDetail *detail;

@end

@implementation FJGameDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.detail = [FJGameDetail new];
    
    //拉伸顶部图片
    [self lashenBgView];
    
    //创建导航栏
    [self createNav];
    
    //创建TableView
    [self createTableView];
    
    
    //创建toolbar
    _toolbar = [FJGameToolbar toolbar];
    _toolbar.delegate = self;
    _toolbar.frame = CGRectMake(0, kScreenHeight-[FJGameToolbar height], kScreenWidth, [FJGameToolbar height]);
    [self.view addSubview:_toolbar];
    
    // 加入遮盖，在数据加载完后移除
    UIView* cover = [UIView new];
    cover.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.cover = cover;
    
    //加载数据
    [HttpTool fetchGameDetailWithGameId:self.game.gameId success:^(id retObj) {
        DLog(@"retObj = %@", retObj);
        [self endLoading];
    
        if (retObj && [retObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary* retDict = retObj;
            NSString* code = retDict[@"code"];
            NSString* message = retDict[@"message"];
            if ([code isEqualToString:@"1"]) { //请求成功
                [self loadSuccess:retDict[@"data"]];
            } else {
                NSString* msg = [NSString stringWithFormat:@"获取游戏详情失败，%@", message];
                [FJProgressHUB showErrorWithMessage:msg withTimeInterval:kTimeHubError];
            }
        } else {
            [FJProgressHUB showErrorWithMessage:@"获取游戏详情失败，返回数据错误" withTimeInterval:kTimeHubError];
        }
    } failure:^(NSError *error) {
        DLog(@"error = %@", error);
        [self endLoading];
        
        [FJProgressHUB showErrorWithMessage:@"获取游戏详情失败，请检查网络" withTimeInterval:kTimeHubError];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)endLoading
{
    [FJProgressHUB dismiss];
    [self.cover removeFromSuperview];
}

- (void)loadSuccess:(NSDictionary*)dictData
{
    self.detail.gameInfo = [FJGameInfo mj_objectWithKeyValues:dictData[@"gameInfo"]];
    NSArray* arr = [FJGamePic mj_objectArrayWithKeyValuesArray:dictData[@"pic"]];
    self.detail.picArray = arr;
    
    NSInteger picCount = self.detail.picArray.count;
    if (picCount > 0) {
        FJGamePic* bgPic = [self.detail.picArray objectAtIndex:picCount-1];
        [self.backgroundImgV sd_setImageWithURL:[NSURL URLWithString:bgPic.url] placeholderImage:[UIImage imageNamed:@"img_place_holder"]];
    }
    self.headLineView.detail = self.detail;
}

//拉伸顶部图片
-(void)lashenBgView
{
    _backgroundImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.3)];
    _backgroundImgV.image=[UIImage imageNamed:@"img_place_holder"];
    _backgroundImgV.userInteractionEnabled=YES;
    [self.view addSubview:_backgroundImgV];
    
    _backImgHeight=_backgroundImgV.frame.size.height;
    _backImgWidth=_backgroundImgV.frame.size.width;
    _backImgOrgy=_backgroundImgV.frame.origin.y;
}

//创建TableView
-(void)createTableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-[FJGameToolbar height]) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    
    [_tableView setTableHeaderView:[self headImageView]];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    UIView *targetview = sender.view;
    if(targetview.tag == 1) {
        return;
    }
}

//头视图
-(HeadImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView=[[HeadImageView alloc]init];
        _headImageView.frame=CGRectMake(0, 64, kScreenWidth, 170);
        _headImageView.backgroundColor=[UIColor clearColor];
    }
    
    return _headImageView;
}

-(void)createNav
{
    self.NavView=[[NavHeadTitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.NavView.title=@"游戏详情";
    self.NavView.color=[UIColor whiteColor];
    self.NavView.backTitleImage=@"nav_back_arrow_white";
    self.NavView.rightTitleImage=@"Setting";
    self.NavView.delegate=self;
    [self.view addSubview:self.NavView];
}

//左按钮
-(void)NavHeadback
{
    [self.navigationController popViewControllerAnimated:YES];
}

//右按钮回调(我要玩)
-(void)NavHeadToRight
{
    if ([CommTool isLogined] == NO) {
        [CommTool showLoginPageWithNavVC:self.navigationController];
        return;
    }
    
    [CommTool wantPlayGame:self.detail.gameInfo.ID];
}

#pragma mark ---- UITableViewDelegate ----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [HeadLineView height];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_headLineView) {
        _headLineView=[HeadLineView headLineView];
        _headLineView.frame=CGRectMake(0, 0, kScreenWidth, [HeadLineView height]);
        _headLineView.delegate=self;
    }
    
    return _headLineView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建一个静态标识符  来给每一个cell 加上标记  方便我们从复用队列里面取到 名字为该标记的cell
    static NSString *reusID=@"ID";
    //我创建一个cell 先从复用队列dequeue 里面 用上面创建的静态标识符来取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusID];
    //做一个if判断  如果没有cell  我们就创建一个新的 并且 还要给这个cell 加上复用标识符
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusID];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell被点击恢复
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsety = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y<=170) {
        self.NavView.headBgView.alpha=scrollView.contentOffset.y/170;
        self.NavView.backTitleImage=@"nav_back_arrow_white";
        self.NavView.rightImageView=@"Setting";
        self.NavView.color=[UIColor whiteColor];
        //状态栏字体白色
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    }else{
        self.NavView.headBgView.alpha=1;
        //self.NavView.title
        self.NavView.backTitleImage=@"nav_back_arrow";
        self.NavView.rightImageView=@"Setting-click";
        self.NavView.color=[UIColor blackColor];
        //隐藏黑线
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        //状态栏字体黑色
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    }
    
    if (contentOffsety<0) {
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight-contentOffsety;
        rect.size.width = _backImgWidth* (_backImgHeight-contentOffsety)/_backImgHeight;
        rect.origin.x =  -(rect.size.width-_backImgWidth)/2;
        rect.origin.y = 0;
        _backgroundImgV.frame = rect;
    }else{
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight;
        rect.size.width = _backImgWidth;
        rect.origin.x = 0;
        rect.origin.y = -contentOffsety;
        _backgroundImgV.frame = rect;
    }
}

#pragma mark - FJGameToolbarDelegate

- (void)gameToolbarOnClickShowStrategyList:(FJGameToolbar *)toolbar
{
    FJStrategyController* strategyVC = [FJStrategyController new];
    strategyVC.game = self.game;
    
    [self.navigationController pushViewController:strategyVC animated:YES];
}

-(void)gameToolbarOnClickWriteStrategy:(FJGameToolbar *)toolbar
{
    if ([CommTool isLogined] == NO) {
        [CommTool showLoginPageWithNavVC:self.navigationController];
        return;
    }
    
    FJWriteStrategyController* writeVC = [FJWriteStrategyController new];
    writeVC.game = self.game;
    
    [self.navigationController pushViewController:writeVC animated:YES];
}

// 返回状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
