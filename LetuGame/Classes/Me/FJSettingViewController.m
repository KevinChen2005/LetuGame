//
//  FJSettingViewController.m
//  XBSettingControllerDemo
//
//  Created by XB on 15/9/23.
//  Copyright © 2015年 XB. All rights reserved.
//

#import "FJSettingViewController.h"
#import "XBMeFooterView.h"

#define kSectionHeaderHeight 15

@interface FJSettingViewController () <XBMeFooterViewDelegate>

@property (nonatomic,strong) XBMeFooterView *footer;

@end

@implementation FJSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置标题
    self.title = @"设置";
    
    //设置数据
    [self setupSections];
    
    //设置footer
    if ([UserAuth shared].isLogin) {
        XBMeFooterView *footer = [XBMeFooterView footer];
        footer.delegate = self;
        self.footer = footer;
        self.tableView.tableFooterView = footer;
    }
}

#pragma - mark setup
- (void)setupSections
{
    //************************************section1
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"我的余额";
    item1.executeCode = ^{
        NSLog(@"我的余额");
        [FJPopView showAlertWithTitle:@"点击了" message:@"我的余额"];
    };
    item1.detailText = @"做任务赢大奖";
    item1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"修改密码";
    item2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = kSectionHeaderHeight;
    section1.itemArray = @[item1,item2];
    
    //************************************section2
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"推送提醒";
    item3.accessoryType = XBSettingAccessoryTypeSwitch;
    item3.switchValueChanged = ^(BOOL isOn)
    {
        NSLog(@"推送提醒开关状态===%@",isOn?@"open":@"close");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推送提醒" message:isOn?@"open":@"close" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    };
    
    XBSettingItemModel *item4 = [[XBSettingItemModel alloc]init];
    item4.funcName = @"给我们打分";
    item4.detailImage = [UIImage imageNamed:@"icon-new"];
    item4.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item5 = [[XBSettingItemModel alloc]init];
    item5.funcName = @"意见反馈";
    item5.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc]init];
    section2.sectionHeaderHeight = kSectionHeaderHeight;
    section2.itemArray = @[item3,item4,item5];
    
    //************************************section3
    XBSettingItemModel *item6 = [[XBSettingItemModel alloc]init];
    item6.funcName = @"关于我们";
    item6.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item7 = [[XBSettingItemModel alloc]init];
    item7.funcName = @"帮助中心";
    item7.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item8 = [[XBSettingItemModel alloc]init];
    item8.funcName = @"清除缓存";
    item8.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section3 = [[XBSettingSectionModel alloc]init];
    section3.sectionHeaderHeight = kSectionHeaderHeight;
    section3.sectionFooterHeight = kSectionHeaderHeight;
    section3.itemArray = @[item8, item7, item6];
    
    self.sectionArray = @[section2,section3];
}

#pragma mark - XBMeFooterViewDelegate
- (void)XBMeFooterViewBtnClicked:(XBMeFooterViewButtonType)type
{
    if (type == XBMeFooterViewButtonTypeLogout) {
        //弹出选择框
        [FJPopView showConfirmViewWithTitle:@"提示" message:@"确定退出登录？" okBlock:^{//点击确认
            //删除账户信息
            [UserAuth clean];
            //返回设置页面
            [self.navigationController popViewControllerAnimated:YES];
        } cancelBlock:nil];
    }
}

@end
