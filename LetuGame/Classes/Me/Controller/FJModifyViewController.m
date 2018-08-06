//
//  FJModifyViewController.m
//  LetuGame
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJModifyViewController.h"
#import "FJModifyAvatarController.h"
#import "FJModifyPwdController.h"
#import "FJModifyNicknameController.h"

@interface FJModifyViewController ()
{
    XBSettingItemModel* _updateNickNameMode;
    XBSettingItemModel* _updateAvatarMode;
}

@end

@implementation FJModifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置标题
    self.title = @"个人信息";
    
    //设置数据
    [self setupSections];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)setupSections
{
    //************************************section1
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"头像";
    item1.executeCode = ^{
        FJModifyAvatarController* modifyVC = [FJModifyAvatarController new];
        [self.navigationController pushViewController:modifyVC animated:YES];
    };
    item1.detailImageURL = [UserAuth shared].userInfo.avatarUrl;
    if ([[UserAuth shared].userInfo.avatarUrl isNullString]) {
        item1.detailImage = [UIImage imageNamed:@"avatar_default"];
    }
    
    item1.isAvatar = YES;
    item1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    _updateAvatarMode = item1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAvatarSuccess:) name:kNotificationModifyAvatarSuccess object:nil];
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"昵称";
    item2.detailText = [UserAuth shared].userInfo.nickName;
    item2.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item2.executeCode = ^{
        FJModifyNicknameController* modifyNameVC = [FJModifyNicknameController new];
        [self.navigationController pushViewController:modifyNameVC animated:YES];
    };
    _updateNickNameMode = item2;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNicknameSuccess:) name:kNotificationModifyNicknameSuccess object:nil];
    
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"修改密码";
    item3.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item3.executeCode = ^(){
        FJModifyPwdController* modifyPwdVC = [FJModifyPwdController new];
        [self.navigationController pushViewController:modifyPwdVC animated:YES];
    };
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 0.01;
    section1.itemArray = @[item1, item2, item3];
   
    self.sectionArray = @[section1];
}

//修改昵称成功的通知回调
- (void)changeNicknameSuccess:(NSNotification*)notification
{
    _updateNickNameMode.detailText = [UserAuth shared].userInfo.nickName;
    [self.tableView reloadData];
}

//修改头像成功的通知回调
- (void)changeAvatarSuccess:(NSNotification*)notification
{
    NSDictionary* userinfo = notification.userInfo;
    _updateAvatarMode.detailImage = userinfo[@"image"];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) { //头像行的高度
        return 70;
    }
    
    return 48;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
