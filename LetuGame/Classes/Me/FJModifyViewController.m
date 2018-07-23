//
//  FJModifyViewController.m
//  LetuGame
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJModifyViewController.h"

@interface FJModifyViewController ()

@end

@implementation FJModifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置标题
    self.title = @"编辑资料";
    
    //设置数据
    [self setupSections];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupSections
{
    //************************************section1
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"头像";
    item1.executeCode = ^{
        NSLog(@"我的头像");
    };
    item1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"用户名";
    item2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"修改密码";
    item3.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 1;
    section1.itemArray = @[item1, item2, item3];
   
    self.sectionArray = @[section1];
}

@end
