//
//  FJPromotionController.m
//  LetuGame
//
//  Created by admin on 2018/7/30.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJPromotionController.h"
#import "FJPromotionDetailController.h"
#import "FJPromotionCell.h"
#import "FJPromotion.h"

@interface FJPromotionController ()

@end

@implementation FJPromotionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的推广";
    self.tableView.rowHeight = 60;
    self.tableView.sectionHeaderHeight = 40;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FJPromotionCell" bundle:nil] forCellReuseIdentifier:@"FJPromotionCell"];
    
    WEAKSELF
    [HttpTool fetchPromotionListSuccess:^(id retObj) {
        STRONGSELF
        DLog(@"retObj = %@", retObj);
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"];
            if (arr == nil || [arr isEqual:[NSNull null]] || arr.count <= 0) {
                [FJProgressHUB showInfoWithMessage:@"暂无数据！" withTimeInterval:1.5f];
                return ;
            }
            [strongSelf.datas removeAllObjects];
            
            [arr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FJPromotion* p = [FJPromotion mj_objectWithKeyValues:obj];
                p.downloadBean = [FJDownloadBean mj_objectArrayWithKeyValuesArray:obj[@"downloadBean"]];
                [strongSelf.datas addObject:p];
            }];
            [strongSelf.tableView reloadData];
        } else {
            [FJProgressHUB showInfoWithMessage:@"加载数据失败！" withTimeInterval:1.5f];
        }
    } failure:^(NSError *error) {
        DLog(@"fetchPromotionList error = %@", error);
        [FJProgressHUB showErrorWithMessage:@"加载失败，请检查网络！" withTimeInterval:1.5f];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FJPromotionCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FJPromotionCell" forIndexPath:indexPath];
    
    cell.promotion = self.datas[indexPath.row];
    
    // 表格隔行显示不同背景颜色
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = FJRGBColor(250, 250, 253);
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FJPromotionCell *header = [FJPromotionCell cell];
    // 去掉右边的箭头
    header.accessoryView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    header.backgroundColor  = [UIColor lightGrayColor];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    FJPromotionDetailController* detailVC = [[FJPromotionDetailController alloc] init];
    detailVC.promotion = self.datas[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end


