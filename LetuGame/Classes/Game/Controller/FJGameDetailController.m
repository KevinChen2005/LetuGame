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
#import "RichTextViewController.h"
#import "PictureModel.h"

@interface FJGameDetailController () <NavHeadTitleViewDelegate, FJGameToolbarDelegate, UITableViewDataSource, UITableViewDelegate, RichTextViewControllerDelegate>
{
    //头像
    UIImageView *_headerImg;
    //昵称
    UILabel *_nickLabel;
}
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)NSMutableDictionary *dictWork;//存放上传计数

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
    
    self.dictWork = [NSMutableDictionary dictionary];
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
    
    self.backgroundImgV.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.backgroundImgV.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
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
    [self.tableView reloadData];
}

//拉伸顶部图片
-(void)lashenBgView
{
    _backgroundImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
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
        
        // tableView 偏移20/64适配
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
//        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
//        _tableView.scrollIndicatorInsets = self.tableView.contentInset;
        
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
    }
    
    return _headLineView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusID=@"ID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusID];
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
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
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
    
//    FJWriteStrategyController* writeVC = [FJWriteStrategyController new];
//    writeVC.game = self.game;
//    [self.navigationController pushViewController:writeVC animated:YES];
    
    RichTextViewController * ctrl=[RichTextViewController ViewController];
    ctrl.game = self.game;
    //需要返回的是网页,开启代理
    ctrl.RTDelegate=self;
    //控制 文字是否需要 颜色，大小等属性
    ctrl.textType = RichTextType_HtmlString;
//    __weak typeof(self) weakSelf=self;
    //    无需返回网页
    ctrl.finished=^(id content,NSArray * imageArr){
//        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark RichTextViewControllerDelegate 生成网页
-(void)uploadImageArray:(NSArray *)imageArr withCompletion:(NSString * (^)(NSArray * urlArray))completion;
{
    
    //上传图片
    
    //    //比如这是服务器返回的数据
    //   /*
    //
    //    url="http://photocdn.sohu.com/20160426/Img446187083.jpg",
    //    W=320,
    //    H=390,
    //    */
    //    //把图片地址传入
    //    NSMutableArray * urlArr=[NSMutableArray array];
    //    //模拟图片上传，返回每个图片的地址和大小
    //    for (int i=0; i<imageArr.count; i++) {
    //        PictureModel * model=[[PictureModel alloc]init];
    //        model.imageurl=@"http://photocdn.sohu.com/20160426/Img446187083.jpg";
    //        [urlArr addObject:model];
    //    }
    
    if (!imageArr || ![imageArr isKindOfClass:[NSArray class]] || imageArr.count==0) {
        if (completion) {
            completion(@[]);
        }
        return;
    }
    
    self.count = 0;
    [self.dictWork removeAllObjects];
    
    NSInteger countWork = imageArr.count;
    
    for (int i=0; i<imageArr.count; i++) {
        UIImage* image = imageArr[i];
        [HttpTool uploadPicWithType:@"news" image:image Success:^(id retObj) {
            DLog(@"retObj = %@", retObj);
            
            NSDictionary* retDict = retObj;
            if ([retDict[@"code"] isEqualToString:@"1"]) {
                NSString* url = retDict[@"data"];
//                if (!url || [url isKindOfClass:[NSNull class]] || [url isEqualToString:@""]) {
//                    return ;
//                }
                PictureModel* pic = [PictureModel new];
                pic.imageurl = url;
                pic.width = image.size.width;
                pic.height = image.size.height;
                
                NSString* index = [NSString stringWithFormat:@"%d", i];
                [self.dictWork setObject:pic forKey:index];
                
                self.count++;
                if (self.count == countWork) {
                    if (completion) {
                        NSMutableArray* arr = [NSMutableArray arrayWithCapacity:countWork];
                        for (int j=0; j<countWork; j++) {
                            NSString* strIndex = [NSString stringWithFormat:@"%d", j];
                            [arr addObject:[self.dictWork objectForKey:strIndex]];
                        }
                        NSString* json = completion([arr copy]);
                        NSLog(@"json = %@", json);
                    }
                }
            } else {
                [FJProgressHUB showErrorWithMessage:retDict[@"message"] withTimeInterval:kTimeHubError];
            }
        } failure:^(NSError *error) {
            [FJProgressHUB showErrorWithMessage:@"上传失败，请检查网络" withTimeInterval:kTimeHubError];
        }];
    }
    
    
}

@end


