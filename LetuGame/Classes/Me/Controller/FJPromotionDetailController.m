//
//  FJPromotionDetailController.m
//  LetuGame
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJPromotionDetailController.h"
#import "FJPromotion.h"
#import "FJPromotionDeteilHeader.h"
#import "FJPromotionDetailModel.h"
#import "FJPromotionDetailCell.h"

@interface FJPromotionDetailController ()

@property (nonatomic, strong)UILabel* footerNoData;
@property (nonatomic, strong)UIView* footerLine;

@end

@implementation FJPromotionDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [NSString stringWithFormat:@"《%@》- 推广详情", self.promotion.gameName];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.rowHeight = [FJPromotionDetailCell height];
    [self.tableView registerNib:[FJPromotionDetailCell nib] forCellReuseIdentifier:[FJPromotionDetailCell reuseId]];
    
    // 添加头视图
    FJPromotionDeteilHeader* header = [FJPromotionDeteilHeader header];
    header.promotion = self.promotion;
    header.frame = CGRectMake(0, 0, self.tableView.fj_width, [FJPromotionDeteilHeader height]);
    self.tableView.tableHeaderView = header;
    
    //设置tableview的footerview为UILabel
    UILabel* footerNoData = [UILabel new];
    footerNoData.text = @"暂无数据!";
    footerNoData.font = [UIFont systemFontOfSize:16];
    footerNoData.frame = CGRectMake(20, 0, kScreenWidth, 60);
    self.tableView.tableFooterView = footerNoData;
    self.footerNoData = footerNoData;
    
    //设置tableview的footerview为一条灰线
    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.8)];
    footer.backgroundColor = FJRGBColor(230, 230, 230);
    self.tableView.tableFooterView = footer;
    self.footerLine = footer;
    
    [self requestPromotionListWithStartTime:self.promotion.startDate endTime:self.promotion.endDate];
}

- (void)requestPromotionListWithStartTime:(NSDate*)startDate endTime:(NSDate*)endDate
{
    WEAKSELF
    [HttpTool fetchPromotionDetailListWithGameId:self.promotion.gameId startTime:startDate endTime:endDate Success:^(id retObj) {
        STRONGSELF
        DLog(@"retObj = %@", retObj);
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"];
            if (arr == nil || [arr isEqual:[NSNull null]] || arr.count <= 0) {
//                [FJProgressHUB showInfoWithMessage:@"暂无数据！" withTimeInterval:1.5f];
                strongSelf.tableView.tableFooterView = self.footerNoData;
                return ;
            }
            [strongSelf.datas removeAllObjects];
            
            NSArray* arrTmp = [FJPromotionDetailModel mj_objectArrayWithKeyValuesArray:arr];
            [strongSelf.datas addObjectsFromArray:arrTmp];
            [strongSelf.tableView reloadData];
        } else {
//            [FJProgressHUB showInfoWithMessage:@"加载用户数据失败！" withTimeInterval:1.5f];
            strongSelf.tableView.tableFooterView = self.footerNoData;
            strongSelf.footerNoData.text = @"加载用户失败";
        }
    } failure:^(NSError *error) {
        STRONGSELF
        DLog(@"fetchPromotionList error = %@", error);
//        [FJProgressHUB showErrorWithMessage:@"加载用户失败，请检查网络！" withTimeInterval:1.5f];
        strongSelf.tableView.tableFooterView = self.footerNoData;
        strongSelf.footerNoData.text = @"加载用户失败，请检查网络！";
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FJPromotionDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:[FJPromotionDetailCell reuseId] forIndexPath:indexPath];
    
    cell.promotionDetail = [self.datas objectAtIndex:indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FJPromotionDetailCell *header = [FJPromotionDetailCell cell];
    header.backgroundColor  = FJRGBColor(249, 249, 249);
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [FJPromotionDetailCell height];
}

@end


