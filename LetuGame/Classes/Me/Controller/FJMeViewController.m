//
//  FJMeViewController.m
//  LetuGame
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJMeViewController.h"
#import "XBMeHeaderView.h"
#import "XBMeFooterView.h"
#import "FJSettingViewController.h"
#import "FJLoginViewController.h"
#import "FJModifyViewController.h"
#import "FJCollectionViewController.h"
#import "FJOrderGameController.h"
#import "FJWebViewController.h"
#import "FJPromotionController.h"

@interface FJMeViewController () <XBMeHeaderViewDelegate, XBMeFooterViewDelegate>

@property (nonatomic,strong) XBMeHeaderView *header;
@property (nonatomic,strong) XBMeFooterView *footer;

@end

@implementation FJMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置header
    XBMeHeaderView *header = [XBMeHeaderView header];
    header.delegate = self;
    self.header = header;
    self.tableView.tableHeaderView = header;
    
    //设置footer
    XBMeFooterView *footer = [XBMeFooterView footer];
    footer.delegate = self;
    self.footer = footer;
    self.tableView.tableFooterView = footer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //改变headerView,footerView中信息显示
    [self chanageState];
}

- (void)chanageState
{
    [self.header loginStateChanged:[UserAuth shared].isLogin nickname:[UserAuth shared].userInfo.nickName avatar:[UserAuth shared].userInfo.avatarUrl];
    [self.footer loginStateChanged:[UserAuth shared].isLogin];
    
    //设置数据
    [self setupSections];
}

- (void)setupSections
{
    //************************************section1
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"我的游戏";
    item1.executeCode = ^{
        if (![CommTool isLogined]) {
            [CommTool showLoginPageWithNavVC:self.navigationController];
            return ;
        }
        
        FJOrderGameController* gameVC = [FJOrderGameController create];
        [self.navigationController pushViewController:gameVC animated:YES];
    };
    item1.img = [UIImage imageNamed:@"tu_ic_wodeyouxi"];
//    item1.detailText = @"做任务赢大奖";
    item1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"我的攻略";
    item2.img = [UIImage imageNamed:@"tu_ic_wodeyouxi"];
    item2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item2.executeCode = ^{
        NSLog(@"我的攻略");
    };
    
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"我的收藏";
    item3.img = [UIImage imageNamed:@"tu_ic_wodeshoucang"];
    item3.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item3.executeCode = ^{
        if (![CommTool isLogined]) {
            [CommTool showLoginPageWithNavVC:self.navigationController];
            return ;
        }
        FJCollectionViewController* collectVC = [FJCollectionViewController new];
        [self.navigationController pushViewController:collectVC animated:YES];
    };
    
    XBSettingItemModel *item4 = [[XBSettingItemModel alloc]init];
    item4.funcName = @"我的推广";
    item4.img = [UIImage imageNamed:@"tu_ic_wodetuiguang"];
    item4.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item4.executeCode = ^{
        if (![CommTool isLogined]) {
            [CommTool showLoginPageWithNavVC:self.navigationController];
            return ;
        }
        FJPromotionController* promotionVC = [[FJPromotionController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:promotionVC animated:YES];
    };
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 15;
    if ([UserAuth shared].isLogin && [UserAuth shared].userInfo.isSpreader){//是推广员，并且登录
        section1.itemArray = @[item1, item3, item4];
    } else {
        section1.itemArray = @[item1, item3];
    }
    
    XBSettingItemModel *item5 = [[XBSettingItemModel alloc]init];
    item5.funcName = @"获得帮助";
    item5.img = [UIImage imageNamed:@"tu_ic_huodebangzu"];
    item5.executeCode = ^{
        FJWebViewController* vc = [FJWebViewController new];
        vc.title = @"帮助";
        vc.htmlString = [CommTool contentForFileName:@"me_help" ofType:@"html"];
        [self.navigationController pushViewController:vc animated:YES];
    };
    item5.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
//    XBSettingItemModel *item6 = [[XBSettingItemModel alloc]init];
//    item6.funcName = @"意见反馈";
//    item6.img = [UIImage imageNamed:@"icon-list01"];
//    item6.executeCode = ^{
//
//    };
//    item6.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item7 = [[XBSettingItemModel alloc]init];
    item7.funcName = @"关于我们";
    item7.img = [UIImage imageNamed:@"tu_ic_guanyuwomen"];
    item7.executeCode = ^{
        FJWebViewController* vc = [FJWebViewController new];
        vc.title = @"关于我们";
        vc.htmlString = [CommTool contentForFileName:@"me_aboutme" ofType:@"html"];
        [self.navigationController pushViewController:vc animated:YES];
    };
    item7.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item8 = [[XBSettingItemModel alloc]init];
    item8.funcName = @"当前版本";
    item8.img = [UIImage imageNamed:@"tu_ic_dangqianbanben"];
    item8.detailText = [FJVersionCheck shareInstance].currentVersion;
    item8.executeCode = ^{
        if ([FJVersionCheck shareInstance].isNeedUpdate) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [FJPopView showConfirmViewWithTitle:@"提示" message:@"检测到新版本，是否去更新？" okTitle:@"更新" cancelTitle:@"以后再说" okBlock:^{//点击确认
                    [[FJVersionCheck shareInstance] gotoUpdate];
                } cancelBlock:nil];
            });
        }
    };
    item8.isForbidSelect = YES;
    if ([FJVersionCheck shareInstance].isNeedUpdate) {
        item8.detailImage = [UIImage imageNamed:@"icon-new"];
        item8.isForbidSelect = NO;
        item8.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    }
    
    XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc]init];
    section2.sectionHeaderHeight = 15;
    section2.sectionFooterHeight = 15;
    section2.itemArray = @[item5, item7];
    section2.itemArray = @[item5, item7, item8];
    
    self.sectionArray = @[section1,section2];
    
    [self.tableView reloadData];
}

#pragma mark - XBMeHeaderView delegate
- (void)XBMeHeaderViewBtnClicked:(XBMeHeaderViewButtonType)type
{
    if (type == XBMeHeaderViewButtonTypeLogin) { //登录
        DLog(@"点击登录");
        FJLoginViewController* vc = [[FJLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (type == XBMeHeaderViewButtonTypeUserinfo) {
        DLog(@"点击显示用户资料");
        FJModifyViewController* vc = [[FJModifyViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - XBMeFooterViewDelegate
- (void)XBMeFooterViewBtnClicked:(XBMeFooterViewButtonType)type
{
    if (type == XBMeFooterViewButtonTypeLogout) {
        //弹出选择框
        [FJPopView showConfirmViewWithTitle:@"提示" message:@"确定退出登录？" okBlock:^{//点击确认
            //删除账户信息
            [UserAuth clean];
            [self chanageState];
        } cancelBlock:nil];
    }
    
    if (type == XBMeFooterViewButtonTypeLogin) {
        FJLoginViewController* vc = [[FJLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取偏移量
    CGPoint offset = scrollView.contentOffset;
    
    //判断是否改变
    if (offset.y < 0) {
        CGRect rect = self.header.bgView.frame;
        //我们只需要改变图片的y值和高度即可
        rect.origin.y = offset.y;
        rect.size.height = 70 - offset.y;
        self.header.bgView.frame = rect;
    }
}


@end
