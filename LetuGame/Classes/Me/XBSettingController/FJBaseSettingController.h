//
//  FJBaseSettingController.h
//  LetuGame
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 com.langlun. All rights reserved.
//

#import "FJBaseTableViewController.h"
#import "XBConst.h"
#import "XBSettingCell.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"

@interface FJBaseSettingController : FJBaseTableViewController

@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/

@end
