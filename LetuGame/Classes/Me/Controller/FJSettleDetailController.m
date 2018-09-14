//
//  FJSettleDetailController.m
//  LetuGame
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJSettleDetailController.h"
#import "FJSettleDetailCell.h"
#import "FJSettleDetailModel.h"
#import "FJPromotion.h"

@interface FJSettleDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableArray* datas;

@end

@implementation FJSettleDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
    self.datas = [NSMutableArray arrayWithCapacity:4];
    
    [self createTableView];
    [self requestSettleList];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestSettleList
{
    WEAKSELF
    [HttpTool fetchSettleDetailListWithGameId:self.promotion.gameId month:self.promotion.promotionMonth Success:^(id retObj) {
        STRONGSELF
        DLog(@"retObj = %@", retObj);
        NSDictionary* retDict = retObj;
        if ([retDict[@"code"] isEqualToString:@"1"]) {
            NSArray* arr = retDict[@"data"];
            if (arr == nil || [arr isEqual:[NSNull null]] || arr.count <= 0) {
                //                [FJProgressHUB showInfoWithMessage:@"暂无数据！" withTimeInterval:1.5f];
//                strongSelf.tableView.tableFooterView = self.footerNoData;
                return ;
            }
            [strongSelf.datas removeAllObjects];
            
            NSArray* arrTmp = [FJSettleDetailModel mj_objectArrayWithKeyValuesArray:arr];
            [strongSelf.datas addObjectsFromArray:arrTmp];
            [strongSelf.tableView reloadData];
        } else {
            //            [FJProgressHUB showInfoWithMessage:@"加载用户数据失败！" withTimeInterval:1.5f];
//            strongSelf.tableView.tableFooterView = self.footerNoData;
//            strongSelf.footerNoData.text = @"加载用户失败";
        }
    } failure:^(NSError *error) {
        STRONGSELF
        DLog(@"fetchPromotionList error = %@", error);
        //        [FJProgressHUB showErrorWithMessage:@"加载用户失败，请检查网络！" withTimeInterval:1.5f];
//        strongSelf.tableView.tableFooterView = self.footerNoData;
//        strongSelf.footerNoData.text = @"加载用户失败，请检查网络！";
    }];
}

//创建TableView
-(void)createTableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight-kScreenHeight*0.4, kScreenWidth, kScreenHeight*0.4) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.alpha = 1.0;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
        
        // tableView 偏移20/64适配
        self.extendedLayoutIncludesOpaqueBars = YES;
        CGFloat topMargin = 20;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
            self.tableView.contentInset = UIEdgeInsetsMake(iphoneX?topMargin+20:topMargin, 0, iphoneX?83:49, 0);
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.tableView.contentInset = UIEdgeInsetsMake(topMargin, 0, 49, 0);
        }
        
        [self.view addSubview:_tableView];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.rowHeight = [FJSettleDetailCell height];
        [self.tableView registerNib:[FJSettleDetailCell nib] forCellReuseIdentifier:[FJSettleDetailCell reuseId]];
        
        // 添加头视图
        FJSettleDetailCell* header = [FJSettleDetailCell cell];
        header.frame = CGRectMake(0, 0, self.tableView.fj_width, [FJSettleDetailCell height]);
        self.tableView.tableHeaderView = header;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FJSettleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[FJSettleDetailCell reuseId] forIndexPath:indexPath];
    cell.settle = self.datas[indexPath.row];
    
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return [FJSectionHeader height];
//}
@end
